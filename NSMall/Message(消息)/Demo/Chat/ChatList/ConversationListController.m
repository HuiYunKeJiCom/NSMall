/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ConversationListController.h"

#import "ChatViewController.h"
#import "RobotManager.h"
#import "RobotChatViewController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
#import "ChatDemoHelper.h"
#import "EMDingMessageHelper.h"
#import "NSNavView.h"
#import "UIViewController+SearchController.h"
#import "ContactListViewController.h"
#import "NSEaseConversationModel.h"
#import "NSMessageAPI.h"
#import "AEIconView.h"
#import "NSGroupAPI.h"


@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.type == EMConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:self.conversationId]) {
            return [[RobotManager sharedInstance] getRobotNickWithUsername:self.conversationId];
        }
        return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.conversationId];
    } else if (self.type == EMConversationTypeGroupChat) {
        if ([self.ext objectForKey:@"subject"] || [self.ext objectForKey:@"isPublic"]) {
            return [self.ext objectForKey:@"subject"];
        }
    }
    return self.conversationId;
}

@end

@interface ConversationListController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource,EMSearchControllerDelegate>

@property (nonatomic, strong) UIView *networkStateView;

@end

@implementation ConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
//    self.friendListArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    self.images = [NSMutableArray array];
    
    [self networkStateView];
    
    [self setupSearchController];
    
    [self tableViewDidTriggerHeaderRefresh];
    [self removeEmptyConversationsFromDB];
    [self setUpNavTopView];
    self.tableView.backgroundColor = KBGCOLOR;
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    NSNavView *topToolView = [[NSNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"消息")];
    [topToolView setRightItemImage:@"message_ico_head"];
    
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [[DCTabBarController sharedTabBarVC] goToSelectedViewControllerWith:0];
    };
    
    topToolView.rightItemClickBlock = ^{
        //跳转到通讯录
        [weakSelf goToContactListViewController];
    };
    
    [self.view addSubview:topToolView];
    
}

-(void)goToContactListViewController{
    ContactListViewController *contactListVC = [ContactListViewController new];
    [self.navigationController pushViewController:contactListVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

#pragma mark - getter

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

- (void)deleteCellAction:(NSIndexPath *)aIndexPath
{
    NSEaseConversationModel *model = [self.dataArray objectAtIndex:aIndexPath.row];
    [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:nil];
    [self.dataArray removeObjectAtIndex:aIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:aIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [[EMDingMessageHelper sharedHelper] deleteConversation:model.conversation.conversationId];
}

#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
                RobotChatViewController *chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
                [self.navigationController pushViewController:chatController animated:YES];
            } else {
                ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                if(conversation.type == EMConversationTypeChat){
                    chatController.title = conversationModel.title;
                    [self.navigationController pushViewController:chatController animated:YES];
                }else{
                    chatController.title = [conversation.ext objectForKey:@"groupName"];
                    chatController.groupOwn = [conversation.ext objectForKey:@"groupOwn"];
                    
                    [NSGroupAPI getUserGroupListWithParam:nil success:^(NSGroupListModel *groupModel) {
                        DLog(@"获取群组列表成功");
                        for (NSGroupModel *model in groupModel.group) {
                            if([model.group_id isEqualToString:conversation.conversationId]){
                                chatController.groupCount = model.affiliations_count;
                            }
                        }
                        [self.navigationController pushViewController:chatController animated:YES];
                    } faulre:^(NSError *error) {
                        DLog(@"获取群组列表失败");
                    }];

                }
                //                DLog(@"chatController.title = %@",chatController.title);
                
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.tableView reloadData];
    }
}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    
    
    NSEaseConversationModel *model = [[NSEaseConversationModel alloc] initWithConversation:conversation];
//     conversation.ext;
//    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    if (model.conversation.type == EMConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
            model.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
        } else {
            
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:conversation.conversationId];
            if (profileEntity) {
                model.title = profileEntity.nickname;
                model.avatarURLPath = profileEntity.imageUrl;
            }
//            NSHuanXinUserModel *hxModel = [[NSHuanXinUserModel alloc] initWithBuddy:model.title];
            
            EMMessage *latestMessage = model.conversation.lastReceivedMessage;
            NSDictionary *ext = latestMessage.ext;
            
            model.title = [ext objectForKey:@"nick"];
            
//            model.title = hxModel.nickname;
            //            model.title = @"我是笨蛋";
        }
        //        model.title = @"我是笨蛋";
        
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
//        DLog(@"conversationId = %@",conversation.conversationId);
        WEAKSELF
        [NSGroupAPI getGroupWithParam:conversation.conversationId success:^(NSGroupModel *groupModel) {
            DLog(@"获取群组信息成功");
            conversation.ext = @{@"groupOwn":groupModel.owner,@"groupName":groupModel.group_name};
            [self.images removeAllObjects];
            NSDictionary *tempDict = [self dictionaryWithJsonString:groupModel.group_name_json];
            NSMutableArray *groupMembers = [NSMutableArray array];
            groupMembers =  [tempDict objectForKey:@"jsonArray"];
            
            NSString *groupName = @"";
            for (int i=0;i<groupMembers.count;i++) {
                NSDictionary *dict = groupMembers[i];
                NSHuanXinUserModel *model = [NSHuanXinUserModel new];
                model.user_avatar = [dict objectForKey:@"avatar"];
                model.hx_user_name = [dict objectForKey:@"hxUsername"];
                model.nick_name = [dict objectForKey:@"nick"];
                //        [self.membersArr addObject:model];
                if(i == 0){
                    groupName = [NSString stringWithFormat:@"%@",model.nick_name];
                }else{
                    groupName = [groupName stringByAppendingFormat:@"、%@",model.nick_name];
                }
                if(i<6){
                    [self.images addObject:model.user_avatar];
                }
                //
            }
            
            model.title = groupName;
            
            AEIconView *iconV = [[AEIconView alloc] initWithFrame:CGRectMake(10, 2, 45, 45)];
            iconV.image = [UIImage imageNamed:@"group_header"];
            //设置背景色
            iconV.backgroundColor = [UIColor lightGrayColor];
            iconV.images = self.images;
            model.avatarImage = [self imageWithUIView:iconV];
            [weakSelf.tableView reloadData];
            
        } faulre:^(NSError *error) {
            DLog(@"获取群组信息失败");
        }];
        
        
    }
    return model;
}

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        NSDictionary *extTemp = lastMessage.ext;
        if (lastMessage.direction == EMMessageDirectionReceive) {
            NSString *from = lastMessage.from;
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:from];
            if (profileEntity) {
                from = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
            }
            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", [extTemp objectForKey:@"nick"], latestMessageTitle];
        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
        }
        else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
//    DLog(@"timestamp = %lld",lastMessage.timestamp);
    
    
    return latestMessageTime;
}

#pragma mark - EMSearchControllerDelegate

- (void)cancelButtonClicked
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
}

- (void)searchTextChangeWithString:(NSString *)aString
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataArray searchText:aString collationStringSelector:@selector(title) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.resultController.displaySource removeAllObjects];
                [weakSelf.resultController.displaySource addObjectsFromArray:results];
                [weakSelf.resultController.tableView reloadData];
            });
        }
    }];
}

#pragma mark - private

- (void)setupSearchController
{
    //改动过
    //    [self enableSearchController];
    [self disableSearchController];
    
    __weak ConversationListController *weakSelf = self;
    [self.resultController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
        EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        id<IConversationModel> model = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        
        EMConversation *conversation = model.conversation;
        EMMessage *latestMessage = conversation.lastReceivedMessage;
        NSDictionary *ext = latestMessage.ext;
        
        model.title = [ext objectForKey:@"nick"];
        cell.model = model;
        cell.detailLabel.attributedText = [weakSelf conversationListViewController:weakSelf latestMessageTitleForConversationModel:model];
        cell.timeLabel.text = [weakSelf conversationListViewController:weakSelf latestMessageTimeForConversationModel:model];
        return cell;
    }];
    
    [self.resultController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        return [EaseConversationCell cellHeightWithModel:nil];
    }];
    
    [self.resultController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [weakSelf.searchController.searchBar endEditing:YES];
        id<IConversationModel> model = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        EMConversation *conversation = model.conversation;
        
        ChatViewController *chatController;
        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
            chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
            chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
        }else {
            chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
            NSDictionary *dict = conversation.ext;
            chatController.title = [dict objectForKey:@"nick"];
            //            chatController.title = [conversation showName];
        }
        [weakSelf.navigationController pushViewController:chatController animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [weakSelf.tableView reloadData];
        
        [weakSelf cancelSearch];
    }];
    
    UISearchBar *searchBar = self.searchController.searchBar;
    [self.view addSubview:searchBar];
    self.tableView.frame = CGRectMake(0, searchBar.frame.size.height+TopBarHeight, self.view.frame.size.width,self.view.frame.size.height - searchBar.frame.size.height-TopBarHeight);
    //    self.tableView.tableHeaderView = searchBar;
    //    [searchBar sizeToFit];
}

#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}


- (UIImage*) imageWithUIView:(UIView*) view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

//json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)tableViewDidTriggerHeaderRefresh
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
//    for (EMConversation *conversation in conversations) {
//        DLog(@"conversation.ext = %@",conversation.ext);
//    }
    
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           
                           NSString *obj1Bool = [obj1.ext objectForKey:@"topSwitch"];
                           NSString *obj2Bool = [obj2.ext objectForKey:@"topSwitch"];
                           NSString *date1Str = [obj1.ext objectForKey:@"setTime"];
                           NSString *date2Str = [obj2.ext objectForKey:@"setTime"];
                           
                           if([obj1Bool isEqualToString:@"20"] && [obj2Bool isEqualToString:@"20"]){
                               //均置顶
                               if([date1Str integerValue] > [date2Str integerValue]){
                                   return(NSComparisonResult)NSOrderedAscending;
                               }else{
                                   return(NSComparisonResult)NSOrderedDescending;
                               }
                               
                           }else if([obj1Bool isEqualToString:@"20"]){
                               //一个置顶,一个不置顶
                               return(NSComparisonResult)NSOrderedAscending;
                           }else if([obj2Bool isEqualToString:@"20"]){
                               //一个置顶,一个不置顶
                               return(NSComparisonResult)NSOrderedDescending;
                           } else{
                               //均不置顶
                               if(message1.timestamp > message2.timestamp) {
                                   return(NSComparisonResult)NSOrderedAscending;
                               }else {
                                   return(NSComparisonResult)NSOrderedDescending;
                               }
                           }
                       }];
    
    
    
    [self.dataArray removeAllObjects];
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
            model = [self.dataSource conversationListViewController:self
                                               modelForConversation:converstion];
        }
        else{
            model = [[EaseConversationModel alloc] initWithConversation:converstion];
        }
        
        if (model) {
            [self.dataArray addObject:model];
        }
    }
    
    [self.tableView reloadData];
    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}

@end


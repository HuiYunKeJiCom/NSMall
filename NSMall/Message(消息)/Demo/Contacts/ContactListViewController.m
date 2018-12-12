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

//通讯录

#import "ContactListViewController.h"

#import "ChatViewController.h"
#import "RobotListViewController.h"
#import "ChatroomListViewController.h"
//#import "AddFriendViewController.h"
#import "NSAddFriendVC.h"
#import "ApplyViewController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
#import "UserProfileManager.h"
#import "NSNavView.h"
#import "NSMessageAPI.h"
#import "NSFriendListModel.h"
#import "NSHuanXinUserModel.h"

#import "BaseTableViewCell.h"
#import "UIViewController+SearchController.h"

#if DEMO_CALL == 1
#import "DemoConfManager.h"
#endif

@implementation NSString (search)

//根据用户昵称进行搜索
- (NSString*)showName
{
    return [[UserProfileManager sharedInstance] getNickNameWithUsername:self];
}

@end

@interface ContactListViewController ()<UISearchBarDelegate, UIActionSheetDelegate, EaseUserCellDelegate, EMSearchControllerDelegate,EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate>
{
    NSIndexPath *_currentLongPressIndex;
}

@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *contactsSource;

@property (nonatomic) NSInteger unapplyCount;

@property (nonatomic) NSIndexPath *indexPath;

@property (nonatomic, strong) NSArray *otherPlatformIds;

@property(nonatomic,strong)NSMutableArray *friendListArr;/* 好友列表数组 */

@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    self.showRefreshHeader = YES;
//    [self.navigationController setNavigationBarHidden:YES];
    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    self.friendListArr = [NSMutableArray array];
    
    // 环信UIdemo中有用到Parse, 加载用户好友个人信息
//    [[UserProfileManager sharedInstance] loadUserProfileInBackgroundWithBuddy:self.contactsSource saveToLoacal:YES completion:NULL];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    //移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
    
    [self setupSearchController];
    [self setUpNavTopView];
    self.tableView.backgroundColor = KBGCOLOR;
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    NSNavView *topToolView = [[NSNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"通讯录")];
//    [topToolView setRightItemTitle:KLocalizableStr(@"添加好友")];
    [topToolView setRightItemImage:@"ico_add"];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    topToolView.rightItemClickBlock = ^{
        //添加好友
        [weakSelf addContactAction];
    };
    
    [self.view addSubview:topToolView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadApplyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (NSArray *)rightItems
{
    if (_rightItems == nil) {
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [addButton setImage:[UIImage imageNamed:@"addContact.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addContactAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        _rightItems = @[addItem];
    }
    
    return _rightItems;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataArray count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
//    else if (section == 1) {
//        return [self.otherPlatformIds count];
//    }
    
    return [[self.dataArray objectAtIndex:(section - 1)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            NSString *CellIdentifier = @"addFriend";
//            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil) {
//                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            }
//            cell.avatarView.image = [UIImage imageNamed:@"newFriends"];
//            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
//            cell.avatarView.badge = self.unapplyCount;
//            return cell;
//        }
        
        NSString *CellIdentifier = @"commonCell";
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.avatarView.image = [UIImage imageNamed:@"message_ico_group_chat"];
            cell.titleLabel.text = @"群聊";
        }
//        else if (indexPath.row == 2) {
//            cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
//            cell.titleLabel.text = NSLocalizedString(@"title.chatroom",@"chatroom");
//        }
//        else if (indexPath.row == 3) {
//            cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_videoCall"];
//            cell.titleLabel.text = NSLocalizedString(@"title.conference",@"Mutil Conference");
//        }
//        else if (indexPath.row == 4) {
//            cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_videoCall"];
//            cell.titleLabel.text = NSLocalizedString(@"title.customConference",@"Custom Video Conference");
//        }
        
        return cell;
    }
//    else if (indexPath.section == 1) {
//        NSString *CellIdentifier = @"OtherPlatformIdCell";
//        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//        // Configure the cell...
//        if (cell == nil) {
//            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
//        cell.titleLabel.text = [self.otherPlatformIds objectAtIndex:indexPath.row];
//
////        NSString *showName = [[UserProfileManager sharedInstance] getNickNameWithUsername:[self.otherPlatformIds objectAtIndex:indexPath.row]];
////        DLog(@"showName = %@",showName);
//
//        return cell;
//
//    }
    else {
        NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
        if(userSection.count > indexPath.row){
            NSHuanXinUserModel *model = [userSection objectAtIndex:indexPath.row];
            
            //        DLog(@"model = %@",model.nickname);
            
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.buddy];
            
            if (profileEntity) {
                model.avatarURLPath = profileEntity.imageUrl;
                model.nickname = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
                //            model.avatarURLPath = model.user_avatar;
                //            model.nickname = model.nick_name;
            }
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.model = model;
        }

        return cell;
    }
}

#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0 || section == 1)
//    {
//        return 0;
//    }
    if (section == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (section == 0 || section == 1)
//    {
//        return nil;
//    }
    if (section == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    [contentView addSubview:label];
    return contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
//        if (row == 0) {
//            [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
//        }
//        else
            if (row == 0)
        {
            GroupListViewController *groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:groupController animated:YES];
        }
//        else if (row == 2)
//        {
//            ChatroomListViewController *controller = [[ChatroomListViewController alloc] initWithStyle:UITableViewStylePlain];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
        
        
//        else if (row == 3) {
//            RobotListViewController *robot = [[RobotListViewController alloc] init];
//            [self.navigationController pushViewController:robot animated:YES];
//        }
        
//#if DEMO_CALL == 1
//        else if (row == 3) {
//            [[DemoConfManager sharedManager] pushConferenceController];
//        }
//        else if (row == 4) {
//            [[DemoConfManager sharedManager] pushCustomVideoConferenceController];
//        }
//#endif
    }
//    else if (section == 1) {
//       ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:[self.otherPlatformIds objectAtIndex:indexPath.row] conversationType:EMConversationTypeChat];
//        [self.navigationController pushViewController:chatController animated:YES];
//    }
    else{
        NSHuanXinUserModel *model = [[self.dataArray objectAtIndex:(section - 1)] objectAtIndex:row];
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:model.buddy conversationType:EMConversationTypeChat];
        chatController.title = model.nickname.length > 0 ? model.nickname : model.buddy;
        chatController.hxModel = model;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}
                                                       
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
//    if (indexPath.section == 0 || indexPath.section == 1) {
//        return NO;
//    }
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //在iOS8.0上，必须加上这个方法才能出发左划操作
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self setupCellEditActions:indexPath];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self setupCellEditActions:indexPath];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.indexPath == nil)
    {
        return;
    }

    NSIndexPath *indexPath = self.indexPath;
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    self.indexPath = nil;

    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = nil;
//        if (buttonIndex == alertView.cancelButtonIndex) {
//            error = [[EMClient sharedClient].contactManager deleteContact:model.buddy isDeleteConversation:NO];
//        } else {
//            error = [[EMClient sharedClient].contactManager deleteContact:model.buddy isDeleteConversation:YES];
//        }

//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (!error) {
//                DLog(@"删除成功 = %@",error);
            
            if (buttonIndex == alertView.cancelButtonIndex) {
                return ;
            }else{
                if ([weakSelf.dataArray count] >= indexPath.section) {
                    NSMutableArray *tmp = [weakSelf.dataArray objectAtIndex:(indexPath.section - 1)];
                    [NSMessageAPI deleteFriendWithParam:model.buddy success:^{
                        DLog(@"删除好友成功");
                        [Common AppShowToast:@"删除好友成功"];
                        [tmp removeObject:model.buddy];
                        [weakSelf.contactsSource removeObject:model.buddy];
                        [self reloadDataSource];
                        [weakSelf.tableView reloadData];
                    } faulre:^(NSError *error) {
                    }];
                }
            }
            
            
//            }
//            else{
//                DLog(@"删除error = %@",error);
//                [weakSelf showHint:[NSString stringWithFormat:NSLocalizedString(@"deleteFailed", @"Delete failed:%@"), error.errorDescription]];
//                [weakSelf.tableView reloadData];
//            }
//        });
//    });
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex || _currentLongPressIndex == nil) {
        return;
    }
    
    NSIndexPath *indexPath = _currentLongPressIndex;
    NSHuanXinUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    _currentLongPressIndex = nil;
    
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"wait", @"Pleae wait...")];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:model.buddy relationshipBoth:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                //由于加入黑名单成功后会刷新黑名单，所以此处不需要再更改好友列表
                [weakSelf reloadDataSource];
            }
            else {
                [weakSelf showHint:error.errorDescription];
            }
        });
    });
    
}
                                                       
#pragma mark - EaseUserCellDelegate
                                                       
- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0 || indexPath.section == 1) {
//        return;
//    }
//
//    _currentLongPressIndex = indexPath;
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
//    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}
                                               
#pragma mark - EMSearchControllerDelegate     
                                                       
- (void)cancelButtonClicked
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
}
                                               
- (void)searchTextChangeWithString:(NSString *)aString
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:aString collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.resultController.displaySource removeAllObjects];
                [weakSelf.resultController.displaySource addObjectsFromArray:results];
                [weakSelf.resultController.tableView reloadData];
            });
        }
    }];
}

#pragma mark - action

- (void)deleteCellAction:(NSIndexPath *)aIndexPath
{
    self.indexPath = aIndexPath;
//    NSLocalizedString(@"message.deleteConversation", nil)
    UIAlertView *alertView = [[ UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:@"确定要删除好友吗?" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [alertView show];
}

- (id)setupCellEditActions:(NSIndexPath *)aIndexPath
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"delete",@"Delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self deleteCellAction:indexPath];
            [self.tableView reloadData];
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        return @[deleteAction];
    } else {
        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:NSLocalizedString(@"delete",@"Delete") handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [self deleteCellAction:aIndexPath];
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
        config.performsFirstActionWithFullSwipe = NO;
        return config;
    }
}

- (void)addContactAction
{
//    AddFriendViewController *addController = [[AddFriendViewController alloc] init];
//    [self.navigationController pushViewController:addController animated:YES];
    
    NSAddFriendVC *addController = [[NSAddFriendVC alloc] init];
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - private
                                                       
- (void)setupSearchController
{
//    改动过
//    [self enableSearchController];
    [self disableSearchController];
    
    __weak ContactListViewController *weakSelf = self;
    [self.resultController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *CellIdentifier = @"BaseTableViewCell";
        BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *buddy = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
        cell.textLabel.text = buddy;
        cell.username = buddy;
        
        return cell;
    }];
    
    [self.resultController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        return 50;
    }];
    
    [self.resultController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSString *buddy = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        [weakSelf.searchController.searchBar endEditing:YES];
        
        ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:buddy
                                     conversationType:EMConversationTypeChat];
        chatVC.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:buddy];
        [weakSelf.navigationController pushViewController:chatVC animated:YES];
                                               
        [weakSelf cancelSearch];
    }];
        
    UISearchBar *searchBar = self.searchController.searchBar;
    CGFloat height = searchBar.frame.size.height;
    if (height == 0) {
        height = 50;
    }
    searchBar.frame = CGRectMake(0, TopBarHeight, self.tableView.frame.size.width, height);
    
    self.tableView.frame = CGRectMake(0, searchBar.frame.size.height+TopBarHeight, self.view.frame.size.width,self.view.frame.size.height - searchBar.frame.size.height-TopBarHeight);
//    self.tableView.tableHeaderView = searchBar;
    
    
    [self.tableView reloadData];
}

- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    NSMutableArray *contactsSource = [NSMutableArray array];
//    DLog(@"buddyList = %@",buddyList);
    //从获取的数据中剔除黑名单中的好友
    NSArray *blockList = [[EMClient sharedClient].contactManager getBlackList];
    for (NSString *buddy in buddyList) {
        if (![blockList containsObject:buddy]) {
            [contactsSource addObject:buddy];
//            DLog(@"buddy = %@",buddy);
        }
    }
    
    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    NSInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }

    //按首字母分组
    for (NSString *buddy in contactsSource) {
        NSHuanXinUserModel *model = [[NSHuanXinUserModel alloc] initWithBuddy:buddy];
        
        [model getInformationWith:self.friendListArr];

//        [[UserProfileManager sharedInstance] saveDictUserInMemory:@{@"nickname":model.nick_name,@"avatar":model.user_avatar,@"username":model.hx_user_name}];
        
        if (model) {
            model.nickname = model.nick_name;
            NSString *imageUrl = model.user_avatar;
            NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            model.avatarImage =  [UIImage imageWithData:data];
            
            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:model.nickname];
            NSInteger section;
            if (firstLetter.length > 0) {
                section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            } else {
                section = [sortedArray count] - 1;
            }
            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [array addObject:model];
        }
//            }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSHuanXinUserModel *obj1, NSHuanXinUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.buddy];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.buddy];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    
    [self.dataArray addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
//        }
//    }
}

#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *buddyList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        
        weakself.otherPlatformIds = [[EMClient sharedClient].contactManager getSelfIdsOnOtherPlatformWithError:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
        });
        if (!error) {
            [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.contactsSource removeAllObjects];
                    
                    for (NSInteger i = (buddyList.count - 1); i >= 0; i--) {
                        NSString *username = [buddyList objectAtIndex:i];
                        [weakself.contactsSource addObject:username];
                    }
                    [self.friendListArr removeAllObjects];
                    [NSMessageAPI getFriendList:nil success:^(NSFriendListModel * _Nullable result) {
                        DLog(@"获取好友列表成功");
                        self.friendListArr = [NSMutableArray arrayWithArray:result.list];
                        [weakself _sortDataArray:self.contactsSource];
                    } failure:^(NSError *error) {
                        DLog(@"获取好友列表失败");
                    }];
                    
                });
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself showHint:NSLocalizedString(@"loadDataFailed", @"Load data failed.")];
                [weakself reloadDataSource];
            });
        }
        [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
    });
}

#pragma mark - public

- (void)reloadDataSource
{
    [self.dataArray removeAllObjects];
    [self.contactsSource removeAllObjects];
    
    NSArray *buddyList = [[EMClient sharedClient].contactManager getContacts];
    
    for (NSString *buddy in buddyList) {
        [self.contactsSource addObject:buddy];
    }
    [self.friendListArr removeAllObjects];
    [NSMessageAPI getFriendList:nil success:^(NSFriendListModel * _Nullable result) {
        DLog(@"获取好友列表成功");
        self.friendListArr = [NSMutableArray arrayWithArray:result.list];
        [self _sortDataArray:self.contactsSource];
        //        for (NSFriendItemModel *item in result.list) {
        //            DLog(@"item = %@",item.mj_keyValues);
        //        }
    } failure:^(NSError *error) {
        DLog(@"获取好友列表失败");
    }];
//    [self _sortDataArray:self.contactsSource];
    
    [self.tableView reloadData];
}

- (void)reloadApplyView
{
    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
    self.unapplyCount = count;
    [self.tableView reloadData];
}

- (void)reloadGroupView
{
    [self reloadApplyView];
    
    if (_groupController) {
        [_groupController tableViewDidTriggerHeaderRefresh];
    }
}

//- (void)addFriendAction
//{
//    AddFriendViewController *addController = [[AddFriendViewController alloc] init];
//    [self.navigationController pushViewController:addController animated:YES];
//}

///*!
// *  用户A发送加用户B为好友的申请，用户B会收到这个回调
// *
// *  @param aUsername   用户名
// *  @param aMessage    附属信息
// */
//- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
//                                message:(NSString *)aMessage{
//    DLog(@"收到%@的好友请求",aUsername);
//    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
//    if (!error) {
//        NSLog(@"发送同意成功");
//    }
//}



@end

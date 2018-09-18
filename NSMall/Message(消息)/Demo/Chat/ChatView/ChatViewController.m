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

#import "ChatViewController.h"

#import "ChatroomDetailViewController.h"
#import "UserProfileViewController.h"
#import "UserProfileManager.h"
#import "ContactListSelectViewController.h"
#import "ChatDemoHelper.h"
#import "EMChooseViewController.h"
#import "ContactSelectionViewController.h"
#import "EMGroupInfoViewController.h"
#import "NSMessageAPI.h"

#import "EMDingMessageHelper.h"
#import "DingViewController.h"
#import "DingAcksViewController.h"
#import "NSNavView.h"
#import "NSSendRedPacketVC.h"
#import "NSRedPacketCell.h"
#import "NSRPTestCell.h"
#import "NSRPDetailVC.h"
#import "NSRPView.h"
#import "NSGroupDetailVC.h"
#import "NSReceiveRPCell.h"
#import "NSNullCell.h"
#import "XCPFileViewController.h"


#if DEMO_CALL == 1
#import "DemoConfManager.h"
#endif


//static NSString *identifier = @"NSRPTestCell";

@interface ChatViewController ()<UIAlertViewDelegate,EMClientDelegate, EMChooseViewDelegate,NSGroupDetailVCDelegate,EaseMessageViewControllerDataSource>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    UIMenuItem *_recallItem;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;
@property(nonatomic,strong)UIButton *virtualBtn;/* 挂名Btn,无实际用处 */
@property(nonatomic,strong)NSMutableArray *friendListArr;/* 好友列表数组 */
//@property (nonatomic) BOOL isSelected;
@property(nonatomic,strong)NSRPListModel *redPacketModel;/* 红包模型 */
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ChatDemoHelper shareHelper].chatVC = self;
//    self.dataSource = self;
    
//    UserModel *userModel = [UserModel modelFromUnarchive];
//    if(self.conversation.type == EMConversationTypeGroupChat && !([self.groupOwn isEqualToString:userModel.hx_user_name])){
//        self.chatBarMoreView.redPacketButton.alpha = 0.0;
//        [self.chatBarMoreView updateItemWithImage:IMAGE(@"message_ico_send_file") highlightedImage:IMAGE(@"message_ico_send_file") title:@"文件" atIndex:2];
//        [self.chatBarMoreView.redPacketButton setTitle:@"文件" forState:UIControlStateNormal];
//        [self.chatBarMoreView removeItematIndex:2];
//    }else{
//        [self.chatBarMoreView insertItemWithImage:IMAGE(@"message_ico_send_file") highlightedImage:IMAGE(@"message_ico_send_file") title:@"文件"];
//    }
    
    

    self.friendListArr = [NSMutableArray array];
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
//    [self _setupBarButtonItem];
    [self setUpNavTopView];
    self.tableView.backgroundColor = KBGCOLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitChat) name:@"ExitChat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dingAction) name:kNotification_DingAction object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCountAtDelegate" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (self.conversation.type == EMConversationTypeChatRoom) {
        //退出聊天室，删除会话
        if (self.isJoinedChatroom) {
            NSString *chatter = [self.conversation.conversationId copy];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                [[EMClient sharedClient].roomManager leaveChatroom:chatter error:&error];
                if (error !=nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Leave chatroom '%@' failed [%@]", chatter, error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            });
        }
        else {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:YES completion:nil];
        }
    }
    
    [[EMClient sharedClient] removeDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.conversation.type == EMConversationTypeGroupChat) {
        NSDictionary *ext = self.conversation.ext;
        if ([[ext objectForKey:@"subject"] length])
        {
            self.title = [ext objectForKey:@"subject"];
        }
        
        if (ext && ext[kHaveUnreadAtMessage] != nil)
        {
            NSMutableDictionary *newExt = [ext mutableCopy];
            [newExt removeObjectForKey:kHaveUnreadAtMessage];
            self.conversation.ext = newExt;
        }
    }
}

- (void)tableViewDidTriggerHeaderRefresh
{
    if ([[ChatDemoHelper shareHelper] isFetchHistoryChange]) {
        NSString *startMessageId = nil;
        if ([self.messsagesSource count] > 0) {
            startMessageId = [(EMMessage *)self.messsagesSource.firstObject messageId];
        }
        
        NSLog(@"startMessageID ------- %@",startMessageId);
        [EMClient.sharedClient.chatManager asyncFetchHistoryMessagesFromServer:self.conversation.conversationId
                                                              conversationType:self.conversation.type
                                                                startMessageId:startMessageId
                                                                      pageSize:10
                                                                    completion:^(EMCursorResult *aResult, EMError *aError)
        {
            [super tableViewDidTriggerHeaderRefresh];
        }];
       
    } else {
        [super tableViewDidTriggerHeaderRefresh];
    }
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    NSNavView *topToolView = [[NSNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    
//    EMMessage *latestMessage = self.conversation.latestMessage;
//    NSDictionary *ext = latestMessage.ext;

    
//[ext objectForKey:@"nick"]
    
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf backAction];
    };
    
    //单聊
    if (self.conversation.type == EMConversationTypeChat) {
//        topToolView.rightItemClickBlock = ^{
            //添加好友
//                    [weakSelf deleteAllMessages:weakSelf.virtualBtn];
//        };
        [topToolView setTopTitleWithNSString:KLocalizableStr(self.title)];
//        [topToolView.rightItemButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
//        [topToolView setRightItemImage:@"delete"];
//        deleteAllMessages:
    }
    else{//群聊
        [topToolView setTopTitleWithNSString:@"群聊"];

    }
    topToolView.rightItemClickBlock = ^{
        //添加好友
        [weakSelf showGroupDetailAction];
    };
    [topToolView setRightItemImage:@"message_ico_chating_head"];
//    [detailButton setImage:[UIImage imageNamed:@"group_detail"] forState:UIControlStateNormal];

    [self.view addSubview:topToolView];
    
    self.tableView.frame = CGRectMake(0, TopBarHeight, self.view.frame.size.width,self.view.frame.size.height -TopBarHeight);
//    [self.tableView registerClass:[NSRPTestCell class] forCellReuseIdentifier:identifier];
}


#pragma mark - setup subviews

//- (void)_setupBarButtonItem
//{
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    backButton.accessibilityIdentifier = @"back";
//    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [self.navigationItem setLeftBarButtonItem:backItem];
//
//    //单聊
//    if (self.conversation.type == EMConversationTypeChat) {
//        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//        clearButton.accessibilityIdentifier = @"clear_message";
//        [clearButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
//        [clearButton addTarget:self action:@selector(deleteAllMessages:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
//    }
//    else{//群聊
//        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//        detailButton.accessibilityIdentifier = @"detail";
//        [detailButton setImage:[UIImage imageNamed:@"group_detail"] forState:UIControlStateNormal];
//        [detailButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
//    }
//}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
//        if(alertView.tag == 20){
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.dataArray removeAllObjects];
            [self.messsagesSource removeAllObjects];
            
            [self.tableView reloadData];
//        }else if(alertView.tag == 30){
//
//        }
    }
}

#pragma mark - EaseMessageCellDelegate

- (void)messageCellSelected:(id<IMessageModel>)model
{
    EMMessage *message = model.message;
    if (model.isDing) {
        DingAcksViewController *controller = [[DingAcksViewController alloc] initWithMessage:message];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        
        NSDictionary *ext = model.message.ext;
        
        if([ext objectForKey:@"money_sponsor_name"]){
            //自己发的红包
            //        DLog(@"自己发的红包");
            WEAKSELF
            //        dispatch_group_enter(group);
            [NSMessageAPI receiveRedpacketWithParam:[ext objectForKey:@"rp_id"] success:^(NSRPListModel *redPacketModel) {
                //抢红包/红包详情
                DLog(@"抢红包成功");
                
                weakSelf.redPacketModel = redPacketModel;
                //                if(model.isSender){
                [self.view endEditing:YES];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                if([self.redPacketModel.RPStatus isEqualToString:@"1002"] && [[userDefaults objectForKey:self.redPacketModel.redpacket_id]  isEqualToString:@"20"]){
                    NSRPDetailVC *rpDetailVC = [NSRPDetailVC new];
                    [rpDetailVC setUpDataWith:self.redPacketModel];
                    [self.navigationController pushViewController:rpDetailVC animated:YES];
                }else if([self.redPacketModel.RPStatus isEqualToString:@"1005"] || [self.redPacketModel.RPStatus isEqualToString:@"1003"] || [self.redPacketModel.RPStatus isEqualToString:@"1"] || [self.redPacketModel.RPStatus isEqualToString:@"1002"]){
                    NSRPView *RPView = [[NSRPView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}];
                    if([self.redPacketModel.RPStatus isEqualToString:@"1005"]){
                        RPView.bgIV.image = IMAGE(@"red_packet_bg");
                        RPView.openBtn.alpha = 0.0;
                        [ext setValue:@"该红包已超过24小时." forKey:@"rp_leave_msg"];
                    }else if([self.redPacketModel.RPStatus isEqualToString:@"1003"]){
                        RPView.bgIV.image = IMAGE(@"red_packet_bg");
                        RPView.openBtn.alpha = 0.0;
                        [ext setValue:@"手慢了,红包派完了" forKey:@"rp_leave_msg"];
                    }else if([self.redPacketModel.RPStatus isEqualToString:@"1"] || [self.redPacketModel.RPStatus isEqualToString:@"1002"]){
                        RPView.bgIV.image = IMAGE(@"red_packet_open");
                        //                            [RPView.bgIV setBackgroundColor:[UIColor greenColor]];
                        RPView.openBtn.alpha = 1.0;
                    }
                    [RPView setUpDataWith:ext];
                    //            __weak typeof(RPView) rpview = RPView;
                    
                    //                WEAKSELF
                    RPView.openBtnClickBlock = ^{
                        //                [rpview removeFromSuperview];
                        //发送一条消息 首次成功领取时发送以下参数
                        
                        [userDefaults setValue:@"20" forKey:weakSelf.redPacketModel.redpacket_id];
                        [userDefaults synchronize];
                        UserModel *userModel = [UserModel modelFromUnarchive];
                        [(EaseMessageViewController *)weakSelf sendTextMessage:@"红包领取消息" withExt:@{@"nick":userModel.user_name,@"user_id":userModel.user_id,@"avatar_url":userModel.pic_img,@"hx_username":userModel.hx_user_name,@"is_receive_rp_msg":@"1",@"send_username":weakSelf.redPacketModel.send_hxuser_name,@"receive_username":userModel.hx_user_name,@"receive_nick":userModel.user_name,@"rp_count":[NSString stringWithFormat:@"%lu",weakSelf.redPacketModel.redpacket_count],@"rp_received_count":[NSString stringWithFormat:@"%lu",weakSelf.redPacketModel.receiveRedpacketList.count],@"rp_type":[NSString stringWithFormat:@"%lu",weakSelf.redPacketModel.redpacket_type]}];
                        
                        NSRPDetailVC *rpDetailVC = [NSRPDetailVC new];
                        [rpDetailVC setUpDataWith:weakSelf.redPacketModel];
                        [self.navigationController pushViewController:rpDetailVC animated:YES];
                    };
                    [RPView showInView:self.navigationController.view];
                }
            } faulre:^(NSError *error) {
                
            }];
            
        }else{
            [super messageCellSelected:model];
        }
        
        
    }
    
}


#pragma mark - EaseMessageViewControllerDelegate

- (void)messageViewController:(EaseMessageViewController *)viewController
            didSelectMoreView:(EaseChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index{
    
//    moreView.redPacketButton.alpha = 0.0;
    
    DLog(@"点击了红包index = %lu",index);
    
        //点击了红包
//        WEAKSELF
        UserModel *userModel = [UserModel modelFromUnarchive];
//        if(self.conversation.type == EMConversationTypeGroupChat && !([self.groupOwn isEqualToString:userModel.hx_user_name])){
//            if (index == 2){
//                DLog(@"发送文件");
//
//                XCPFileViewController *fileVC = [XCPFileViewController new];
//                [self.navigationController pushViewController:fileVC animated:YES];
//            }
//        }else{
            if(index == 2){
                NSSendRedPacketVC *sendRedPacketVC = [NSSendRedPacketVC new];
                sendRedPacketVC.EMConversationType = self.conversation.type;
                if(self.conversation.type == EMConversationTypeGroupChat){
                    sendRedPacketVC.groupCount = self.groupCount;
                }
                //        sendRedPacketVC.
                sendRedPacketVC.paramBlock = ^(NSRedPacketModel *param) {
                    [viewController sendTextMessage:param.money_sponsor_name withExt:@{@"nick":userModel.user_name,@"user_id":userModel.user_id,@"avatar_url":userModel.pic_img,@"hx_username":userModel.hx_user_name,@"is_money_msg":@"1",@"rp_id":param.rp_id,@"rp_amount":param.rp_amount,@"rp_type":param.rp_type,@"rp_count":param.rp_count,@"rp_leave_msg":param.rp_leave_msg,@"money_sponsor_name":param.money_sponsor_name,@"send_username":param.send_username}];
                };
                [self.navigationController pushViewController:sendRedPacketVC animated:YES];
            }else if (index == 3){
                DLog(@"发送文件");
                XCPFileViewController *fileVC = [XCPFileViewController new];
                [self.navigationController pushViewController:fileVC animated:YES];
//                [viewController sendVideoMessageWithURL:];
            }
//        }
//    }
}

- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel
{
    NSDictionary *ext = messageModel.message.ext;
//    DLog(@"ext = %@",ext);
//    DLog(@"ext = %@",[ext objectForKey:@"is_money_msg"]);
    UserModel *userModel = [UserModel modelFromUnarchive];
    if([[ext objectForKey:@"send_username"] isEqualToString:userModel.hx_user_name]){
//         && ![[ext objectForKey:@"receive_nick"] isEqualToString:userModel.user_name]
        id medicine = messageModel.message.ext[@"is_receive_rp_msg"];
        if(medicine){
            NSString *cellid = [NSReceiveRPCell cellIdentifierWithModel:messageModel];
            NSReceiveRPCell *medicineCell = (NSReceiveRPCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
            if(!medicineCell){
                medicineCell = [[NSReceiveRPCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid model:messageModel];
            }
            medicineCell.model = messageModel;
            return medicineCell;
        }
    }
    if(![[ext objectForKey:@"send_username"] isEqualToString:userModel.hx_user_name]){
        //不是自己发的红包
        id medicine = messageModel.message.ext[@"is_receive_rp_msg"];
        if(medicine){
            NSString *cellid = [NSNullCell cellIdentifierWithModel:messageModel];
            NSNullCell *medicineCell = (NSNullCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
            if(!medicineCell){
                medicineCell = [[NSNullCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid model:messageModel];
            }
            medicineCell.model = messageModel;
            return medicineCell;
        }
    }
    if([ext objectForKey:@"is_money_msg"]){
        
        id medicine = messageModel.message.ext[@"rp_leave_msg"];
        if(medicine){
            NSString *cellid = [NSRPTestCell cellIdentifierWithModel:messageModel];
            NSRPTestCell *medicineCell = (NSRPTestCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
            if(!medicineCell){
                medicineCell = [[NSRPTestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid model:messageModel];
            }
            medicineCell.model = messageModel;
            return medicineCell;
        }
        
//        NSRPTestCell *redPacketCell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if(!redPacketCell){
//            redPacketCell = [[NSRPTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            redPacketCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
////        redPacketCell.dict = ext;
////        EMTextMessageBody *body = (EMTextMessageBody*)messageModel.message.body;
//        return redPacketCell;
    }else if ([ext objectForKey:@"em_recall"]) {
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *recallCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (recallCell == nil) {
            recallCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            recallCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
//        EMTextMessageBody *body = (EMTextMessageBody*)messageModel.message.body;
//        recallCell.title = body.text;
        return recallCell;
    }
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    NSDictionary *ext = messageModel.message.ext;
    UserModel *userModel = [UserModel modelFromUnarchive];
    if([ext objectForKey:@"is_money_msg"]){
        id medicine = messageModel.message.ext[@"rp_leave_msg"];
        if(medicine){
            return [NSRPTestCell cellHeightWithModel:messageModel]+30;
        }
    }else if ([ext objectForKey:@"em_recall"]) {
        return self.timeCellHeight;
    }else if([ext objectForKey:@"is_receive_rp_msg"] && [[ext objectForKey:@"receive_nick"] isEqualToString:userModel.user_name]){
            return 0.01;
    }
    return 0;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[EaseMessageCell class]]) {
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
        }
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
//    UserProfileViewController *userprofile = [[UserProfileViewController alloc] initWithUsername:messageModel.message.from];
//    [self.navigationController pushViewController:userprofile animated:YES];
}

- (void)messageViewController:(EaseMessageViewController *)viewController
    didSelectCallMessageModel:(id<IMessageModel>)messageModel
{
#if DEMO_CALL == 1
    [[DemoConfManager sharedManager] handleMessageToJoinConference:messageModel.message];
#endif
}

- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback
{
    _selectedCallback = selectedCallback;
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:self.conversation.conversationId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:self.conversation.conversationId];
    }
    
    if (chatGroup) {
        if (!chatGroup.occupants) {
            __weak ChatViewController* weakSelf = self;
            [self showHudInView:self.view hint:@"Fetching group members..."];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:chatGroup.groupId error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong ChatViewController *strongSelf = weakSelf;
                    if (strongSelf) {
                        [strongSelf hideHud];
                        if (error) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Fetching group members failed [%@]", error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            alertView.tag = 20;
                            [alertView show];
                        }
                        else {
                            NSMutableArray *members = [group.occupants mutableCopy];
                            NSString *loginUser = [EMClient sharedClient].currentUsername;
                            if (loginUser) {
                                [members removeObject:loginUser];
                            }
                            if (![members count]) {
                                if (strongSelf.selectedCallback) {
                                    strongSelf.selectedCallback(nil);
                                }
                                return;
                            }
                            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
                            selectController.mulChoice = NO;
                            selectController.delegate = self;
                            [self.navigationController pushViewController:selectController animated:YES];
                        }
                    }
                });
            });
        }
        else {
            NSMutableArray *members = [chatGroup.occupants mutableCopy];
            NSString *loginUser = [EMClient sharedClient].currentUsername;
            if (loginUser) {
                [members removeObject:loginUser];
            }
            if (![members count]) {
                if (_selectedCallback) {
                    _selectedCallback(nil);
                }
                return;
            }
            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
            selectController.mulChoice = NO;
            selectController.delegate = self;
            [self.navigationController pushViewController:selectController animated:YES];
        }
    }
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    
//    DLog(@"message.ext = %@",message.ext);
    
    if([[message.ext allKeys] containsObject:@"hx_username"]){
    }else if([message.from isEqualToString:[[UserModel modelFromUnarchive] hx_user_name]]){
        
        UserModel *userModel = [UserModel modelFromUnarchive];
        message.ext = @{@"nick":userModel.user_name,@"user_id":userModel.user_id,@"avatar_url":userModel.pic_img,@"hx_username":userModel.hx_user_name};
    }else{
        NSHuanXinUserModel *model = [[NSHuanXinUserModel alloc] initWithBuddy:message.from];
        [self.friendListArr removeAllObjects];
        [NSMessageAPI getFriendList:nil success:^(NSFriendListModel * _Nullable result) {
            DLog(@"获取好友列表成功");
            self.friendListArr = [NSMutableArray arrayWithArray:result.list];
            [model getInformationWith:self.friendListArr];
            message.ext = @{@"nick":model.nick_name,@"user_id":model.user_id,@"avatar_url":model.user_avatar,@"hx_username":model.hx_user_name};
        } failure:^(NSError *error) {
            DLog(@"获取好友列表失败");
        }];
        
    }

    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];

//    if([message.from isEqualToString:[[UserModel modelFromUnarchive] hx_user_name]]){
//        model.isSender = YES;
//    }else{
//        model.isSender = NO;
//    }
    
//    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:[message.ext objectForKey:@"avatar_url"]]];
    model.avatarImage =  [UIImage imageWithData:data];
    
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.nickname];
    if (profileEntity) {
        model.avatarURLPath = profileEntity.imageUrl;
        model.nickname = profileEntity.nickname;
    }
    model.failImageName = @"imageDownloadFail";
    
    model.isDing = [EMDingMessageHelper isDingMessage:message];
    model.dingReadCount = [[EMDingMessageHelper sharedHelper] dingAckCount:message];
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

#pragma mark - EMClientDelegate

- (void)userAccountDidLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userAccountDidRemoveFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userDidForbidByServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - EMChatManagerDelegate

- (void)messagesDidRecall:(NSArray *)aMessages
{
    for (EMMessage *msg in aMessages) {
        if (![self.conversation.conversationId isEqualToString:msg.conversationId]){
            continue;
        }
        
        NSString *text;
        if ([msg.from isEqualToString:[EMClient sharedClient].currentUsername]) {
            text = [NSString stringWithFormat:NSLocalizedString(@"message.recall", @"You recall a message")];
        } else {
            text = [NSString stringWithFormat:NSLocalizedString(@"message.recallByOthers", @"%@ recall a message"),msg.from];
        }
        
        [self _recallWithMessage:msg text:text isSave:NO];
    }
}

#pragma mark - EMChooseViewDelegate

- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    if ([selectedSources count]) {
        EaseAtTarget *target = [[EaseAtTarget alloc] init];
        target.userId = selectedSources.firstObject;
        UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:target.userId];
        if (profileEntity) {
            target.nickname = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
        }
        if (_selectedCallback) {
            _selectedCallback(target);
        }
    }
    else {
        if (_selectedCallback) {
            _selectedCallback(nil);
        }
    }
    return YES;
}

- (void)viewControllerDidSelectBack:(EMChooseViewController *)viewController
{
    if (_selectedCallback) {
        _selectedCallback(nil);
    }
}

#pragma mark - action

- (void)backAction
{
    [ChatDemoHelper shareHelper].chatVC = nil;
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:NO completion:nil];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    
    if (self.conversation.type == EMConversationTypeGroupChat) {
        
        NSGroupDetailVC *groupDetailVC = [NSGroupDetailVC new];
//        [groupDetailVC setUpDataWithGroupId:self.conversation.conversationId];
        groupDetailVC.exitBtn.alpha = 1.0;
        groupDetailVC.otherTableView.alpha = 1.0;
        groupDetailVC.groupOwn = self.groupOwn;
        [groupDetailVC setUpDataWithConversation:self.conversation];
        [self.navigationController pushViewController:groupDetailVC animated:YES];
        
//        EMGroupInfoViewController *infoController = [[EMGroupInfoViewController alloc] initWithGroupId:self.conversation.conversationId];
//        [self.navigationController pushViewController:infoController animated:YES];
    }
    else if (self.conversation.type == EMConversationTypeChatRoom)
    {
        ChatroomDetailViewController *detailController = [[ChatroomDetailViewController alloc] initWithChatroomId:self.conversation.conversationId];
        [self.navigationController pushViewController:detailController animated:YES];
    }else if (self.conversation.type == EMConversationTypeChat){
        //私聊
//        DLog(@"conversationId = %@",self.conversation.conversationId);
//        NSDictionary *dict = self.conversation.latestMessage.ext;
//        DLog(@"dict = %@",dict);
        NSGroupDetailVC *groupDetailVC = [NSGroupDetailVC new];
        [groupDetailVC setUpDataWithConversation:self.conversation];
        groupDetailVC.delegate = self;
        groupDetailVC.exitBtn.alpha = 0.0;
        groupDetailVC.otherTableView.alpha = 0.0;
        [self.navigationController pushViewController:groupDetailVC animated:YES];
    }
}

- (void)dingAction
{
    [self.view endEditing:YES];
    DingViewController *controller = [[DingViewController alloc] initWithConversationId:self.conversation.conversationId to:self.conversation.conversationId chatType:EMChatTypeGroupChat finishCompletion:^(EMMessage *aMessage) {
        [self sendMessage:aMessage isNeedUploadFile:NO];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)deleteAllMessages:(id)sender
{
    [[EMDingMessageHelper sharedHelper] deleteConversation:self.conversation.conversationId];
    
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != EMConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
//        [alertView show];
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
    }
}

- (void)recallMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        __weak typeof(self) weakSelf = self;
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        [[EMClient sharedClient].chatManager recallMessage:model.message
                                                completion:^(EMMessage *aMessage, EMError *aError) {
                                                    if (!aError) {
                                                        [weakSelf _recallWithMessage:aMessage text:NSLocalizedString(@"message.recall", @"You recall a message") isSave:YES];
                                                    } else {
                                                        [weakSelf showHint:[NSString stringWithFormat:NSLocalizedString(@"recallFailed", @"Recall failed:%@"), aError.errorDescription]];
                                                    }
                                                    weakSelf.menuIndexPath = nil;
                                                }];
    }
}

- (void)transpondMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        ContactListSelectViewController *listViewController = [[ContactListSelectViewController alloc] initWithNibName:nil bundle:nil];
        listViewController.messageModel = model;
        [listViewController tableViewDidTriggerHeaderRefresh];
        [self.navigationController pushViewController:listViewController animated:YES];
    }
    self.menuIndexPath = nil;
}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        [[EMDingMessageHelper sharedHelper] deleteConversation:self.conversation.conversationId message:model.message.messageId];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView reloadData];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - NSNotification

- (void)exitChat
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EMClient sharedClient].chatManager importMessages:@[message] completion:nil];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark - private

- (void)_recallWithMessage:(EMMessage *)msg text:(NSString *)text isSave:(BOOL)isSave
{
    EMMessage *message = [EaseSDKHelper getTextMessage:text to:msg.conversationId messageType:msg.chatType messageExt:@{@"em_recall":@(YES)}];
    message.isRead = YES;
    [message setTimestamp:msg.timestamp];
    [message setLocalTime:msg.localTime];
    id<IMessageModel> newModel = [[EaseMessageModel alloc] initWithMessage:message];
    __block NSUInteger index = NSNotFound;
    [self.dataArray enumerateObjectsUsingBlock:^(EaseMessageModel *model, NSUInteger idx, BOOL *stop){
        if ([model conformsToProtocol:@protocol(IMessageModel)]) {
            if ([msg.messageId isEqualToString:model.message.messageId])
            {
                index = idx;
                *stop = YES;
            }
        }
    }];
    if (index != NSNotFound) {
        __block NSUInteger sourceIndex = NSNotFound;
        [self.messsagesSource enumerateObjectsUsingBlock:^(EMMessage *message, NSUInteger idx, BOOL *stop){
            if ([message isKindOfClass:[EMMessage class]]) {
                if ([msg.messageId isEqualToString:message.messageId])
                {
                    sourceIndex = idx;
                    *stop = YES;
                }
            }
        }];
        if (sourceIndex != NSNotFound) {
            [self.messsagesSource replaceObjectAtIndex:sourceIndex withObject:newModel.message];
        }
        [self.dataArray replaceObjectAtIndex:index withObject:newModel];
        [self.tableView reloadData];
    }
    
    if (isSave) {
        [self.conversation insertMessage:message error:nil];
    }
}

#pragma mark - Public

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"transpond", @"Transpond") action:@selector(transpondMenuAction:)];
    }
    
    if (_recallItem == nil) {
        _recallItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"recall", @"Recall") action:@selector(recallMenuAction:)];
    }
    
    NSMutableArray *items = [NSMutableArray array];
    
    if (messageType == EMMessageBodyTypeText) {
        [items addObject:_copyMenuItem];
        [items addObject:_transpondMenuItem];
        [items addObject:_deleteMenuItem];
    } else if (messageType == EMMessageBodyTypeImage || messageType == EMMessageBodyTypeVideo) {
        [items addObject:_transpondMenuItem];
        [items addObject:_deleteMenuItem];
    } else {
        [items addObject:_deleteMenuItem];
    }
    
    id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
    if (model.isSender) {
        [items addObject:_recallItem];
    }
    
    [self.menuController setMenuItems:items];
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}

- (void)reloadDingCellWithAckMessageId:(NSString *)aMessageId
{
    if ([aMessageId length] == 0) {
        return;
    }
    
    __block NSUInteger index = NSNotFound;
    __block EaseMessageModel *msgModel = nil;
    [self.dataArray enumerateObjectsUsingBlock:^(EaseMessageModel *model, NSUInteger idx, BOOL *stop){
        if ([model conformsToProtocol:@protocol(IMessageModel)] && [aMessageId isEqualToString:model.message.messageId]) {
            msgModel = model;
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index != NSNotFound) {
        msgModel.dingReadCount += 1;
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

-(void)setRedPacketModel:(NSRPListModel *)redPacketModel{
    _redPacketModel = redPacketModel;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 保存数据
if(![userDefaults objectForKey:redPacketModel.redpacket_id]){
        [userDefaults setValue:@"10" forKey:redPacketModel.redpacket_id];
        [userDefaults synchronize];
    }
    
}

//- (id)messageViewController:(EaseMessageViewController *)viewController
//progressDelegateForMessageBodyType:(EMMessageBodyType)messageBodyType{
//    DLog(@"messageBodyType = %u",messageBodyType);
//    return viewController;
//}

@end

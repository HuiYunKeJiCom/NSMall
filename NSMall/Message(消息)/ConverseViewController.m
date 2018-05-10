//
//  ConverseViewController.m
//  testhuanxin
//
//  Created by gyh on 16/4/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ConverseViewController.h"
#import "GYHTimeTool.h"

@interface ConverseViewController ()<EMClientDelegate,EMContactManagerDelegate,EMChatManagerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

/** 好友的名称 */
@property (nonatomic, copy) NSString *buddyUsername;

@property (nonatomic , strong) NSArray *conversations;

@property (nonatomic , strong) NSMutableArray *amsgArray;

@property (nonatomic , weak) UITableView *tableview;

@end

@implementation ConverseViewController

- (NSArray *)conversations
{
    if (!_conversations) {
        _conversations = [NSArray array];
    }
    return _conversations;
}

- (NSMutableArray *)amsgArray
{
    if (!_amsgArray) {
        _amsgArray = [NSMutableArray array];
    }
    return _amsgArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //登录接口相关的代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    //联系人模块代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //消息，聊天
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    [self loadConversations];
    
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    self.tableview = tableview;
}


-(void)loadConversations{
    //获取历史会话记录
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    if (conversations.count == 0) {
        conversations =  [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    }
    NSLog(@"zzzzzzz %@",conversations);
    self.conversations = conversations;
    //显示总的未读数
    [self showTabBarBadge];
}


- (void)showTabBarBadge{
    NSInteger totalUnreadCount = 0;
    for (EMConversation *conversation in self.conversations) {
        totalUnreadCount += [conversation unreadMessagesCount];
    }
    NSLog(@"未读消息总数:%ld",(long)totalUnreadCount);
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",totalUnreadCount];
    [self.tableview reloadData];
}

#warning 不知道为啥不会调用
//#pragma mark 历史会话列表更新
//- (void)didUpdateConversationList:(NSArray *)conversationList{
//    //给数据源重新赋值
//    self.conversations = conversationList;
//    //显示总的未读数
//    [self showTabBarBadge];
//}

#pragma mark - 接收到消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
    [self loadConversations];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"msgcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    EMConversation *conversaion = self.conversations[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"1"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %d   %@",conversaion.latestMessage.from,[conversaion unreadMessagesCount],[GYHTimeTool timeStr:conversaion.latestMessage.timestamp]];
//    ,[conversaion unreadMessagesCount]
    // 获取消息体
    id body = conversaion.latestMessage.body;
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = body;
        cell.detailTextLabel.text = textBody.text;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){
        cell.detailTextLabel.text = @"[语音]";
    }else if([body isKindOfClass:[EMImageMessageBody class]]){
        cell.detailTextLabel.text = @"[图片]";
    }else{
        cell.detailTextLabel.text = @"";
    }
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        EMConversation *conversaion = self.conversations[indexPath.row];
        NSString *converstationID = conversaion.conversationId;
        // 删除会话
        [[EMClient sharedClient].chatManager deleteConversation:converstationID deleteMessages:YES];
        [self loadConversations];
    }
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}




#pragma mark - 监听网络状态
- (void)didConnectionStateChanged:(EMConnectionState)connectionState{

    if (connectionState == EMConnectionDisconnected) {
        self.title = @"未连接..";
    }else{
        self.title = @"会话";
    }
}


#pragma mark - 好友请求回调
/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage
{
    NSLog(@"%@,%@",aUsername,aMessage);
    self.buddyUsername = aUsername;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友添加请求" message:aMessage delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        //同意好友请求
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:self.buddyUsername];
        if (!error) {
            NSLog(@"同意加好友成功");
        }else{
             NSLog(@"同意加好友失败");
        }
    }else{
        //拒绝好友请求
        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:self.buddyUsername];
        if (!error) {
            NSLog(@"拒绝加好友成功");
        }else{
            NSLog(@"拒绝加好友失败");
        }
    }
}

#pragma mark - 好友申请处理结果回调
/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    NSLog(@"%@",aUsername);
    NSString *message = [NSString stringWithFormat:@"%@ 同意了你的好友请求",aUsername];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友添加消息" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    NSLog(@"%@",aUsername);
    NSString *message = [NSString stringWithFormat:@"%@ 拒绝了你的好友请求",aUsername];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友添加消息" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}





- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

@end

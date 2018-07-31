//
//  DCTabBarController.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCTabBarController.h"
#import "DCNavigationController.h"
//#import "XWPopMenuController.h"//发布
#import "DCTabBadgeView.h"
#import "ChatViewController.h"
#import "UserProfileManager.h"

static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface DCTabBarController ()<UITabBarControllerDelegate,EMClientDelegate>
{
    UIBarButtonItem *_addFriendItem;
    EMConnectionState _connectionState;
}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@property (nonatomic , strong) NSArray *conversations;
////给item加上badge
//@property (nonatomic, weak) UITabBarItem *item;

@end

@implementation DCTabBarController

+ (instancetype)sharedTabBarVC{
    static DCTabBarController *sharedTabBarVC = nil;
    if (!sharedTabBarVC) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
            UIOffset titlePositionAdjustment = UIOffsetZero;//UIOffsetMake(0, MAXFLOAT);
            static NSString *context = nil;
            sharedTabBarVC = [self tabBarControllerWithViewControllers:[self ViewControllers] tabBarItemsAttributes:[self tabBarItemAttributes] imageInsets:imageInsets titlePositionAdjustment:titlePositionAdjustment context:context];
            sharedTabBarVC.delegate = sharedTabBarVC;
        });
//        [sharedTabBarVC setTintColor:[UIColor clearColor]];
    }
    return sharedTabBarVC;
}

+ (NSArray *)ViewControllers{
    NSHomePageVC *homeVC = [[NSHomePageVC alloc]init];
    homeVC.tabBarItem.title = @"首页";
    
    NSNearbyViewController *nearbyVC = [[NSNearbyViewController alloc]init];
    nearbyVC.tabBarItem.title = @"附近";
    
    ConversationListController *messageVC = [[ConversationListController alloc]init];
    messageVC.tabBarItem.title = @"消息";
    
//    [self.chatListVC networkChanged:_connectionState];
    
    NSMyCenterViewController *myCenterVC = [[NSMyCenterViewController alloc]init];
    myCenterVC.tabBarItem.title = @"我的";
    return @[homeVC,nearbyVC,messageVC,myCenterVC];
}

+ (NSArray *)tabBarItemAttributes{
    NSDictionary *format1 = @{CYLTabBarItemTitle:@"首页",CYLTabBarItemImage:kGetImage(@"main_ico_home"),CYLTabBarItemSelectedImage:@"main_ico_home_selected"};
    NSDictionary *format2 = @{CYLTabBarItemTitle:@"附近",CYLTabBarItemImage:kGetImage(@"main_ico_nearby"),CYLTabBarItemSelectedImage:@"main_ico_nearby_selected"};
    NSDictionary *format3 = @{CYLTabBarItemTitle:@"消息",CYLTabBarItemImage:kGetImage(@"main_ico_message"),CYLTabBarItemSelectedImage:@"main_ico_message_selected"};
    NSDictionary *format4 = @{CYLTabBarItemTitle:@"我的",CYLTabBarItemImage:kGetImage(@"main_ico_myinfo"),CYLTabBarItemSelectedImage:@"main_ico_myinfo_selected"};
    return @[format1,format2,format3,format4];
}

+ (UINavigationController *)shellNavOfViewController:(UIViewController *)viewController title:(NSString *)title{
    UINavigationController *shellNav = [[UINavigationController alloc]initWithRootViewController:viewController];
    shellNav.tabBarItem.title = title;
    return shellNav;
}

//#pragma mark - LazyLoad
//- (NSMutableArray *)tabBarItems {
//    if (_tabBarItems == nil) {
//        _tabBarItems = [NSMutableArray array];
//    }
//    return _tabBarItems;
//}

#pragma mark - initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    //登录接口相关的代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    //联系人模块代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //消息，聊天
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
    [self setupUnreadMessageCount];
//    [self loadConversations];
}


#pragma mark - 控制器跳转拦截
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

//-(void)loadConversations{
//    //获取历史会话记录
//
//    DLog(@"获取历史会话记录");
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    if (conversations.count == 0) {
////        DLog(@"conversations.count == 0");
//        conversations =  [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
//    }
////    NSLog(@"zzzzzzz %@",conversations);
//    self.conversations = conversations;
//    if (conversations.count != 0) {
////        DLog(@"conversations.count != 0");
//        //显示总的未读数
//        [self showTabBarBadge];
//    }
//}
//
//
//- (void)showTabBarBadge{
//    NSInteger totalUnreadCount = 0;
//    for (EMConversation *conversation in self.conversations) {
//        totalUnreadCount += [conversation unreadMessagesCount];
//    }
//    NSLog(@"未读消息总数:%ld",(long)totalUnreadCount);
//    self.beautyMsgVc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",totalUnreadCount];
//}

- (NSArray *)conversations
{
    if (!_conversations) {
        _conversations = [NSArray array];
    }
    return _conversations;
}

//}

-(void)goToSelectedViewControllerWith:(NSInteger)index{
    DLog(@"index = %lu",index);
    self.selectedViewController = [self.viewControllers objectAtIndex:index];
}

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (void)didReceiveUserNotification:(UNNotification *)notification
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
            NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
    }
    else{
        alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


@end

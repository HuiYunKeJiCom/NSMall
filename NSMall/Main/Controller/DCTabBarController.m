//
//  DCTabBarController.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCTabBarController.h"

// Controllers
#import "DCNavigationController.h"
#import "NSNearbyViewController.h"//附近
#import "NSMyCenterViewController.h"//我的
//#import "NSMessageViewController.h"//消息

//#import "NSPublishViewController.h"//发布

#import "NSHomePageVC.h"//新首页
#import "ConverseViewController.h"//新消息

#import "XWPopMenuController.h"//发布
// Views
#import "DCTabBadgeView.h"
// Vendors

// Categories

// Others

@interface DCTabBarController ()<UITabBarControllerDelegate,EMClientDelegate>

//消息
@property (nonatomic, weak) ConverseViewController *beautyMsgVc;
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
    }
    return sharedTabBarVC;
}

+ (NSArray *)ViewControllers{
//    NSHomePageViewController *homeVC = [[NSHomePageViewController alloc]init];
//    UINavigationController *shellNav1 = [self.class shellNavOfViewController:homeVC title:@"首页"];
//    NSHomePageVC *homeVC = [[NSHomePageVC alloc]init];
//    UINavigationController *shellNav1 = [self.class shellNavOfViewController:homeVC title:@"首页"];
//    NSNearbyViewController *nearbyVC = [[NSNearbyViewController alloc]init];
//    UINavigationController *shellNav2 = [self.class shellNavOfViewController:nearbyVC title:@"发现"];
//    NSMessageViewController *messageVC = [[NSMessageViewController alloc]init];
//    UINavigationController *shellNav3 = [self.class shellNavOfViewController:messageVC title:@"商城"];
//    NSMyCenterViewController *myCenterVC = [[NSMyCenterViewController alloc]init];
//    UINavigationController *shellNav4 = [self.class shellNavOfViewController:myCenterVC title:@"我"];
//    return @[shellNav1,shellNav2,shellNav3,shellNav4];
    NSHomePageVC *homeVC = [[NSHomePageVC alloc]init];
    homeVC.tabBarItem.title = @"首页";
    
    NSNearbyViewController *nearbyVC = [[NSNearbyViewController alloc]init];
    nearbyVC.tabBarItem.title = @"附近";
    
    ConverseViewController *messageVC = [[ConverseViewController alloc]init];
    messageVC.tabBarItem.title = @"消息";
    
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
//    //登录接口相关的代理
//    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
//    //联系人模块代理
//    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
//    //消息，聊天
//    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
//
//    [self loadConversations];
}


#pragma mark - 控制器跳转拦截
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

-(void)loadConversations{
    //获取历史会话记录
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    if (conversations.count == 0) {
        conversations =  [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    }
    NSLog(@"zzzzzzz %@",conversations);
    self.conversations = conversations;
    if (conversations.count != 0) {
        //显示总的未读数
        [self showTabBarBadge];
    }
}


- (void)showTabBarBadge{
    NSInteger totalUnreadCount = 0;
    for (EMConversation *conversation in self.conversations) {
        totalUnreadCount += [conversation unreadMessagesCount];
    }
    NSLog(@"未读消息总数:%ld",(long)totalUnreadCount);
    self.beautyMsgVc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",totalUnreadCount];
}

- (NSArray *)conversations
{
    if (!_conversations) {
        _conversations = [NSArray array];
    }
    return _conversations;
}

//}

-(void)goToSelectedViewControllerWith:(NSInteger)index{
    self.selectedViewController = [self.viewControllers objectAtIndex:index];
}

@end

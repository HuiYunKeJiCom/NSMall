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
#import "NSHomePageViewController.h"//首页
#import "NSNearbyViewController.h"//附近
#import "NSMyCenterViewController.h"//我的
#import "NSMessageViewController.h"//消息
//#import "NSPublishViewController.h"//发布

#import "NSHomePageVC.h"//新首页

#import "XWPopMenuController.h"//发布
// Views
#import "DCTabBadgeView.h"
// Vendors

// Categories

// Others

@interface DCTabBarController ()<UITabBarControllerDelegate>

//消息
@property (nonatomic, weak) NSMessageViewController *beautyMsgVc;

@property (nonatomic, strong) NSMutableArray *tabBarItems;
//给item加上badge
@property (nonatomic, weak) UITabBarItem *item;

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
    
    NSMessageViewController *messageVC = [[NSMessageViewController alloc]initWithConversationId:@"CarLing02" conversationType:EMConversationTypeChat];
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

#pragma mark - LazyLoad
- (NSMutableArray *)tabBarItems {
    if (_tabBarItems == nil) {
        _tabBarItems = [NSMutableArray array];
    }
    return _tabBarItems;
}

#pragma mark - initialize
- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - 控制器跳转拦截
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}



@end

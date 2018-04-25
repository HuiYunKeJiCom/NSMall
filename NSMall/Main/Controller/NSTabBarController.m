//
//  NSTabBarController.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSTabBarController.h"
#import "NSHomePageViewController.h"//首页
#import "NSNearbyViewController.h"//附近
#import "NSMyCenterViewController.h"//我的
#import "NSMessageViewController.h"//消息

@interface NSTabBarController ()
/** tabbar */
@property(nonatomic,strong)CYLTabBarController *tabBarController;
@end

@implementation NSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置数组
- (void)setupViewControllers {
//    @{MallClassKey  : @"NSHomePageViewController",
//      MallTitleKey  : @"首页",
//      @{MallClassKey  : @"NSNearbyViewController",
//        MallTitleKey  : @"附近",
//        @{MallClassKey  : @"NSMessageViewController",
//          MallTitleKey  : @"消息",
//          @{MallClassKey  : @"NSMyCenterViewController",
//            MallTitleKey  : @"我的",
    
    NSHomePageViewController *firstViewController = [[NSHomePageViewController alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    NSNearbyViewController *secondViewController = [[NSNearbyViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    NSMessageViewController *thirdViewController = [[NSMessageViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    NSMyCenterViewController *fourthViewController = [[NSMyCenterViewController alloc] init];
    UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
    [self customizeTabBarForController:tabBarController];
    
    [tabBarController setViewControllers:@[
                                           firstNavigationController,
                                           secondNavigationController,
                                           ]];
    self.tabBarController = tabBarController;
}


/*
 *
 在`-setViewControllers:`之前设置TabBar的属性，
 *
 */
- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"main_ico_home",
                            CYLTabBarItemSelectedImage : @"main_ico_home_selected",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"附近",
                            CYLTabBarItemImage : @"main_ico_nearby",
                            CYLTabBarItemSelectedImage : @"main_ico_nearby_selected",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"消息",
                            CYLTabBarItemImage : @"main_ico_message",
                            CYLTabBarItemSelectedImage : @"main_ico_message_selected",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"main_ico_myinfo",
                            CYLTabBarItemSelectedImage : @"main_ico_myinfo_selected",
                            };
    
    
//    @{MallClassKey  : @"XWPopMenuController",
//      MallTitleKey  : @"发布",
//      MallImgKey    : @"main_ico_add",
//      MallSelImgKey : @"main_ico_add"},
    
    NSArray *tabBarItemsAttributes = @[ dict1, dict2,dict3,dict4 ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}

@end

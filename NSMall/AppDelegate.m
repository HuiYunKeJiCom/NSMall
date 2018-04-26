//
//  AppDelegate.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "AppDelegate.h"
#import "NSLoginController.h"
#import "CYLTabBarController.h"
#import "NSHomePageViewController.h"//首页
#import "NSNearbyViewController.h"//附近
#import "NSMyCenterViewController.h"//我的
#import "NSMessageViewController.h"//消息

#import "DCTabBarController.h"
#import "DCTabBarCenterButton.h"


@interface AppDelegate ()<CYLPlusButtonSubclassing>
/** tabbar */
@property(nonatomic,strong)CYLTabBarController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [DCTabBarCenterButton registerPlusButton];
    [self setUpRootVC]; //跟控制器判断
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 根控制器
- (void)setUpRootVC
{
//    [self customizeTabBarForController:self.tabBarController];
//    [self setupViewControllers];
//    self.window.rootViewController = [[NSLoginController alloc] init];
    [self.window setRootViewController:[DCTabBarController sharedTabBarVC]];
}

//设置数组
- (void)setupViewControllers {
    
    NSHomePageViewController *firstViewController = [[NSHomePageViewController alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    NSNearbyViewController *secondViewController = [[NSNearbyViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    NSMessageViewController *thirdViewController = [[NSMessageViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    NSMyCenterViewController *fourthViewController = [[NSMyCenterViewController alloc] init];
    UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:fourthViewController];
    
    CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
    [self customizeTabBarForController:tabBarController];
    
    [tabBarController setViewControllers:@[
                                           firstNavigationController,
                                           secondNavigationController,
                                           thirdNavigationController,
                                           fourthNavigationController,
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - private methord

-(NSString *)showText:(NSString *)key
{
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    NSString *localizableName ;
    
    if ([currentLanguage isEqualToString:@"zh-Hans-CN"]) {
        
        localizableName = @"Localizable_cn";
        
    } else {
        
        localizableName = @"Localizable_en";
    }
    
    NSString *string  = NSLocalizedStringFromTable(key ,localizableName,  nil);
    return  string;
}


@end

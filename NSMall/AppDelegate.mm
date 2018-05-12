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
//#import <Bugly/Bugly.h>
//#import <BuglyExtension/CrashReporterLite.h>


@interface AppDelegate ()<CYLPlusButtonSubclassing,EMChatManagerDelegate>
/** tabbar */
@property(nonatomic,strong)CYLTabBarController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    //打印日志
//    [Bugly startWithAppId:@"f01e247410"];
    
//    [[CrashReporter sharedInstance] installWithAppId:@"f01e247410"  applicationGroupIdentifier:@"41e18687-72ba-4fbe-969f-ab863821726c"];
    
    //环信
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1153180424099290#huist-oomall"];
    options.apnsCertName = @"NSMall";
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if(!error){
        NSLog(@"初始化成功");
    }
    
//    error= [[EMClient sharedClient] loginWithUsername:@"CarLing01" password:@"rl123456"];
//
//    if(!error){
//        NSLog(@"环信登录成功");
//    }else{
//        NSLog(@"登录失败");
//    }
    
    //百度地图
    _mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"RaLQR9LKbbxzd9vMbKf03cQ7SRuafWLr"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [DCTabBarCenterButton registerPlusButton];
//    [self setUpRootVC]; //跟控制器判断
    
    // 监听自动登录的状态
    // 设置chatManager代理
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    BOOL isAuLogin = [[EMClient sharedClient] isAutoLogin];
    NSLog(@"isAuLogin = %@",isAuLogin == 0?NO:YES);
    
    // 如果登录过，直接来到主界面
    if ([[EMClient sharedClient] isAutoLogin]) {
        NSLog(@"直接进主界面");
        [self setUpRootVC];
    }else{
        NSLoginController *login = [[NSLoginController alloc]init];
        [self.window setRootViewController:login];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 根控制器
- (void)setUpRootVC
{
    [self.window setRootViewController:[DCMainNavController sharedRootNav]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
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

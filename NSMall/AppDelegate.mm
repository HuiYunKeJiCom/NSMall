//
//  AppDelegate.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/12.
//  Copyright © 2018年 www. All rights reserved.
//

/* 环信 */
static NSString * const kHuanXinAppKey       = @"1153180424099290#huist-oomall";
//1125180610177403#nsapp
/* 百度 */
static NSString * const kBaiDuAK    = @"ZBdzZuTUE4aB3jpOko7Fa8tQ9g6OLzx2";

#import "AppDelegate.h"
#import "NSLoginController.h"
#import "CYLTabBarController.h"
#import "XTGuidePagesViewController.h"
#import "CALayer+Transition.h"
#import "UserInfoAPI.h"
#import "LoginAPI.h"
#import "AppVersionParam.h"

//#import <Bugly/Bugly.h>
//#import <BuglyExtension/CrashReporterLite.h>



@interface AppDelegate ()<CYLPlusButtonSubclassing,EMChatManagerDelegate,selectDelegate>
/** tabbar */
@property(nonatomic,strong)CYLTabBarController *tabBarController;
@end

@implementation AppDelegate

@synthesize splashView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //打印日志
    //    [Bugly startWithAppId:@"f01e247410"];
    
    //    [[CrashReporter sharedInstance] installWithAppId:@"f01e247410"  applicationGroupIdentifier:@"41e18687-72ba-4fbe-969f-ab863821726c"];
    
    //环信
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:kHuanXinAppKey];
    options.apnsCertName = @"NSMall";
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if(!error){
        NSLog(@"初始化成功");
    }
    
    //百度地图
    _mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:kBaiDuAK  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [DCTabBarCenterButton registerPlusButton];
    
    //    [self setUpRootVC]; //跟控制器判断
    
    // 监听自动登录的状态
    // 设置chatManager代理
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    // 测试的时候改变info 里的版本号就可以了
    NSArray *images = @[@"pic_start1", @"pic_start2", @"pic_start3", @"pic_start4"];
    BOOL y = [XTGuidePagesViewController isShow];
    if (y) {
        XTGuidePagesViewController *xt = [[XTGuidePagesViewController alloc] init];
        self.window.rootViewController = xt;
        xt.delegate = self;
        [xt guidePageControllerWithImages:images];
    }else{
        [self showWord];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)showWord{
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    //    NSLog(@"currentVersion = %@",currentVersion);
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults objectForKey:@"first"]) {
        NSLog(@"是第一次");
        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [userDefaults setValue:identifierForVendor forKey:@"uuid"];
        [userDefaults setBool:YES forKey:@"first"];
        [userDefaults synchronize];
        //        DLog(@"identifierForVendor = %@",identifierForVendor);
        [httpManager.requestSerializer setValue:identifierForVendor forHTTPHeaderField:@"device_id"];
        
        NSLoginController *login = [[NSLoginController alloc]init];
        [self.window setRootViewController:login];
    }else{
        NSLog(@"不是第一次");
        
        if([userDefaults valueForKey:@"appToken"]){
            NSString *appToken = [userDefaults valueForKey:@"appToken"];
            //                DLog(@"appToken = %@",appToken);
            NSString *uuid = [userDefaults valueForKey:@"uuid"];
            DLog(@"uuid = %@",uuid);
            [httpManager.requestSerializer setValue:appToken forHTTPHeaderField:@"app_token"];
            [httpManager.requestSerializer setValue:uuid forHTTPHeaderField:@"device_id"];
            
            [self updateVersion:currentVersion];
            
            [self setUpRootVC];
        }else{
            [self updateVersion:currentVersion];
            NSLoginController *login = [[NSLoginController alloc]init];
            [self.window setRootViewController:login];
        }
    }
}

- (void)updateVersion:(NSString *)version
{
    AppVersionParam *param = [[AppVersionParam alloc]init];
    param.versionCode = version;
    param.appType = @"1";
    
    [LoginAPI getAppVersion:param success:^(AppVersionModel * _Nullable result) {
        //        NSLog(@"检测版本result = %@",result.mj_keyValues);
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        //    1.1、加载一个网页url：
        NSURL *url = [NSURL URLWithString:result.downloadUrl];//创建URL
        //                                     @"itms-services:///?action=download-manifest&url=https://www.neublockchain.com/neu.plist"
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
        [webView loadRequest:request];//加载
        [[[UIApplication  sharedApplication]keyWindow] addSubview:webView];
        
    } failure:^(NSError *error) {
        return;
    }];
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

-(void)comeBackToRootVC{
    [[DCTabBarController sharedTabBarVC] goToSelectedViewControllerWith:0];
}




@end


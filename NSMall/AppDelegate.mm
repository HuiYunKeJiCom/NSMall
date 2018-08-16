//
//  AppDelegate.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/12.
//  Copyright © 2018年 www. All rights reserved.
//

/* 环信 */
static NSString * const kHuanXinAppKey       = @"1125180610177403#nsapp";
//1153180424099290#huist-oomall
//1125180610177403#nsapp(正式)

/* 百度 */
static NSString * const kBaiDuAK    = @"ZBdzZuTUE4aB3jpOko7Fa8tQ9g6OLzx2";

//ZBdzZuTUE4aB3jpOko7Fa8tQ9g6OLzx2(正式)
//RaLQR9LKbbxzd9vMbKf03cQ7SRuafWLr

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



@interface AppDelegate ()<CYLPlusButtonSubclassing,EMChatManagerDelegate,selectDelegate,EMContactManagerDelegate,EMClientDelegate>
/** tabbar */
@property(nonatomic,strong)CYLTabBarController *tabBarController;
/** 好友的名称 */
@property (nonatomic, copy) NSString *buddyUsername;
@end

@implementation AppDelegate

@synthesize splashView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCountAtDelegate" object:nil];
    
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
    
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
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
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
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
//    [userDefaults setValue:@"519b07b11fbf2a5ed41e9e85e527f7ea" forKey:@"appToken"];
//    [userDefaults synchronize];
    
    if (![userDefaults objectForKey:@"first"]) {
        NSLog(@"是第一次");
        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [userDefaults setValue:identifierForVendor forKey:@"uuid"];
        [userDefaults setBool:YES forKey:@"first"];
        [userDefaults synchronize];
        //        DLog(@"identifierForVendor = %@",identifierForVendor);
        [httpManager.requestSerializer setValue:identifierForVendor forHTTPHeaderField:@"device_id"];
        [self updateVersion:currentVersion];
        [self goToLoginPage];
    }else{
        NSLog(@"不是第一次");
        
        UserModel *userModel = [UserModel modelFromUnarchive];
        
        BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
        if (!isAutoLogin) {
            EMError *error = [[EMClient sharedClient] loginWithUsername:userModel.hx_user_name password:userModel.hx_password];
            if (!error) {
                NSLog(@"环信登录成功");
                [[EMClient sharedClient].options setIsAutoLogin:YES];
            }
        }
        
        if([userDefaults valueForKey:@"appToken"]){
            NSString *appToken = [userDefaults valueForKey:@"appToken"];
//            appToken = @"3c6ed065b551c68da78c993437a12df6";
//            DLog(@"appToken = %@",appToken);
            NSString *uuid = [userDefaults valueForKey:@"uuid"];
//            DLog(@"uuid = %@",uuid);
            [httpManager.requestSerializer setValue:appToken forHTTPHeaderField:@"app_token"];
            [httpManager.requestSerializer setValue:uuid forHTTPHeaderField:@"device_id"];
            
            [self updateVersion:currentVersion];
            
            [self setUpRootVC];
        }else{
            [self updateVersion:currentVersion];
            [self goToLoginPage];
        }
    }
}

- (void)updateVersion:(NSString *)version
{
    AppVersionParam *param = [[AppVersionParam alloc]init];
    param.versionCode = version;
    param.appType = @"1";
    
    [LoginAPI getAppVersion:param success:^(AppVersionModel * _Nullable result) {
//                NSLog(@"检测版本result = %@",result.mj_keyValues);
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

-(void)goToLoginPage{
    NSLoginController *login = [[NSLoginController alloc]init];
    [self.window setRootViewController:login];
}


/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage{
    DLog(@"收到%@的好友请求",aUsername);
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
    if (!error) {
        NSLog(@"发送同意成功");
    }
}

/*!
 *  自动登录返回结果
 *
 *  @param error 错误信息
 */
- (void)autoLoginDidCompleteWithError:(EMError *)error{
    
}

//添加回调监听代理: [[EMClient sharedClient] addDelegate:self delegateQueue:nil];

/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)userAccountDidLoginFromOtherDevice{
    
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)userAccountDidRemoveFromServer{
    
}

//收到消息

-(void)didReceiveMessages:(NSArray *)aMessages{
    
    //判断是不是后台，如果是后台就发推送
    
    if (aMessages.count==0) {
        return ;
    }
    
    [[DCTabBarController sharedTabBarVC] playSoundAndVibration];

    for(UIViewController *vc in [DCTabBarController sharedTabBarVC].viewControllers){
        if([vc isKindOfClass:[ConversationListController class]]){
            vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",aMessages.count];
        }
    }
    

    //设置声音
//    AudioServicesPlaySystemSound(1312);
}

-(void)setupUnreadMessageCount{
    for(UIViewController *vc in [DCTabBarController sharedTabBarVC].viewControllers){
        if([vc isKindOfClass:[ConversationListController class]]){
            vc.tabBarItem.badgeValue = nil;
        }
    }
}

@end


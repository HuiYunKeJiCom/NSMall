//
//  NSLoginController.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSLoginController.h"
#import "NSLoginView.h"
#import "LoginAPI.h"


@interface NSLoginController ()<NSLoginViewDelegate>

@property (nonatomic, strong) NSLoginView *loginView;

@end

@implementation NSLoginController

//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [CrashReporterLite startWithApplicationGroupIdentifier:@"41e18687-72ba-4fbe-969f-ab863821726c"];
//    }
//    return self;
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES];
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = KColorTextDA2F2D;
    [self.view addSubview:self.loginView];
    
    [self makeConstraints];
}

#pragma mark - getter

- (NSLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[NSLoginView alloc] init];
        _loginView.delegate = self;
    }
    return _loginView;
}

#pragma mark - Constraints

- (void)makeConstraints {
    WEAKSELF
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(weakSelf.view);
    }];
}

/**
 *登陆传参
 */
#pragma mark - ADLLoginViewDelegate

- (void)loginView:(NSLoginView *)logView userName:(NSString *)userName pwd:(NSString *)pwd {
    
    LoginParam *param = [LoginParam new];
    param.loginAccount = @"test2";
    param.password = @"123456";
    param.loginType = @"1";
    [LoginAPI loginWithParam:param success:^{
        DLog(@"登录成功");
        EMError *error = [[EMClient sharedClient] registerWithUsername:param.loginAccount password:param.password];
        if (error==nil) {
            NSLog(@"注册成功");
        }else{
            NSLog(@"注册失败,%@",error.errorDescription);
        }
        
        error= [[EMClient sharedClient] loginWithUsername:param.loginAccount password:param.password];
        
        if(!error){
            NSLog(@"环信登录成功");
        }else{
            NSLog(@"登录失败");
        }
        [kAppDelegate setUpRootVC];
        
    } faulre:^(NSError *error) {
        DLog(@"登录失败");
        DLog(@"error = %@",error);
    }];
    
    
    //    NSLog(@"userName = %@,pwd = %@",userName,pwd);
    //    [NSString getMd5_32Bit_String:pwd]
    
    //    WEAKSELF
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [RequestTool loginWithDictionary:@{@"userName":[NSString limitStringNotEmpty:userName],
//                                       @"password":[NSString limitStringNotEmpty:pwd]} withSuccessBlock:^(NSDictionary *result) {
//                                           NSLog(@"登录result = %@",result);
//                                           if([result[@"code"] integerValue] == 1){
//                                               //            result[@"data"]
//                                               hud.hidden = YES;
//                                               [[NSUserDefaults standardUserDefaults] synchronize];
//
//                                               ADLUserModel *model = [ADLUserModel mj_objectWithKeyValues:result[@"data"]];
//                                               [ADLGlobalHandleModel sharedInstance].CurrentUser = model;
//                                               [[ADLGlobalHandleModel sharedInstance] saveCurrentUser:model];
//                                               [[ADLGlobalHandleModel sharedInstance] saveLoginName:userName];
//                                               [[ADLGlobalHandleModel sharedInstance] savePassword:pwd];
//
//                                               if(![model.app_token isEqualToString:[ADAppToken dc_GetLastOneAppToken]]){
//                                                   [ADAppToken dc_SaveNewAppToken:model.app_token];
//                                                   //                NSLog(@"请求myAppToken = %@",model.app_token);
//                                               }
//                                               //            NSLog(@"请头myAppToken = %@",model.app_token);
//                                               [kAppDelegate initRootUI];
//                                           }else{
//                                           }
//                                       } withFailBlock:^(NSString *msg) {
//                                           hud.hidden = YES;
//                                           NSLog(@"登录msg = %@",msg);
//                                       }];
}

/**
 *注册
 */
- (void)loginView:(NSLoginView *)logView eventType:(UseLoginType)eventType {
    
    switch (eventType) {
        case UseLoginTypeLogin:{
            
        }
            break;
        case UseLoginTypeForget:{
            //忘记密码
            //            ADLForgetPasswordCtrl *ctrl = [[ADLForgetPasswordCtrl alloc] init];
            //            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
        case UseLoginTypeRegister:{
            NSLog(@"跳转到注册页面");
            //注册
            //            ADRegisterCtrlViewController *ctrl = [[ADRegisterCtrlViewController alloc] init];
            //            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
        case UseLoginTypePhone:{
            //            ADLLoginPhoneCtrl *ctrl = [[ADLLoginPhoneCtrl alloc] init];
            //            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
        case UseLoginTypeWXAuth:{
            //            NSLog(@"微信登录");
            //            [self actionAuth:eventType];
        }
            break;
        case UseLoginTypeQQAuth:{
            //            [self actionAuth:eventType];
        }
            break;
        case UseLoginTypeSinaAuth:{
            //            [self actionAuth:eventType];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

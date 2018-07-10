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
#import "GetVcodeAPI.h"
#import "GetVcodeParam.h"
#import "UserInfoAPI.h"

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
    
    [httpManager.requestSerializer setValue:@"a5ef51bda07a4c5e6f629a4083a8f89e" forHTTPHeaderField:@"app_token"];

    [UserInfoAPI getUserInfo:nil success:^{
        NSLog(@"获取用户信息");

        UserModel *userModel = [UserModel modelFromUnarchive];
//        DLog(@"userModel = %@",userModel.mj_keyValues);
//        DLog(@"userName = %@,pW = %@",userModel.hx_user_name,userModel.hx_password);
        EMError *error = [[EMClient sharedClient] loginWithUsername:userModel.hx_user_name password:userModel.hx_password];
        
        if(!error){
            NSLog(@"环信登录成功");
        }else{
            DLog(@"error = %@",error);
            NSLog(@"环信登录失败");
        }
        [kAppDelegate setUpRootVC];

    } faulre:^(NSError *error) {
        NSLog(@"获取用户信息失败");
    }];
    
//    LoginParam *param = [LoginParam new];
//    param.loginAccount = userName;
//    param.loginType = @"0";
//    param.smsCode = pwd;
//
//    [LoginAPI loginWithParam:param success:^{
//        DLog(@"登录成功");
//
//        [kAppDelegate setUpRootVC];
//
//    } faulre:^(NSError *error) {
//        DLog(@"登录失败");
//        DLog(@"error = %@",error);
//    }];
    
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

-(void)getVcodeWithPhone:(NSString *)phone{
    GetVcodeParam *param = [GetVcodeParam new];
    param.mobile = phone;
    param.type = @"1";
    
    [GetVcodeAPI getVcodeWithParam:param success:^{
        DLog(@"获取验证码成功");
    } faulre:^(NSError *error) {
        DLog(@"获取验证码失败");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  LoginAPI.m
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "LoginAPI.h"

@implementation LoginAPI

+ (void)loginWithParam:(LoginParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kLoginAPI showHUD:NetNullStr resultClass:[UserModel class] success:^(UserModel *userModel) {
        [userModel archive];
        DLog(@"userModel From Unarchive : %@",[UserModel userModel]);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // 保存数据
        [userDefaults setValue:userModel.app_token forKey:@"appToken"];
        [userDefaults synchronize];
//
//
        DLog(@"userModel.app_token = %@",userModel.app_token);
        
        // 读取数据
//        NSString *appToken = [userDefaults valueForKey:@"appToken"];
//        DLog(@"appToken = %@",appToken);
        
//        [httpManager.requestSerializer setValue:@"db3198c079d0a699fc89cee9e6d30588" forHTTPHeaderField:@"app_token"];
        
//        if(appToken){
//            [httpManager.requestSerializer setValue:appToken forHTTPHeaderField:@"app_token"];
//        }else{
            [httpManager.requestSerializer setValue:userModel.app_token forHTTPHeaderField:@"app_token"];
//        }
//
        
        
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

@end

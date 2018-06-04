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
        

        DLog(@"userModel.app_token = %@",userModel.app_token);
        
        // 读取数据
        NSString *appToken = [userDefaults valueForKey:@"appToken"];
        
//        [httpManager.requestSerializer setValue:userModel.app_token forHTTPHeaderField:@"app_token"];
        
        [httpManager.requestSerializer setValue:appToken forHTTPHeaderField:@"app_token"];
        
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

@end

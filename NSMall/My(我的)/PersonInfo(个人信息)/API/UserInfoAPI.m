//
//  UserInfoAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import "UserInfoAPI.h"

@implementation UserInfoAPI
+ (void)getUserInfo:(nullable id)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithGet:param function:kGetInfoAPI showHUD:NetNullStr resultClass:[UserModel class] success:^(UserModel *userModel) {
        [userModel archive];
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}
@end

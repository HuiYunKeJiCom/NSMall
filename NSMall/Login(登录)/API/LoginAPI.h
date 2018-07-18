//
//  LoginAPI.h
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginParam.h"
#import "UserModel.h"
#import "AppVersionParam.h"
#import "AppVersionModel.h"

@interface LoginAPI : NSObject

/*
 登录
 */
+ (void)loginWithParam:(LoginParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 检测APP版本
 */
+ (void)getAppVersion:(nullable AppVersionParam *)param success:(void (^)(AppVersionModel * _Nullable result))success failure:(void (^)(NSError *error))failure;
@end


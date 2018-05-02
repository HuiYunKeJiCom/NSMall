//
//  UserInfoAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserInfoAPI : NSObject
/** 获取用户信息 */
+ (void)getUserInfo:(nullable id)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
@end

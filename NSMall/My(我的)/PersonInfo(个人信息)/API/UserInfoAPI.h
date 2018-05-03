//
//  UserInfoAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "ChangeMobileParam.h"

@interface UserInfoAPI : NSObject
/** 获取用户信息 */
+ (void)getUserInfo:(nullable id)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
/** 更换手机号 */
+ (void)changeMobileWithParam:(ChangeMobileParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
/** 上传用户头像 */
+ (void)uploadHeaderWithParam:(NSDictionary *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
@end

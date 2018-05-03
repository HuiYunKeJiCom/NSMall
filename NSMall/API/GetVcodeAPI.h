//
//  GetVcodeAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetVcodeParam.h"

@interface GetVcodeAPI : NSObject
/** 获取短信验证码 */
+ (void)getVcodeWithParam:(GetVcodeParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
@end


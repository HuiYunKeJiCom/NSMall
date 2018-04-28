//
//  LoginAPI.h
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginParam.h"

@interface LoginAPI : NSObject

+ (void)loginWithParam:(LoginParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

@end

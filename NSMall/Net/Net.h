//
//  Net.h
//  NSMall
//
//  Created by apple on 2018/4/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"

static const NSString * const NetNullStr = @"";

extern AFHTTPSessionManager *httpManager;

@interface Net : NSObject

+ (AFHTTPSessionManager *)httpManager;

//showHUD为可空参数，当showHUD为空时，不显示转圈，不会阻塞UI。若要显示一个单纯的转圈而没有文字，则传入NetNullStr
//若返回值类型为NSNumber、NSDictionary、NSArray等类型，则传入的返回类型需要为nil,解析出的结果将会直接传入回调block
+ (void)requestWithPost:(nullable id)params function:(nullable NSString *)function showHUD:(nullable NSString *)showHUD resultClass:(nullable Class)resultClass success:(nullable void (^)(id _Nullable resultObj))success failure:(nullable void (^)(NSError * _Nullable error))failure;
+ (void)requestWithGet:(nullable id)params function:(nullable NSString *)function showHUD:(nullable NSString *)showHUD resultClass:(nullable Class)resultClass success:(nullable void (^)(id _Nullable resultObj))success failure:(nullable void (^)(NSError * _Nullable error))failure;

//上传文件
+ (void)uploadDataWithPost:(NSDictionary *)params function:(NSString *)function success:(void (^)(NSDictionary *result))success failure:(void (^)(NSError *error))failure;

@end


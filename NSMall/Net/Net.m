//
//  Net.m
//  NSMall
//
//  Created by apple on 2018/4/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "Net.h"


AFHTTPSessionManager *httpManager = nil;

@implementation Net

+ (void)load{
    [super load];
    
}

+ (void)initialize{
    [super initialize];
    [self httpManager];
}

+ (AFHTTPSessionManager *)httpManager{
    if (!httpManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            httpManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@""]];
            httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        });
    }
    return httpManager;
}

+ (void)requestWithGet:(nullable NSDictionary *)params function:(nullable NSString *)function showHUD:(nullable NSString *)showHUD success:(nullable void (^)(NSDictionary * _Nullable responseObj))success failure:(nullable void (^)(NSError * _Nullable error))failure{
    [httpManager GET:@"" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+ (void)requestWithPost:(nullable NSDictionary *)params function:(nullable NSString *)function showHUD:(nullable NSString *)showHUD success:(nullable void (^)(NSDictionary * _Nullable responseObj))success failure:(nullable void (^)(NSError * _Nullable error))failure{
    [httpManager POST:@"" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+ (void)requestWithGet:(nullable id)params function:(nullable NSString *)function showHUD:(nullable NSString *)showHUD resultClass:(nullable Class)resultClass success:(nullable void (^)(id _Nullable resultObj))success failure:(nullable void (^)(NSError * _Nullable error))failure{
    
}

+ (void)requestWithPost:(nullable id)params function:(nullable NSString *)function showHUD:(nullable NSString *)showHUD resultClass:(nullable Class)resultClass success:(nullable void (^)(id _Nullable resultObj))success failure:(nullable void (^)(NSError * _Nullable error))failure{
    
    
}







@end

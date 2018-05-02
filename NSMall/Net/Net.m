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
            httpManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:NetDomainADDR]];
            httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        });
    }
    return httpManager;
}

+ (void)requestWithGet:(nullable NSDictionary *)params function:(nullable NSString *)function showHUD:(nullable NSString *)showHUD success:(nullable void (^)(NSDictionary * _Nullable responseObj))success failure:(nullable void (^)(NSError * _Nullable error))failure{
    if (showHUD) {
        [Common AppShowHUD:showHUD];
    }else
        ;
    
    [httpManager GET:[NSString stringWithFormat:@"%@%@",NetDomainADDR,function] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [Common AppHideHUD];
        NetBaseModel *result = [NetBaseModel yy_modelWithDictionary:responseObject];
        if (!result.success) {
            [Common AppShowToast:result.message];
            failure?failure(nil):nil;
            return;
        }
        success?success(result.data):nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [Common AppHideHUD];
        failure?failure(error):nil;
        [Common AppShowToast:@"网络请求异常"];
    }];
}

+ (void)requestWithPost:(nullable NSDictionary *)params function:(nullable NSString *)function showHUD:(nullable NSString *)showHUD success:(nullable void (^)(NSDictionary * _Nullable responseObj))success failure:(nullable void (^)(NSError * _Nullable error))failure{
    if (showHUD) {
        [Common AppShowHUD:showHUD];
    }else
        ;//do nothing
    
    [httpManager POST:[NSString stringWithFormat:@"%@%@",NetDomainADDR,function] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [Common AppHideHUD];
        NetBaseModel *result = [NetBaseModel yy_modelWithDictionary:responseObject];
        if (!result.success) {
            [Common AppShowToast:result.message];
            failure?failure(nil):nil;
            return;
        }
        success?success(result.data):nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [Common AppHideHUD];
        
        failure?failure(error):nil;
        [Common AppShowToast:@"网络请求异常"];
    }];
}

+ (void)requestWithGet:(nullable id)params function:(nullable NSString *)function showHUD:(nullable NSString *)showHUD resultClass:(nullable Class)resultClass success:(nullable void (^)(id _Nullable resultObj))success failure:(nullable void (^)(NSError * _Nullable error))failure{
    NSDictionary *requestParams = nil;
    if (params == nil || [params isKindOfClass:[NSDictionary class]])
        requestParams = params;
    else
        requestParams = [params yy_modelToJSONObject];
    
    [self requestWithGet:requestParams function:function showHUD:showHUD success:^(NSDictionary * _Nullable responseObj) {
        id resultObj = nil;
        if (resultClass == Nil || [resultClass isKindOfClass:[NSDictionary class]] || [resultClass isKindOfClass:[NSArray class]])
            resultObj = responseObj;
        else
            resultObj = [resultClass yy_modelWithDictionary:responseObj];
        success?success(resultObj):nil;
    } failure:failure];
    
}

+ (void)requestWithPost:(nullable id)params function:(nullable NSString *)function showHUD:(nullable NSString *)showHUD resultClass:(nullable Class)resultClass success:(nullable void (^)(id _Nullable resultObj))success failure:(nullable void (^)(NSError * _Nullable error))failure{
    NSDictionary *requestParams = nil;
    if (params == nil || [params isKindOfClass:[NSDictionary class]])
        requestParams = params;
    else
        requestParams = [params yy_modelToJSONObject];
    
    [self requestWithPost:requestParams function:function showHUD:showHUD success:^(NSDictionary * _Nullable responseObj) {
        id resultObj = nil;
        if (resultClass == Nil || [resultClass isKindOfClass:[NSDictionary class]] || [resultClass isKindOfClass:[NSArray class]])
            resultObj = responseObj;
        else
            resultObj = [resultClass yy_modelWithDictionary:responseObj];
        success?success(resultObj):nil;
    } failure:failure];
}







@end

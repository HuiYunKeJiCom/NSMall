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
//    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:params];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *appToken = [userDefaults valueForKey:@"appToken"];
//    DLog(@"appToken = %@",appToken);
//    [newParam setObject:appToken forKey:@"app_token"];
    
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
//    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:params];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *appToken = [userDefaults valueForKey:@"appToken"];
//    DLog(@"appToken = %@",appToken);
//    [newParam setObject:appToken forKey:@"app_token"];
    
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
//    NSMutableDictionary *newParam;
//    if (params == nil){
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *appToken = [userDefaults valueForKey:@"appToken"];
//        params = [NSDictionary dictionaryWithObject:appToken forKey:@"app_token"];
//    }else{
//        newParam = [NSMutableDictionary dictionaryWithDictionary:params];
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *appToken = [userDefaults valueForKey:@"appToken"];
//        DLog(@"appToken = %@",appToken);
//        [newParam setObject:appToken forKey:@"app_token"];
//    }

    NSDictionary *requestParams = nil;
    if (params == nil || [params isKindOfClass:[NSDictionary class]])
        requestParams = params;
    else
        requestParams = [params yy_modelToJSONObject];
    
    [self requestWithGet:requestParams function:function showHUD:showHUD success:^(NSDictionary * _Nullable responseObj) {
//        NSLog(@"responseObj = %@",responseObj);
        id resultObj = nil;
        if (resultClass == Nil || [resultClass isKindOfClass:[NSDictionary class]] || [resultClass isKindOfClass:[NSArray class]])
            resultObj = responseObj;
        else
            resultObj = [resultClass yy_modelWithDictionary:responseObj];
        success?success(resultObj):nil;
    } failure:failure];
    
}

+ (void)requestWithPost:(nullable id)params function:(nullable NSString *)function showHUD:(nullable NSString *)showHUD resultClass:(nullable Class)resultClass success:(nullable void (^)(id _Nullable resultObj))success failure:(nullable void (^)(NSError * _Nullable error))failure{
    
//    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:params];
//    if (params == nil){
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *appToken = [userDefaults valueForKey:@"appToken"];
//        params = [NSDictionary dictionaryWithObject:appToken forKey:@"app_token"];
//    }else{
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *appToken = [userDefaults valueForKey:@"appToken"];
//        DLog(@"appToken = %@",appToken);
//        [newParam setObject:appToken forKey:@"app_token"];
//    }
    
    NSDictionary *requestParams = nil;
    if (params == nil || [params isKindOfClass:[NSDictionary class]])
        requestParams = params;
    else
        requestParams = [params yy_modelToJSONObject];
    
    [self requestWithPost:requestParams function:function showHUD:showHUD success:^(NSDictionary * _Nullable responseObj) {
        NSLog(@"responseObj = %@",responseObj);
        id resultObj = nil;
        if (resultClass == Nil || [resultClass isKindOfClass:[NSDictionary class]] || [resultClass isKindOfClass:[NSArray class]])
            resultObj = responseObj;
        else
            resultObj = [resultClass yy_modelWithDictionary:responseObj];
        success?success(resultObj):nil;
    } failure:failure];
}


+ (void)uploadDataWithPost:(NSDictionary *)params function:(NSString *)function success:(void (^)(NSDictionary *result))success failure:(void (^)(NSError *error))failure{
    
    UIImage *image = params[@"pic"];
    NSString *imageName = params[@"imageName"];
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.1); // 1 -> 0.1
    NSInteger dataLength = imgData.length;
    CGFloat rate = 1.0;
    if (dataLength >= 1000 * 1000 * 5) {
        rate = 1000.0 * 1000.0 * 5.0 / dataLength;
    } else if (dataLength >= 1000 * 1000 * 2 && dataLength < 1000 * 1000 * 5) {
        rate = 0.7;
    } else {
        rate = 1.0;
    }
    NSData *data = UIImageJPEGRepresentation(image, rate * 0.1);

    
    [httpManager POST:[NSString stringWithFormat:@"%@%@",NetDomainADDR,function] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"image/jpeg"];
//        [formData appendPartWithFormData:data name:@"file" ];multipart/form-data
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success?success(responseObject):nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure?failure(error):nil;
    }];
    
}




@end


//
//  MyAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import "MyAPI.h"

@implementation MyAPI
+ (void)logout:(NSDictionary *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kLogoutAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

+ (void)updatePwdWithParam:(UpdatePwdParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kUpdatePwdAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

+ (void)submitCertificationWithParam:(CertificationParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kCertificationAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

+ (void)getMyProductList:(GetListParam *_Nullable)param success:(void (^)(NSProductListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kMyProductListAPI showHUD:NetNullStr resultClass:[NSProductListModel class] success:^(NSProductListModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:failure];
}

+ (void)getMyStoreList:(GetListParam *_Nullable)param success:(void (^)(NSStoreListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kMyStoreListAPI showHUD:NetNullStr resultClass:[NSStoreListModel class] success:^(NSStoreListModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:failure];
}

+ (void)getCollectProductList:(GetListParam *_Nullable)param success:(void (^)(ProductListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kCollectProductListAPI showHUD:NetNullStr resultClass:[ProductListModel class] success:^(ProductListModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:failure];
}

@end

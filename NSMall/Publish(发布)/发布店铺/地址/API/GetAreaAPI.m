//
//  GetAreaAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import "GetAreaAPI.h"

@implementation GetAreaAPI
+ (void)getAreaWithParam:(GetAreaParam *_Nullable)param success:(void (^_Nullable)(NSAreaModel * _Nullable result))success failure:(void (^_Nullable)(NSError * _Nullable error))failure{
    [Net requestWithGet:param function:kGetAreaAPI showHUD:NetNullStr resultClass:[NSAreaModel class] success:^(NSAreaModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:failure];
}

+ (void)getAddressWithParam:(GetAddressParam *_Nullable)param success:(void (^_Nullable)(NSAddressModel * _Nullable result))success failure:(void (^_Nullable)(NSError * _Nullable error))failure{
    [Net requestWithGet:param function:kGetAddressAPI showHUD:NetNullStr resultClass:[NSAddressModel class] success:^(NSAddressModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:failure];
}

+ (void)saveAddressWithParam:(SaveAddressParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kSaveAddressAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

+ (void)setDefaultAddressWithParam:(SetDefaultAddressParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kSetDefaultAddressAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

+ (void)delAddressWithParam:(DelAddressParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kDelAddressAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}
@end

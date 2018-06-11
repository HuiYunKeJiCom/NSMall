//
//  NearbyStoreAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NearbyStoreAPI.h"

@implementation NearbyStoreAPI

/*
 获取附近店铺列表
 */
+ (void)getNearbyStoreList:(nullable NearbyStoreParam*)param success:(void (^)(NearbyStoreModel *result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kNearbyStoreAPI showHUD:NetNullStr resultClass:[NearbyStoreModel class] success:^(NearbyStoreModel *  _Nullable resultObj) {
        
        success?success(resultObj):nil;
        
    } failure:failure];
}

@end

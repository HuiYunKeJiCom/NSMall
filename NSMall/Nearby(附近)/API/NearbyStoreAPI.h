//
//  NearbyStoreAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NearbyStoreParam.h"
#import "NearbyStoreModel.h"

@interface NearbyStoreAPI : NSObject

/*
 获取附近店铺列表
 */
+ (void)getNearbyStoreList:(nullable NearbyStoreParam*)param success:(void (^)(NearbyStoreModel *result))success failure:(void (^)(NSError *error))failure;

@end

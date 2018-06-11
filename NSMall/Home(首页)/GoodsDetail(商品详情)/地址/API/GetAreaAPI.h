//
//  GetAreaAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetAreaParam.h"
#import "NSAreaModel.h"
#import "GetAddressParam.h"
#import "NSAddressModel.h"
#import "SaveAddressParam.h"
#import "SetDefaultAddressParam.h"
#import "DelAddressParam.h"

@interface GetAreaAPI : NSObject
/*
 获取省市区数据
 */
+ (void)getAreaWithParam:(GetAreaParam *_Nullable)param success:(void (^_Nullable)(NSAreaModel * _Nullable result))success failure:(void (^_Nullable)(NSError * _Nullable error))failure;

/*
 获取收货地址
 */
+ (void)getAddressWithParam:(GetAddressParam *_Nullable)param success:(void (^_Nullable)(NSAddressModel * _Nullable result))success failure:(void (^_Nullable)(NSError * _Nullable error))failure;

/*
 新增/编辑收货地址
 */
+ (void)saveAddressWithParam:(SaveAddressParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 设置默认收货地址
 */
+ (void)setDefaultAddressWithParam:(SetDefaultAddressParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 删除收货地址
 */
+ (void)delAddressWithParam:(DelAddressParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
@end

//
//  NSGetExpressAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGetExpressAPI.h"

@implementation NSGetExpressAPI

/*
 获取快递公司数据
 */
+ (void)getExpressList:(nullable NSString *)parentId success:(void(^)(NSExpressListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    NSDictionary *param = parentId?@{@"parentId":parentId}:nil;
    [Net requestWithPost:param function:kGetShipCompanyAPI showHUD:NetNullStr resultClass:[NSExpressListModel class] success:^(NSExpressListModel *  _Nullable resultObj) {
        
        success?success(resultObj):nil;
        
    } failure:failure];
}


/*
 卖家发货
 */
+ (void)deliveryOrderWithParam:(NSDeliverParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:param function:kDeliveryOrderAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 买家确认收货
 */
+ (void)confirmOrderWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:@{@"orderId":param} function:kConfirmOrderAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

@end

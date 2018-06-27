//
//  OrderDetailAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import "OrderDetailAPI.h"

@implementation OrderDetailAPI
//kOrderDetailAPI

/*
 订单详情
 */
+ (void)getOrderDetailWithParam:(OrderDetailParam *)param success:(void (^)(NSOrderDetailModel *orderDetailModel))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:param function:kOrderDetailAPI showHUD:NetNullStr resultClass:[NSOrderDetailModel class] success:^(NSOrderDetailModel  *_Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
    
}

@end

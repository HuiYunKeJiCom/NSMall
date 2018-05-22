//
//  MyOrderAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "MyOrderAPI.h"

@implementation MyOrderAPI
/*
 获取我的订单列表
 */
+ (void)getMyOrderList:(nullable MyOrderParam *)param success:(void (^)(NSOrderListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kOrderListAPI showHUD:NetNullStr resultClass:[NSOrderListModel class] success:^(NSOrderListModel  * _Nullable  resultObj){
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}
@end

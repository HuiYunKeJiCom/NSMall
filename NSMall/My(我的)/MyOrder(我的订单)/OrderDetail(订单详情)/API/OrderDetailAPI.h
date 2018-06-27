//
//  OrderDetailAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailParam.h"
#import "NSOrderDetailModel.h"

@interface OrderDetailAPI : NSObject
/*
 订单详情
 */
+ (void)getOrderDetailWithParam:(OrderDetailParam *)param success:(void (^)(NSOrderDetailModel *orderDetailModel))success faulre:(void (^)(NSError *error))failure;
@end

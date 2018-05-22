//
//  MyOrderAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyOrderParam.h"
#import "NSOrderListModel.h"

@interface MyOrderAPI : NSObject
/*
 获取我的订单列表
 */
+ (void)getMyOrderList:(nullable MyOrderParam *)param success:(void (^)(NSOrderListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;
@end

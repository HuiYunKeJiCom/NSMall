//
//  NSGetExpressAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSExpressListModel.h"
#import "NSDeliverParam.h"

@interface NSGetExpressAPI : NSObject

/*
 获取快递公司数据
 */
+ (void)getExpressList:(nullable NSString *)parentId success:(void(^)(NSExpressListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

/*
 卖家发货
 */
+ (void)deliveryOrderWithParam:(NSDeliverParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *error))failure;

/*
 买家确认收货
 */
+ (void)confirmOrderWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *error))failure;

@end

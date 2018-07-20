//
//  ReceivableRecordAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRecordLogModel.h"
#import "NSCommonParam.h"
#import "NSPayParam.h"

@interface ReceivableRecordAPI : NSObject

/*
 收款记录
 */
+ (void)getTradeLog:(nullable NSCommonParam *)param success:(void (^)(NSRecordLogModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

/*
 收付款
 */
+ (void)tradeWithParam:(NSPayParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

@end

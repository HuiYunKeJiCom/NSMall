//
//  ReceivableRecordAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "ReceivableRecordAPI.h"

@implementation ReceivableRecordAPI

/*
 收款记录
 */
+ (void)getTradeLog:(nullable NSCommonParam *)param success:(void (^)(NSRecordLogModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kTradeLogAPI showHUD:NetNullStr resultClass:[NSRecordLogModel class] success:^(NSRecordLogModel  * _Nullable  resultObj){
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}
@end

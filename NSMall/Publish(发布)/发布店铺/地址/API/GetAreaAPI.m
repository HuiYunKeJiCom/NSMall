//
//  GetAreaAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import "GetAreaAPI.h"

@implementation GetAreaAPI
+ (void)getArea:(GetAreaParam *_Nullable)param success:(void (^_Nullable)(NSAreaModel * _Nullable result))success failure:(void (^_Nullable)(NSError * _Nullable error))failure{
    [Net requestWithGet:param function:kGetAreaAPI showHUD:NetNullStr resultClass:[NSAreaModel class] success:^(NSAreaModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:failure];
}
@end

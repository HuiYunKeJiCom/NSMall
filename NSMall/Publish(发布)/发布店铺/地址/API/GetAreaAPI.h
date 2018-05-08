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

@interface GetAreaAPI : NSObject
/*
 获取省市区数据
 */
+ (void)getArea:(GetAreaParam *_Nullable)param success:(void (^_Nullable)(NSAreaModel * _Nullable result))success failure:(void (^_Nullable)(NSError * _Nullable error))failure;
@end

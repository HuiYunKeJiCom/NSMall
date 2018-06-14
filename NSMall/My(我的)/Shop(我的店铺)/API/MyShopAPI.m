//
//  MyShopAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import "MyShopAPI.h"

@implementation MyShopAPI

/*
 删除店铺
 */
+ (void)delShopWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:@{@"storeId":param} function:kRemoveStoreAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

@end

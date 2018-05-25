//
//  GoodsDetailAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import "GoodsDetailAPI.h"

@implementation GoodsDetailAPI

/*
 获取商品详情
 */
+ (void)getDetailWithGoodsID:(NSString *)productId success:(void (^)(NSGoodsDetailModel *model))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:@{@"productId":productId} function:kProductDetailAPI showHUD:NetNullStr resultClass:[NSGoodsDetailModel class] success:^(NSGoodsDetailModel *resultObj) {
        success?success(resultObj):nil;
    } failure:failure];
}

@end

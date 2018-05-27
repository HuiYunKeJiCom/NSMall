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

/*
 收藏/取消收藏商品
 */
+ (void)changeProductCollectState:(NSString *)productId success:(void (^)(NSCollectModel *model))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:@{@"productId":productId} function:kCollectProductAPI showHUD:NetNullStr resultClass:[NSCollectModel class] success:^(NSCollectModel *resultObj) {
        success?success(resultObj):nil;
    } failure:failure];
}

/*
 *添加商品到购物车
 */
+ (void)addProductToCartWithParam:(NSAddCartParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kAddCartAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

@end

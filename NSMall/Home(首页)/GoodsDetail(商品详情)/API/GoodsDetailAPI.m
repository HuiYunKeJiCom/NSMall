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

/*
 *获取立即购买页面数据
 */
+ (void)getBuyNowProductToCartWithParam:(NSAddCartParam *)param success:(void (^)(NSBuyNowModel *buyNowModel))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kGetCheckDataAPI showHUD:NetNullStr resultClass:[NSBuyNowModel class] success:^(NSBuyNowModel  *_Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 *立即购买提交订单
 */
+ (void)buildOrderNowWithParam:(NSBuildOrderNowParam *)param success:(void (^)(NSWalletListModel *walletList))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kBuildOrderNowAPI showHUD:NetNullStr resultClass:[NSWalletListModel class] success:^(NSWalletListModel  *_Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
    
}

/*
 获取商品评论列表
 */
+ (void)getkProductCommentList:(nullable NSProductCommentParam *)param success:(void (^)(NSCommentListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kProductCommentAPI showHUD:NetNullStr resultClass:[NSCommentListModel class] success:^(NSCommentListModel  * _Nullable  resultObj){
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 删除商品评论
 */
+ (void)delCommentWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:@{@"id":param} function:kRemoveCommentAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 发布商品评论
 */
+ (void)publishComment:(nullable NSPublishCommentParam *)param success:(void (^)(NSCommentItemModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithPost:param function:kPublishCommentAPI showHUD:NetNullStr resultClass:[NSCommentItemModel class] success:^(NSCommentItemModel  * _Nullable  resultObj){
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

@end

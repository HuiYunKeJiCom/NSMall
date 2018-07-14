//
//  GoodsDetailAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSGoodsDetailModel.h"
#import "NSCollectModel.h"
#import "NSAddCartParam.h"
#import "NSBuildOrderNowParam.h"
#import "NSWalletListModel.h"
#import "NSBuyNowModel.h"
#import "NSProductCommentParam.h"
#import "NSCommentListModel.h"
#import "NSPublishCommentParam.h"


@interface GoodsDetailAPI : NSObject

/*
 获取商品详情
 */
+ (void)getDetailWithGoodsID:(NSString *)productId success:(void (^)(NSGoodsDetailModel *model))success failure:(void (^)(NSError *error))failure;

/*
 收藏/取消收藏商品
 */
+ (void)changeProductCollectState:(NSString *)productId success:(void (^)(NSCollectModel *model))success failure:(void (^)(NSError *error))failure;

/*
 *添加商品到购物车
 */
+ (void)addProductToCartWithParam:(NSAddCartParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 *获取立即购买页面数据
 */
+ (void)getBuyNowProductToCartWithParam:(NSAddCartParam *)param success:(void (^)(NSBuyNowModel *buyNowModel))success faulre:(void (^)(NSError *))failure;

/*
 *立即购买提交订单
 */
+ (void)buildOrderNowWithParam:(NSBuildOrderNowParam *)param success:(void (^)(NSWalletListModel *walletList))success faulre:(void (^)(NSError *))failure;

/*
 获取商品评论列表
 */
+ (void)getkProductCommentList:(nullable NSProductCommentParam *)param success:(void (^)(NSCommentListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

/*
 删除商品评论
 */
+ (void)delCommentWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 发布商品评论
 */
+ (void)publishComment:(nullable NSPublishCommentParam *)param success:(void (^)(NSCommentItemModel * _Nullable result))success failure:(void (^)(NSError *error))failure;
@end

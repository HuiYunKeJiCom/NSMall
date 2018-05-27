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
@end

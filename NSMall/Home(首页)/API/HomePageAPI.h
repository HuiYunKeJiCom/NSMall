//
//  HomePageAPI.h
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductListModel.h"
#import "AdvertListModel.h"
#import "CategoryModel.h"
#import "CategoryListModel.h"
#import "SearchModel.h"
#import "SearchParam.h"
#import "NSLikeModel.h"

@interface HomePageAPI : NSObject


/*
    获取首页商品信息的接口
 */
//参数可以为空，为空时服务器会返回默认的结果
+ (void)getProductList:(nullable id)param success:(void (^)(ProductListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

/*
    获取首页广告信息的接口
 */
+ (void)getHomePageAdvertInfro:(id)param success:(void (^)(AdvertListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

/*
    获取分类信息接口
*/
+ (void)getProductCategoryList:(nullable NSString *)parentId success:(void(^)(CategoryListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

/*
    改变商品的点赞状态
 */
+ (void)changeProductLikeState:(NSString *)productId success:(void (^)(NSLikeModel *model))success failure:(void (^)(NSError *error))failure;


/*
    搜索商铺或者商品
 */
+ (void)searchProductOrShop:(nullable SearchParam*)param success:(void (^)(SearchModel *result))success failure:(void (^)(NSError *error))failure;


@end

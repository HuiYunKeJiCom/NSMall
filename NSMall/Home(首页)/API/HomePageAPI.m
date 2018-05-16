//
//  HomePageAPI.m
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "HomePageAPI.h"

@implementation HomePageAPI

+ (void)getProductList:(nullable id)param success:(void (^)(ProductListModel *result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kHomePageProductListAPI showHUD:NetNullStr resultClass:[ProductListModel class] success:^(ProductListModel  * _Nullable  resultObj){
        success?success(resultObj):nil;
    } failure:failure];
}

/*
 获取首页广告信息的接口
 */
+ (void)getHomePageAdvertInfro:(id)param success:(void (^)(AdvertListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kHomePageAdvertListAPI showHUD:nil resultClass:[AdvertListModel class] success:^(AdvertListModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:failure];
}

/*
 获取分类信息接口
 */
+ (void)getProductCategoryList:(nullable NSString *)parentId success:(void(^)(CategoryListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    NSDictionary *param = parentId?@{@"parentId":parentId}:nil;
    [Net requestWithGet:param function:kCatogeryListAPI showHUD:NetNullStr resultClass:[CategoryListModel class] success:^(CategoryListModel *  _Nullable resultObj) {

        success?success(resultObj):nil;

    } failure:failure];
}

/*
 改变商品的点赞状态
 */
+ (void)changeProductLikeState:(NSString *)productId success:(void (^)(NSInteger likeNumber))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:@{@"productId":productId} function:kLikeProductAPI showHUD:NetNullStr resultClass:[NSNumber class] success:^(NSNumber *resultObj) {
        success?success(resultObj.integerValue):nil;
    } failure:failure];
}



@end

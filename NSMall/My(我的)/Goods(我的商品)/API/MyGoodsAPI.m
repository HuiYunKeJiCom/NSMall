//
//  MyGoodsAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import "MyGoodsAPI.h"

@implementation MyGoodsAPI
/*
 删除商品
 */
+ (void)delGoodsWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:@{@"productId":param} function:kRemoveProductAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 获取要编辑的商品信息
 */
+ (void)getEditedGoodsWithParam:(NSString *)param success:(void (^)(NSGoodsItemModel * _Nullable result))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:@{@"productId":param} function:kProductForUpdateAPI showHUD:NetNullStr resultClass:[NSGoodsItemModel class] success:^(NSGoodsItemModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}


/*
 *编辑商品
 */
+ (void)updateGoodsWithParam:(GoodsPublishParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kUpdateProductAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

@end

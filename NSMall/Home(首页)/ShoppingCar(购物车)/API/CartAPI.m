//
//  CartAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/27.
//  Copyright © 2018年 www. All rights reserved.
//

#import "CartAPI.h"

@implementation CartAPI
/*
 获取购物车列表
 */
+ (void)getCartList:(nullable id)param success:(void (^)(NSCartModel *cartModel))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kCartListAPI showHUD:NetNullStr resultClass:[NSCartModel class] success:^(NSCartModel  * _Nullable  resultObj){
        success?success(resultObj):nil;
    } failure:failure];
}

/*
 修改购物车商品数量
 */
+ (void)changeCartNumWithParam:(NSChangeCartNumParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kUpdateCartCountAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}


/*
 删除购物车商品
 */
+ (void)removeCartWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:@{@"cartId":param} function:kRemoveCartAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 获取购物车结算页面数据
 */
+ (void)checkCartDataWithParam:(NSString *)param success:(void (^)(NSFirmOrderModel *firmOrderModel))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:@{@"cartId":param} function:kGetCartCheckDataAPI showHUD:NetNullStr resultClass:[NSFirmOrderModel class] success:^(NSFirmOrderModel  *_Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];

}
@end

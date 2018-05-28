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
@end

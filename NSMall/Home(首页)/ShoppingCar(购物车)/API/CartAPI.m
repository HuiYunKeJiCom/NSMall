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
        NSLog(@"NSCartModel = %@",resultObj.mj_keyValues);
        success?success(resultObj):nil;
    } failure:failure];
}


@end

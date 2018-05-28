//
//  CartAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/27.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSCartModel.h"
#import "NSChangeCartNumParam.h"

@interface CartAPI : NSObject
/*
 获取购物车列表
 */
+ (void)getCartList:(nullable id)param success:(void (^)(NSCartModel *cartModel))success failure:(void (^)(NSError *error))failure;

/*
 修改购物车商品数量
 */
+ (void)changeCartNumWithParam:(NSChangeCartNumParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 删除购物车商品
 */
+ (void)removeCartWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
@end

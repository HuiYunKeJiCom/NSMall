//
//  GoodsDetailAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSGoodsDetailModel.h"

@interface GoodsDetailAPI : NSObject

/*
 获取商品详情
 */
+ (void)getDetailWithGoodsID:(NSString *)productId success:(void (^)(NSGoodsDetailModel *model))success failure:(void (^)(NSError *error))failure;

@end

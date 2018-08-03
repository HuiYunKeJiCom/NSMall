//
//  MyGoodsAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSGoodsItemModel.h"
#import "GoodsPublishParam.h"

@interface MyGoodsAPI : NSObject
/*
 删除商品
 */
+ (void)delGoodsWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 获取要编辑的商品信息
 */
+ (void)getEditedGoodsWithParam:(NSString *)param success:(void (^)(NSGoodsItemModel * _Nullable result))success faulre:(void (^)(NSError *error))failure;

/*
 *编辑商品
 */
+ (void)updateGoodsWithParam:(GoodsPublishParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
@end

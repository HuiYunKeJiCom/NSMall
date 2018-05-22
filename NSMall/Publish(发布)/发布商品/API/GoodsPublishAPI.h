//
//  GoodsPublishAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsPublishParam.h"
#import "ShelveProductParam.h"

@interface GoodsPublishAPI : NSObject

/*
 商品图片上传
 */
+ (void)uploadGoodsPicWithParam:(NSDictionary *)params success:(void (^)(NSString *path))success faulre:(void (^)(NSError *))failure;

/*
 *商品发布
 */
+ (void)createProductWithParam:(GoodsPublishParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 *上/下架商品
 */
+ (void)shelveProductWithParam:(ShelveProductParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
@end

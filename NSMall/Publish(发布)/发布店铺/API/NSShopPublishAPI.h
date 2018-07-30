//
//  NSShopPublishAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopPublishParam.h"

@interface NSShopPublishAPI : NSObject
/*
 店铺图片上传
 */
+ (void)uploadStorePicWithParam:(NSDictionary *)params success:(void (^)(NSString *path))success faulre:(void (^)(NSError *))failure;

/*
 *店铺发布
 */
+ (void)createShopWithParam:(ShopPublishParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 *编辑店铺
 */
+ (void)updateShopWithParam:(ShopPublishParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
@end

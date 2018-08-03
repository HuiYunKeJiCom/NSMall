//
//  MyGoodsAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGoodsAPI : NSObject
/*
 删除商品
 */
+ (void)delGoodsWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
@end

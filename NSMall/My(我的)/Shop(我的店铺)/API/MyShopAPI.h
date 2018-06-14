//
//  MyShopAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyShopAPI : NSObject

/*
 删除店铺
 */
+ (void)delShopWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

@end

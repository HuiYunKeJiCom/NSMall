//
//  HomePageAPI.h
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageAPI : NSObject

+ (void)getProductList:(nullable id)param success:(void (^)(NSDictionary *result))success failure:(void (^)(NSError *error))failure;

@end

//
//  HomePageAPI.m
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "HomePageAPI.h"

@implementation HomePageAPI

+ (void)getProductList:(nullable id)param success:(void (^)(NSDictionary *result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kHomePageProductListAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        DLog(@"resultObj : %@",resultObj);
    } failure:failure];
}

@end

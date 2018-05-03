//
//  HomePageAPI.m
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "HomePageAPI.h"

@implementation HomePageAPI

+ (void)getProductList:(nullable id)param success:(void (^)(ProductListModel *result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kHomePageProductListAPI showHUD:NetNullStr resultClass:[ProductListModel class] success:^(ProductListModel  * _Nullable  resultObj){
        success?success(resultObj):nil;
    } failure:failure];
}

@end

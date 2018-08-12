//
//  SearchModel.m
//  NSMall
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"productList":[ProductListItemModel class],@"storeList":[NSShopListItemModel class],@"labelList":[LabelItemModel class]};
}

@end

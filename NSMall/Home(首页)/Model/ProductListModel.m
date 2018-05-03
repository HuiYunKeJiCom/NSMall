//
//  ProductListModel.m
//  NSMall
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import "ProductListModel.h"

@implementation ProductListModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"productList":[ProductListItemModel class]};
}

@end

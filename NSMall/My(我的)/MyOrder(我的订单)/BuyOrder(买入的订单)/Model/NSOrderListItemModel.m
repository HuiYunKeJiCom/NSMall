//
//  NSOrderListItemModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSOrderListItemModel.h"

@implementation NSOrderListItemModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"productList":[NSOrderProductItemModel class]};
}
@end

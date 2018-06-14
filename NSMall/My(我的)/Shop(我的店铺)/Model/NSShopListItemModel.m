//
//  NSShopListItemModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/18.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSShopListItemModel.h"


@implementation NSShopListItemModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"labelList":[LabelItemModel class]};
}
@end

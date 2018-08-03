//
//  NSGoodsItemModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGoodsItemModel.h"

@implementation NSGoodsItemModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"productSpecList":[NSProductSpecModel class]};
}
@end

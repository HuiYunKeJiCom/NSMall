//
//  NSGoodsDetailModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGoodsDetailModel.h"

@implementation NSGoodsDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"productSpecList":[NSDetailItemModel class]};
}
@end


//
//  NSCartModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/27.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCartModel.h"

@implementation NSCartModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"result":[LZShopModel class]};
}
@end

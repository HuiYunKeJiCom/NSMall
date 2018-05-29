//
//  NSFirmOrderModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/29.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSFirmOrderModel.h"

@implementation NSFirmOrderModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"cartList":[LZShopModel class]};
}
@end

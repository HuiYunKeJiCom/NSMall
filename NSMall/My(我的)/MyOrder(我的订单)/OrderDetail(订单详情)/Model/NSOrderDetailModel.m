//
//  NSOrderDetailModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSOrderDetailModel.h"

@implementation NSOrderDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"productList":[NSODItemModel class]};
}
@end

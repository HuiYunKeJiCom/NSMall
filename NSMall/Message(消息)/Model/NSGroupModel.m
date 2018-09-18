//
//  NSGroupModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGroupModel.h"

@implementation NSGroupModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"groupDescription": @"description"};
}
@end

//
//  NSGroupListModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/30.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGroupListModel.h"

@implementation NSGroupListModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"group":[NSGroupModel class]};
}

@end

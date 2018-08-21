//
//  NSExpressListModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSExpressListModel.h"

@implementation NSExpressListModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"result":[NSExpressModel class]};
}

@end

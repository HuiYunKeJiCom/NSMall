//
//  NSRPRecordModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSRPRecordModel.h"

@implementation NSRPRecordModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"list":[NSRecordItemModel class]};
}
@end

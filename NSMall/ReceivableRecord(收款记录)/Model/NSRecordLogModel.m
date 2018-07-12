//
//  NSRecordLogModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSRecordLogModel.h"

@implementation NSRecordLogModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"logs":[NSLogListModel class]};
}
@end

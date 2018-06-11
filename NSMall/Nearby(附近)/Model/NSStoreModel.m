//
//  NSStoreModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSStoreModel.h"

@implementation NSStoreModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"labelList":[LabelItemModel class]};
}
@end

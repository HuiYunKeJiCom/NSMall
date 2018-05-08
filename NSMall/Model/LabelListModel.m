//
//  LabelListModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import "LabelListModel.h"

@implementation LabelListModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"labelList":[LabelItemModel class]};
}
@end

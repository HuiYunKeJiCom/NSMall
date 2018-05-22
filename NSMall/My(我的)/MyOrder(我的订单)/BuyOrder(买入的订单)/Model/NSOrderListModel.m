//
//  NSOrderListModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSOrderListModel.h"

@implementation NSOrderListModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"orderList":[NSOrderListItemModel class]};
}
@end

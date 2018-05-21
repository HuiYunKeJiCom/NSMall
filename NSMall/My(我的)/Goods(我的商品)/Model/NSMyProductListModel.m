//
//  NSMyProductListModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/17.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMyProductListModel.h"

@implementation NSMyProductListModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"productList":[NSMyProductListItemModel class]};
}
@end

//
//  NSShopListModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/18.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSShopListModel.h"


@implementation NSShopListModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"storeList":[NSShopListItemModel class]};
}
@end

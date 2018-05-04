//
//  AdvertListModel.m
//  NSMall
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 www. All rights reserved.
//

#import "AdvertListModel.h"

@implementation AdvertListModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"advertList":[AdvertItemModel class]};
}

@end

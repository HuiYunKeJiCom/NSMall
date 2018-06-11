//
//  NearbyStoreModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NearbyStoreModel.h"

@implementation NearbyStoreModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"storeList":[NSStoreModel class]};
}
@end

//
//  LZShopModel.m
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZShopModel.h"
#import "LZGoodsModel.h"

@implementation LZShopModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"productList":[LZGoodsModel class]};
}


@end

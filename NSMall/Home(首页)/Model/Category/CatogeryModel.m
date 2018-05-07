//
//  CatogeryModel.m
//  NSMall
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 www. All rights reserved.
//

#import "CatogeryModel.h"

@implementation CatogeryModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"children":[CatogeryModel class]};
}

@end

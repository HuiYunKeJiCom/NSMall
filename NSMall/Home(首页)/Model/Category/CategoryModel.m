//
//  CatogeryModel.m
//  NSMall
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 www. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"children":[CategoryModel class]};
}

@end

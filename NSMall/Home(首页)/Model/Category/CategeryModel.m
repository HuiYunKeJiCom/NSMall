//
//  CatogeryModel.m
//  NSMall
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 www. All rights reserved.
//

#import "CategeryModel.h"

@implementation CategeryModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"children":[CategeryModel class]};
}

@end

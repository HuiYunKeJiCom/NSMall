//
//  CategoryShellModel.m
//  NSMall
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import "CategoryListModel.h"

@implementation CategoryListModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"categoryList":[CategoryModel class]};
}

@end

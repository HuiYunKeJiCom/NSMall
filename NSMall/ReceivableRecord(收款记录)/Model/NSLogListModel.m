//
//  NSLogListModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSLogListModel.h"

@implementation NSLogListModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"list":[NSLogItemModel class]};
}

-(float)cellHeight{
    return self.list.count*(66)+41;
}
@end

//
//  NSFriendListModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSFriendListModel.h"

@implementation NSFriendListModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"list":[NSFriendItemModel class]};
}
@end

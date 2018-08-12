//
//  NSRPListModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSRPListModel.h"

@implementation NSRPListModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"receiveRedpacketList":[NSRPItemModel class]};
}
@end

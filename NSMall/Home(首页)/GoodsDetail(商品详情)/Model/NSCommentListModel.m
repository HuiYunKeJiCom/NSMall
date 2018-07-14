//
//  NSCommentListModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCommentListModel.h"

@implementation NSCommentListModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"commentList":[NSCommentItemModel class]};
}
@end

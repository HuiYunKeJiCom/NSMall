//
//  NSCommentItemModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCommentItemModel.h"

@implementation NSCommentItemModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"replyList":[NSReplyItemModel class]};
}
@end

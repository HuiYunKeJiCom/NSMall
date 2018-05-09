//
//  UpdatePwdParam.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import "UpdatePwdParam.h"

@implementation UpdatePwdParam
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"password":@"newPassword"};
}
@end

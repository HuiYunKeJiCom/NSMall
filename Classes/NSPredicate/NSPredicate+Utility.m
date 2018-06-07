//
//  NSPredicate+Utility.m
//  Lock
//
//  Created by occ on 2017/5/26.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "NSPredicate+Utility.h"

@implementation NSPredicate (Utility)

+ (BOOL)isEmail:(NSString *)email
{
    NSString *      regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:email];
}

+ (BOOL)isUrl:(NSString *)url
{
    NSString *      regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:url];
}

+ (BOOL)isPhone:(NSString *)phone
{
    
    // 17[678]  17[0-9]这可以是虚拟号
    NSString *reg = @"^(13[0-9]|15[012356789]|17[0-9]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    if ([predicate evaluateWithObject:phone]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isTelephone:(NSString *)phone
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];

    return  [regextestmobile evaluateWithObject:phone]   ||
    [regextestphs evaluateWithObject:phone]      ||
    [regextestct evaluateWithObject:phone]       ||
    [regextestcu evaluateWithObject:phone]       ||
    [regextestcm evaluateWithObject:phone];
}


+ (BOOL)isUserName:(NSString *)name
{
    NSString *      regex = @"(^[A-Za-z0-9]{3,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:name];
}

+ (BOOL)isPassword:(NSString *)pass
{
    NSString *      regex = @"(^[A-Za-z0-9]{6,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:pass];
}


//+ (BOOL)isQQ:(NSString *)qq {
//    NSString *      regex = @"(^[1-9]d{4,9}$)";
//    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    return [pred evaluateWithObject:qq];
//}

+ (BOOL)isDigital:(NSString *)digital {
    NSString *      regex = @"(^[0-9]*$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:digital];

}
@end

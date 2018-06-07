//
//  NSPredicate+Utility.h
//  Lock
//
//  Created by occ on 2017/5/26.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (Utility)

/**邮箱*/
+ (BOOL)isEmail:(NSString *)email;

+ (BOOL)isUrl:(NSString *)url;

/**是否手机号码*/
+ (BOOL)isPhone:(NSString *)phone;

+ (BOOL)isTelephone:(NSString *)phone;

+ (BOOL)isUserName:(NSString *)name;

+ (BOOL)isPassword:(NSString *)pass;

/**QQ号码*/
//+ (BOOL)isQQ:(NSString *)qq;

/**数字*/
+ (BOOL)isDigital:(NSString *)digital;
@end

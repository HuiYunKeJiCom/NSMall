//
//  NSDate+Addition.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)
+ (NSString *)currentDateStringWithFormat:(NSString *)format;
- (NSString *)dateWithFormat:(NSString *)format;
+ (NSDate *)getNowDateUTC;

//日期比较大小
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

@end

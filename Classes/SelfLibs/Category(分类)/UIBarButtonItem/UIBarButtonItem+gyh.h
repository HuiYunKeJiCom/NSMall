//
//  UIBarButtonItem+gyh.h
//  
//
//  Created by gyh on 15-3-9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (gyh)

/**
 *  快速创建一个显示图片的item
 */
+(UIBarButtonItem *)ItemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

/**
 *  带背景
 */
+(UIBarButtonItem *)ItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  不带背景
 */
+(UIBarButtonItem *)ItemTitle:(NSString *)title target:(id)target action:(SEL)action;
@end

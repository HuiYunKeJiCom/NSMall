//
//  UILabel+LBExt.h
//  EasyLife
//
//  Created by DingJian on 16/3/14.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LBExt)


/**
 *  简化label的设置,默认字体颜色黑色。
 *
 *  @param frame label大小
 *  @param size  显示文字大小
 *
 *
 */
-(id)initWithFrame:(CGRect)frame FontSize:(CGFloat)size;

/**
 *  简化label的设置
 *
 *  @param frame label大小
 *  @param size  显示文字大小
 *  @param color 显示文字颜色
 *
 */

-(id)initWithFrame:(CGRect)frame FontSize:(CGFloat)size TextColor:(UIColor *)color;

/**
 *  简化label的设置
 *
 *  @param frame label大小
 *  @param size  显示文字大小
 *  @param color 显示文字颜色
 *  
 *
 */

-(id)initWithFrame:(CGRect)frame FontSize:(CGFloat)size TextColor:(UIColor *)color text:(NSString *)text;

//设置圆角
- (void)setRadiusSize:(CGFloat)radiusSize;

@end

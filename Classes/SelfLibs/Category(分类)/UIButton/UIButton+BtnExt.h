//
//  UIButton+BtnExt.h
//  EasyLife
//
//  Created by DingJian on 16/3/15.
//  Copyright © 2016年 CCJ. All rights reserved.
//



@interface UIButton (BtnExt)

/**
 *  不带文字但可以点击跳转
 */
-(id)initWithFrame:(CGRect)frame fontSize:(CGFloat)size titleColor:(UIColor *)color;

/**
 *  有文字但可以点击跳转
 */
-(id)initWithFrame:(CGRect)frame fontSize:(CGFloat)size titleColor:(UIColor *)color title:(NSString *)title;

/**
 *  常用类型，只有图片的btn
 */
-(id)initWithFrame:(CGRect)frame imgNormal:(NSString *)imgNormal;

-(id)initWithFrame:(CGRect)frame imgNormal:(NSString *)imgNormal imgHighLight:(NSString *)imgHighLight;

/**
 *  图片与标题共存的的btn
 */
-(id)initWithFrame:(CGRect)frame title:(NSString *)title img:(NSString *)img ;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title img:(NSString *)img fontSize:(CGFloat)size;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title img:(NSString *)img fontSize:(CGFloat)size titleColor:(UIColor *)color;


/**
 初始化一个左标题+右图片的UIButton

 @param title 标题
 @param image 图片
 @param font 字体
 @return UIButton
 */
- (instancetype) initLeftTitle:(NSString*)title rightImage:(UIImage*)image font:(UIFont*)font;



//添加事件
-(void)addTarget:(id)target action:(SEL)action;

//设置圆角
- (void)setRadiusSize:(CGFloat)radiusSize;

@end

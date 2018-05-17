//
//  UIButton+BtnExt.m
//  EasyLife
//
//  Created by DingJian on 16/3/15.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import "UIButton+BtnExt.h"

@implementation UIButton (BtnExt)


-(id)initWithFrame:(CGRect)frame fontSize:(CGFloat)size titleColor:(UIColor *)color
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    [self setTitleColor:color forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:size]];
    return self;
}

#define KLocalizableStr2(key) [NSString stringWithFormat:@"%@",key];
#define KLocalizableStr3 @"";

//[(AppDelegate *)[[UIApplication sharedApplication] delegate] showText:(key)]

-(id)initWithFrame:(CGRect)frame fontSize:(CGFloat)size titleColor:(UIColor *)color title:(NSString *)title {
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    [self setTitleColor:color forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:size]];
    
    [self setTitle:title forState:UIControlStateNormal];
    
    return self;
}

/**
 *  常用类型，只有图片的btn
 */
-(id)initWithFrame:(CGRect)frame imgNormal:(NSString *)imgNormal
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    [self setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
    
    return self;
}

-(id)initWithFrame:(CGRect)frame imgNormal:(NSString *)imgNormal imgHighLight:(NSString *)imgHighLight
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    [self setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:imgHighLight] forState:UIControlStateHighlighted];
    
    return self;
}

/**
 *  图片与标题共存的的btn
 */
-(id)initWithFrame:(CGRect)frame title:(NSString *)title img:(NSString *)img
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    return self;
}
-(id)initWithFrame:(CGRect)frame title:(NSString *)title img:(NSString *)img fontSize:(CGFloat)size
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:size]];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    return self;
}
-(id)initWithFrame:(CGRect)frame title:(NSString *)title img:(NSString *)img fontSize:(CGFloat)size titleColor:(UIColor *)color
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:size]];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    return self;
}

/**
 初始化一个左标题+右图片的UIButton
 
 @param title 标题
 @param image 图片
 @param font 字体
 @return UIButton
 */
- (instancetype) initLeftTitle:(NSString*)title rightImage:(UIImage*)image font:(UIFont*)font {
    self = [super init];
    if (self) {
        if (title && title.length > 0 && !image) {
            [self setTitle:title forState:UIControlStateNormal];
            if (font) {
                [self.titleLabel setFont:font];
            }
        }
        else if (image && (!title || title.length == 0)) {
            [self setImage:image forState:UIControlStateNormal];
            
        }
        else if (title && title.length > 0 && image) {
            if (!font) {
                font = [UIFont systemFontOfSize:14];
            }
            CGSize textSize = [title sizeWithAttributes:@{NSFontAttributeName:font}];
            CGSize imgSize = image.size;//CGSizeMake(textSize.height, textSize.height);//image.size;
            [self setTitle:title forState:UIControlStateNormal];
            [self setImage:image forState:UIControlStateNormal];
            self.titleLabel.font = font;
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, textSize.width + 5, 0, -5)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, - imgSize.width, 0, 0)];
            
//            [self setImageEdgeInsets:UIEdgeInsetsMake(0, textSize.width + 4 + imgSize.width * 0.5, 0, - 4 - imgSize.width * 0.5)];
//            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, - imgSize.width - imgSize.width * 0.5 - 4, 0, 0)];
        }
     }
    return self;
}


-(void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setRadiusSize:(CGFloat)radiusSize {
    
    if (self.layer.cornerRadius != radiusSize) {
        self.layer.cornerRadius = radiusSize;
        self.layer.masksToBounds = YES;
    }
}

@end

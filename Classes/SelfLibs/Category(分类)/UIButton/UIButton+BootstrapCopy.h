//
//  UIButton+BootstrapCopy.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BootstrapCopy)
//- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before;
-(void)bootstrapStyle:(CGFloat)cornerRadius;
//-(void)defaultStyleWithNormalTitleColor:(UIColor *)titleColor andHighTitleColor:(UIColor *)highTitleColor andBorderColor:(UIColor *)borderColor andBgColor:(UIColor *)bgColor andHighBgColor:(UIColor *)highBgColor;
-(void)defaultStyleWithNormalTitleColor:(UIColor *)titleColor andHighTitleColor:(UIColor *)highTitleColor andBorderColor:(UIColor *)borderColor andBackgroundColor:(UIColor *)bgColor andHighBgColor:(UIColor *)highBgColor withcornerRadius:(CGFloat)cornerRadius;

/** 设置按钮的全部属性 */
-(void)defaultStyleWithNormalTitleColor:(UIColor *)titleColor andHighTitleColor:(UIColor *)highTitleColor andBorderColor:(UIColor *)borderColor andBackgroundColor:(UIColor *)bgColor andHighBgColor:(UIColor *)highBgColor andSelectedBgColor:(UIColor *)selectedBgColor withcornerRadius:(CGFloat)cornerRadius;
/** 只设置按钮的 背影颜色 */
-(void)customBtnStyleBackgroundColor:(UIColor *)bgColor andHighBgColor:(UIColor *)highBgColor andSelectedBgColor:(UIColor *)selectedBgColor;

- (void)setImageWithTitle:(UIImage *)image withTitle:(NSString *)title position:(NSString *)_position font:(UIFont *)_font forState:(UIControlState)stateType;

- (void)setFamillyImageWithTitle:(UIImage *)image withTitle:(NSString *)title position:(NSString *)_position font:(UIFont *)_font forState:(UIControlState)stateType;

- (void)setSellerDetailImageWithTitle:(UIImage *)image withTitle:(NSString *)title position:(NSString *)_position font:(UIFont *)_font forState:(UIControlState)stateType;

- (void)setLootProductImageWithTitle:(UIImage *)image withTitle:(NSString *)title position:(NSString *)_position font:(UIFont *)_font forState:(UIControlState)stateType;

- (void)setBtnWithImgStr:(NSString *)imgStr withTittle:(NSString *)tittle;
@end

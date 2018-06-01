//
//  NSInputPwView.h
//  PayPasswordDemo
//
//  Created by 张锐凌 on 2018/6/1.
//  Copyright © 2018年 高磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NSInputPwViewDelegate <NSObject>

@optional

- (void)payOrder:(NSString *)tradePw;

@end

@interface NSInputPwView : UIView

@property (weak,nonatomic) id<NSInputPwViewDelegate> tbDelegate;

/* 返回 点击回调 */
@property (nonatomic, copy) dispatch_block_t backClickBlock;

/**
 *  @param view 要在哪个视图中显示
 */
- (void)showInView:(UIView *)view;
/**
 *  属性视图的消失
 */
- (void)removeView;
@end

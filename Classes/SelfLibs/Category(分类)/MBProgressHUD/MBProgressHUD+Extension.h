//
//  MBProgressHUD+Extension.h
//  Trade
//
//  Created by FeiFan on 2017/9/5.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extension)


/**
 显示UIActivityIndicatorView,标题和副标题信息;显示到指定view;
 隐藏方法用类方法: hideHUDForView:(UIView *)view animated:(BOOL)animated;
 也可以用实例方法: hide;

 @param text 标题;
 @param detailText 副标题;
 @param view 加载hud的view;
 @return hud;
 */
+ (MB_INSTANCETYPE) mb_showWaitingWithText:(NSString*)text detailText:(NSString*)detailText inView:(UIView*)view;

/**
 只显示文本;
 delay > 0时,时间到达自动hide;
 delay == 0时, 需要手动hide;
 隐藏方法用类方法: hideHUDForView:(UIView *)view animated:(BOOL)animated;
 也可以用实例方法: hide;
 
 @param text 标题;
 @param detail 详情;
 @param view 加载hud的view;
 @param delay 延时;
 @return hud;
 */
+ (MB_INSTANCETYPE) mb_showOnlyText:(NSString*)text detail:(NSString*)detail delay:(NSTimeInterval)delay inView:(UIView*)view;


@end

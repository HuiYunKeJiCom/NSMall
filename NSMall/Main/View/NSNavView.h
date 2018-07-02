//
//  NSNavView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/10.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSNavView : UIView
-(void)setTopTitleWithNSString:(NSString *)string;
/* 左边Item */
@property (strong , nonatomic)UIButton *leftItemButton;
/** 左边Item点击 */
@property (nonatomic, copy) dispatch_block_t leftItemClickBlock;
/* 右边Item */
@property (strong , nonatomic)UIButton *rightItemButton;
/** 右边Item点击 */
@property (nonatomic, copy) dispatch_block_t rightItemClickBlock;
-(void)setRightItemTitle:(NSString *)string;
@end

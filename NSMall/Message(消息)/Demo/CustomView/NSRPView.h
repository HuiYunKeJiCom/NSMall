//
//  NSRPView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSRPView : UIView
- (void)showInView:(UIView *)view;
-(void)setUpDataWith:(NSDictionary *)dict;
/* 红包 点击回调 */
@property (nonatomic, copy) dispatch_block_t openBtnClickBlock;
@end

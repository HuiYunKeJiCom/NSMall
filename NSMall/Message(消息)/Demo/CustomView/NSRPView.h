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
- (void)removeView;
-(void)setUpDataWith:(NSDictionary *)dict;
/* 红包 点击回调 */
@property (nonatomic, copy) dispatch_block_t openBtnClickBlock;
//@property(nonatomic)BOOL hasReceive;/* 已领取 */
@property(nonatomic,strong)UIImageView *bgIV;/* 背景图 */
@property(nonatomic,strong)UIButton *openBtn;/* 开红包按钮 */
@end

//
//  ADPaymentOrderBottonView.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/5.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADPaymentOrderBottonView : UIView
/* 支付 点击回调 */
@property (nonatomic, copy) dispatch_block_t payBtnClickBlock;
/* 按钮标题 */
-(void)setTopTitleWithNSString:(NSString *)string;
@end

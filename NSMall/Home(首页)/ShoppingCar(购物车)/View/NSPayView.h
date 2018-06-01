//
//  NSPayView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/1.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletItemModel.h"

@interface NSPayView : UIView
@property (nonatomic, strong) NSMutableArray<WalletItemModel*> *walletNameArr;
/* 确认 点击回调 */
@property (nonatomic, copy) dispatch_block_t confirmClickBlock;
@property(nonatomic,strong)NSString *payString;/* 付款总金额 */
@property(nonatomic,strong)NSString *walletId;/* 选中的钱包ID */

/**
 *  @param view 要在哪个视图中显示
 */
- (void)showInView:(UIView *)view;
/**
 *  属性视图的消失
 */
- (void)removeView;
@end

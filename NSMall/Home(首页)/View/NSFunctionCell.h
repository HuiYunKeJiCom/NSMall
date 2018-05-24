//
//  NSFunctionCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/15.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"

@interface NSFunctionCell : BaseTableCell
@property (nonatomic, copy) dispatch_block_t classifyBtnClickBlock;/* 分类按钮回调 */
@property (nonatomic, copy) dispatch_block_t shopCartBtnClickBlock;/* 购物车按钮回调 */
@property (nonatomic, copy) dispatch_block_t QRBtnClickBlock;/* 二维码按钮回调 */
@property (nonatomic, copy) dispatch_block_t myOrderBtnClickBlock;/* 我的订单按钮回调 */
@end

//
//  NSWalletTVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "WalletItemModel.h"

@interface NSWalletTVCell : BaseTableCell
@property(nonatomic,strong)WalletItemModel *walletModel;/* 钱包模型 */
///* 查看详情 点击回调 */
//@property (nonatomic, copy) dispatch_block_t defaultClickBlock;
@end

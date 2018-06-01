//
//  NSPayViewTVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/1.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "WalletItemModel.h"

@interface NSPayViewTVCell : BaseTableCell
@property(nonatomic,strong)WalletItemModel *walletModel;/* 钱包模型 */
@property (assign,nonatomic)BOOL isSelected;
@property(nonatomic,strong)UIImageView *seclectIV;/* 选中标记 */
@end

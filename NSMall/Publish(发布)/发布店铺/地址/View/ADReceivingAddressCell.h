//
//  ADReceivingAddressCell.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/9.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import "BaseTableCell.h"
#import "ADAddressModel.h"

@interface ADReceivingAddressCell : BaseTableCell
@property (nonatomic, strong) ADAddressModel  *model;
/* 设为默认 点击回调 */
@property (nonatomic, copy) dispatch_block_t setDefaultBtnClickBlock;
/* 编辑 点击回调 */
@property (nonatomic, copy) dispatch_block_t editBtnClickBlock;
/* 删除 点击回调 */
@property (nonatomic, copy) dispatch_block_t deleteBtnClickBlock;
@end

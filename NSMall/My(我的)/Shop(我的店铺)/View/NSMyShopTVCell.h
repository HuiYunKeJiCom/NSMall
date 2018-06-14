//
//  NSMyShopTVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/18.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "NSShopListItemModel.h"

@interface NSMyShopTVCell : BaseTableCell
@property (nonatomic, strong) NSShopListItemModel  *model;
/* 编辑 点击回调 */
@property (nonatomic, copy) dispatch_block_t editBtnClickBlock;
/* 删除 点击回调 */
@property (nonatomic, copy) dispatch_block_t deleteBtnClickBlock;
@end

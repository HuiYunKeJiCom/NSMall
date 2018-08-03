//
//  NSMyGoodsTVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/17.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "NSMyProductListItemModel.h"

@interface NSMyGoodsTVCell : BaseTableCell
@property (nonatomic, strong) NSMyProductListItemModel  *model;
/* 编辑 点击回调 */
@property (nonatomic, copy) dispatch_block_t editBtnClickBlock;
/* 删除 点击回调 */
@property (nonatomic, copy) dispatch_block_t deleteBtnClickBlock;
@end

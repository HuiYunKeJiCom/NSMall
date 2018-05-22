//
//  NSMyOrderTVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "NSOrderListItemModel.h"

@interface NSMyOrderTVCell : BaseTableCell
@property (nonatomic, strong) NSOrderListItemModel  *model;
@property (nonatomic, copy) dispatch_block_t nextOperationClickBlock;/* 按钮点击回调 */
@end

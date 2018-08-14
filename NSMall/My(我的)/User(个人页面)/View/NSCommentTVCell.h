//
//  NSCommentTVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/14.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "NSCommentItemModel.h"

@interface NSCommentTVCell : BaseTableCell
@property (nonatomic, strong) NSCommentItemModel  *model;
/* 删除 点击回调 */
@property (nonatomic, copy) dispatch_block_t deleteBtnClickBlock;
@end

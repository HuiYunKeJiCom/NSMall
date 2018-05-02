//
//  NSCustomHeadCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/4/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"

@interface NSCustomHeadCell : BaseTableCell
/* 点击头像点击回调 */
@property (nonatomic, copy) dispatch_block_t imageViewBtnClickBlock;
@end

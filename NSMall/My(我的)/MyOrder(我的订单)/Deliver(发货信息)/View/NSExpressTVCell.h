//
//  NSExpressTVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "NSExpressModel.h"

@interface NSExpressTVCell : BaseTableCell

@property(nonatomic,strong)NSExpressModel *expressModel;/* 快递公司模型 */
@property (assign,nonatomic)BOOL isSelected;
@property(nonatomic,strong)UIImageView *seclectIV;/* 选中标记 */

@end

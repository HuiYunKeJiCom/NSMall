//
//  NSODTVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "NSOrderDetailModel.h"

@interface NSODTVCell : BaseTableCell
@property(nonatomic,strong)NSOrderDetailModel *orderDetailModel;/* 订单详情模型 */
@end

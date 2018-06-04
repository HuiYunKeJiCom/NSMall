//
//  NSSortLeftTVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "CategoryModel.h"

@interface NSSortLeftTVCell : BaseTableCell

@property (strong , nonatomic)CategoryModel *model;/* 标题数据 */
@property (nonatomic,assign) BOOL isShow;/* 是否展示View */
@property (strong , nonatomic)UIView *indicatorView;/* 指示View */
//@property (nonatomic,assign) BOOL isSelected;/* 是否被选中 */
@end

//
//  NSCategoryTableViewCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "CategoryModel.h"

@interface NSCategoryTableViewCell : BaseTableCell
@property (strong, nonatomic) UILabel        *titleLb;

@property (strong, nonatomic) CategoryModel *myInfoModel;
@end

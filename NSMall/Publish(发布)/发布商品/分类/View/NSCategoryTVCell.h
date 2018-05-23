//
//  NSCategoryTVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/22.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"

@class ADLMyInfoModel;
@interface NSCategoryTVCell : BaseTableCell
@property (strong, nonatomic) UIImageView    *leftImgView;
@property (strong, nonatomic) UILabel        *titleLb;
@property (strong, nonatomic) UILabel        *numLb;
@property (strong, nonatomic) UIImageView        *numIV;
@property (strong, nonatomic) UIImageView    *arrowImgView;

@property (strong, nonatomic) ADLMyInfoModel *myInfoModel;
@end

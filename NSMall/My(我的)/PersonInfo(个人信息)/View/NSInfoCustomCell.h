//
//  NSInfoCustomCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/4/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"

@class ADLMyInfoModel;
@interface NSInfoCustomCell : BaseTableCell
@property (strong, nonatomic) UIImageView    *leftImgView;
@property (strong, nonatomic) UILabel        *titleLb;
@property (strong, nonatomic) UILabel        *numLb;
@property (strong, nonatomic) UIImageView        *numIV;
@property (strong, nonatomic) UIImageView    *arrowImgView;

@property (strong, nonatomic) ADLMyInfoModel *myInfoModel;
@end

//
//  ADLMyInfoTableViewCell.h
//  Kart
//
//  Created by 朱鹏 on 16/10/24.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADLMyInfoModel;

@interface ADLMyInfoTableViewCell : BaseTableCell

@property (strong, nonatomic) UIImageView    *leftImgView;
@property (strong, nonatomic) UILabel        *titleLb;
@property (strong, nonatomic) UILabel        *numLb;
@property (strong, nonatomic) UIImageView    *arrowImgView;

@property (strong, nonatomic) ADLMyInfoModel *myInfoModel;

@end

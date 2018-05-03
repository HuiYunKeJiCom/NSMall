//
//  ADLFilterSelectItem.h
//  Lock
//
//  Created by occ on 2017/5/22.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLFilterSelectItem : UIControl

@property (nonatomic, strong) UIImageView     *selectImgView;

@property (nonatomic, strong) UILabel         *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame img:(NSString *)imgName title:(NSString *)title;

@end

//
//  ADLFilterSelectItem.m
//  Lock
//
//  Created by occ on 2017/5/22.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ADLFilterSelectItem.h"

@implementation ADLFilterSelectItem

- (instancetype)initWithFrame:(CGRect)frame img:(NSString *)imgName title:(NSString *)title{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.selectImgView];
        [self addSubview:self.titleLabel];
        
        self.selectImgView.image = [UIImage imageNamed:imgName];
        self.titleLabel.text = title;
        
        WEAKSELF
        [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(10);
            make.centerY.mas_equalTo(weakSelf);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.selectImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(weakSelf);
        }];
        
    }
    return self;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _selectImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:KColorText333333];
    }
    return _titleLabel;
}

@end

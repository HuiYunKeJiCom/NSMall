//
//  TDUserCertifyCellPicker.m
//  Trade
//
//  Created by FeiFan on 2017/8/31.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifyCellPicker.h"

@implementation TDUserCertifyCellPicker

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeDatas];
        [self initializeViews];
    }
    return self;
}

- (void) initializeDatas {
    self.backgroundColor = KColorMainBackground;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void) initializeViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.valueLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetScaleWidth(25));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).multipliedBy(0.33);
        make.right.mas_equalTo(-40);
        make.top.bottom.equalTo(self.titleLabel);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = UIBoldFontSize(14);
        _titleLabel.textColor = KColorTextPlaceHolder;
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [UILabel new];
        _valueLabel.font = UIBoldFontSize(14);
        _valueLabel.textColor = KColorTextFFFFFF;
    }
    return _valueLabel;
}


@end

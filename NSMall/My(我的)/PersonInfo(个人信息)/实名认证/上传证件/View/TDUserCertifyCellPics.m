//
//  TDUserCertifyCellPics.m
//  Trade
//
//  Created by FeiFan on 2017/9/8.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifyCellPics.h"

@implementation TDUserCertifyCellPics

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupDatas];
        [self setupViews];
    }
    return self;
}

- (void) setupDatas {
    self.backgroundColor = KColorMainBackground;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) setupViews {
    [self.contentView addSubview:self.loadBtn];
    [self.contentView addSubview:self.demoBtn];
    [self.loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetScaleWidth(16));
        make.top.bottom.mas_equalTo(0);
        make.right.equalTo(self.contentView.mas_centerX).offset(-5);
    }];
    [self.demoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(5);
        make.right.mas_equalTo(GetScaleWidth(-16));
        make.top.bottom.mas_equalTo(0);
    }];
}

- (UIButton *)loadBtn {
    if (!_loadBtn) {
        _loadBtn = [UIButton new];
        _loadBtn.layer.cornerRadius = 6;
        _loadBtn.layer.masksToBounds = YES;
    }
    return _loadBtn;
}

- (UIButton *)demoBtn {
    if (!_demoBtn) {
        _demoBtn = [UIButton new];
    }
    return _demoBtn;
}

@end

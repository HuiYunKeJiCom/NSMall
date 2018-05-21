//
//  TDUserCertifySectionHeader.m
//  Trade
//
//  Created by FeiFan on 2017/9/8.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifySectionHeader.h"




@interface TDUserCertifySectionHeader()
@property (nonatomic, strong) UIImageView* icon;
@end
@implementation TDUserCertifySectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupDatas];
        [self setupViews];
    }
    return self;
}

- (void) setupDatas {
    self.backgroundColor = KColorMainBackground;
}

- (void) setupViews {
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    CGSize tSize = KTextSize(@"请", 20, TDUserCertifySectionHeaderTitleFontSize);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.icon.mas_right).offset(kEdgeInsetTop);
        make.right.mas_equalTo(GetScaleWidth(-16));
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetScaleWidth(16));
        make.centerY.equalTo(self.titleLabel.mas_top).offset(tSize.height * 0.5);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = KMainColor;
        _titleLabel.font = UIBoldFontSize(TDUserCertifySectionHeaderTitleFontSize);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_circle_yellow"]];
        [_icon setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _icon;
}

@end


@interface TDUserCertifySectionHeaderDouble()
@property (nonatomic, strong) UIImageView* icon1;
@property (nonatomic, strong) UIImageView* icon2;
@end
@implementation TDUserCertifySectionHeaderDouble

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupDatas];
        [self setupViews];
    }
    return self;
}

- (void) setupDatas {
    self.backgroundColor = KColorMainBackground;
}

- (void) setupViews {
    [self.contentView addSubview:self.icon1];
    [self.contentView addSubview:self.icon2];
    [self.contentView addSubview:self.titleLabel1];
    [self.contentView addSubview:self.titleLabel2];
    CGSize tSize = KTextSize(@"请", 20, TDUserCertifySectionHeaderTitleFontSize);

    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GetScaleWidth(TDUserCertifySectionHeaderPadding));
        make.left.equalTo(self.icon1.mas_right).offset(kEdgeInsetTop);
        make.right.mas_equalTo(GetScaleWidth(-16));
    }];
    [self.icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetScaleWidth(16));
        make.centerY.equalTo(self.titleLabel1.mas_top).offset(tSize.height * 0.5);
    }];
    
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel1.mas_bottom).offset(GetScaleWidth(TDUserCertifySectionHeaderPadding));
        make.left.equalTo(self.icon2.mas_right).offset(kEdgeInsetTop);
        make.right.mas_equalTo(GetScaleWidth(-16));
    }];
    [self.icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetScaleWidth(16));
        make.centerY.equalTo(self.titleLabel2.mas_top).offset(tSize.height * 0.5);
    }];

}

- (UILabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [UILabel new];
        _titleLabel1.textColor = KMainColor;
        _titleLabel1.font = UIBoldFontSize(TDUserCertifySectionHeaderTitleFontSize);
        _titleLabel1.numberOfLines = 0;
    }
    return _titleLabel1;
}
- (UILabel *)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2 = [UILabel new];
        _titleLabel2.textColor = KMainColor;
        _titleLabel2.font = UIBoldFontSize(TDUserCertifySectionHeaderTitleFontSize);
        _titleLabel2.numberOfLines = 0;
    }
    return _titleLabel2;
}
- (UIImageView *)icon1 {
    if (!_icon1) {
        _icon1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_circle_yellow"]];
        [_icon1 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _icon1;
}
- (UIImageView *)icon2 {
    if (!_icon2) {
        _icon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_circle_yellow"]];
        [_icon2 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _icon2;
}

@end

//
//  TDUserCertifyCellConfirm.m
//  Trade
//
//  Created by FeiFan on 2017/8/31.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifyCellConfirm.h"
#import "UIButton+BtnExt.h"

static NSString* const TDUserCertifyImgNameConfirm = @"user_icon_select";
static NSString* const TDUserCertifyImgNameDisconfirm = @"user_icon_unselect";


@interface TDUserCertifyCellConfirm()
@end

@implementation TDUserCertifyCellConfirm

# pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeDatas];
        [self initializeViews];
    }
    return self;
}


- (void) initializeDatas {
    self.backgroundColor = KColorSubBackground;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.state = TDUserDertifyConfirmStateNone;
    @weakify(self);
    [RACObserve(self, state) subscribeNext:^(id x) {
        @strongify(self);
        if ([x integerValue] == TDUserDertifyConfirmStateNone) {
            [self.agreementBtn setTitleColor:KColorTextPlaceHolder forState:UIControlStateNormal];
            [self.disagreementBtn setTitleColor:KColorTextPlaceHolder forState:UIControlStateNormal];
            [self.agreementBtn setImage:[UIImage imageNamed:TDUserCertifyImgNameDisconfirm] forState:UIControlStateNormal];
            [self.disagreementBtn setImage:[UIImage imageNamed:TDUserCertifyImgNameDisconfirm] forState:UIControlStateNormal];
        }
        else if ([x integerValue] == TDUserDertifyConfirmStateYes) {
            [self.agreementBtn setTitleColor:KColorTextContent forState:UIControlStateNormal];
            [self.disagreementBtn setTitleColor:KColorTextPlaceHolder forState:UIControlStateNormal];
            [self.agreementBtn setImage:[UIImage imageNamed:TDUserCertifyImgNameConfirm] forState:UIControlStateNormal];
            [self.disagreementBtn setImage:[UIImage imageNamed:TDUserCertifyImgNameDisconfirm] forState:UIControlStateNormal];
        }
        else {
            [self.agreementBtn setTitleColor:KColorTextPlaceHolder forState:UIControlStateNormal];
            [self.disagreementBtn setTitleColor:KColorTextContent forState:UIControlStateNormal];
            [self.agreementBtn setImage:[UIImage imageNamed:TDUserCertifyImgNameDisconfirm] forState:UIControlStateNormal];
            [self.disagreementBtn setImage:[UIImage imageNamed:TDUserCertifyImgNameConfirm] forState:UIControlStateNormal];
        }
    }];

}

- (void) initializeViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.agreementBtn];
    [self.contentView addSubview:self.disagreementBtn];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-14);
        make.left.mas_equalTo(20);
        make.right.equalTo(self.contentView.mas_centerX);

    }];
    [self.disagreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreementBtn.mas_centerY);
        make.right.mas_equalTo(-20);
        make.left.equalTo(self.contentView.mas_centerX);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.agreementBtn.mas_top).offset(- 10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
    }];
}

# pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = KColorTextContent;
        _titleLabel.font = UISystemFontSize(14);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = KColorTextContent;
        _contentLabel.font = UISystemFontSize(13);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UIButton *)agreementBtn {
    if (!_agreementBtn) {
        _agreementBtn = [[UIButton alloc] initWithFrame:CGRectZero title:KLocalizableStr(@"本人同意") img:TDUserCertifyImgNameDisconfirm fontSize:14];
        [_agreementBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_agreementBtn setTitleColor:KColorText333333 forState:UIControlStateHighlighted];
    }
    return _agreementBtn;
}

- (UIButton *)disagreementBtn {
    if (!_disagreementBtn) {
        _disagreementBtn = [[UIButton alloc] initWithFrame:CGRectZero title:KLocalizableStr(@"本人不同意") img:TDUserCertifyImgNameDisconfirm fontSize:14];
        [_disagreementBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_disagreementBtn setTitleColor:KColorText333333 forState:UIControlStateHighlighted];
    }
    return _disagreementBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = KColorTextPlaceHolder;
    }
    return _lineView;
}

@end

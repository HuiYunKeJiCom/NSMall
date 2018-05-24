//
//  ADOrderPublicViewCell.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/1.
//  Copyright © 2018年 Adel. All rights reserved.
//  下单页面-评价商品||发票||优惠券 共用

#import "ADOrderPublicViewCell.h"

@interface ADOrderPublicViewCell ()
@property (nonatomic, strong) UIView  *bgView;
/* 主题 */
@property (strong , nonatomic)UILabel *timeLabel;
/* 按钮标题 */
@property (strong , nonatomic)UILabel *buttonTitLabel;
/* 右侧箭头 */
@property (strong , nonatomic)UIButton *quickButton;
@end

@implementation ADOrderPublicViewCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.buttonTitLabel];
    [self.bgView addSubview:self.quickButton];
    self.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self makeConstraints];
}

#pragma mark - Constraints
- (void)makeConstraints {
    WEAKSELF
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(10);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
    }];
    
    [self.quickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-20);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.buttonTitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.quickButton.mas_left);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
    }];
    
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _timeLabel;
}

- (UIButton *)quickButton {
    if (!_quickButton) {
        _quickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _quickButton.titleLabel.font = [UIFont systemFontOfSize:kFontNum12];
        //        _detailBtn.backgroundColor = k_UIColorFromRGB(0xffffff);
        [_quickButton setTitleColor:KColorText878686 forState:UIControlStateNormal];
        [_quickButton addTarget:self action:@selector(quickButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_quickButton setImage:[UIImage imageNamed:@"ico_home_back_black"] forState:UIControlStateNormal];
    }
    return _quickButton;
}

#pragma mark - 详情 点击
- (void)quickButtonClick {
    NSLog(@"详情 点击");
    !_quickBtnClickBlock ? : _quickBtnClickBlock();
}

- (UILabel *)buttonTitLabel {
    if (!_buttonTitLabel) {
        _buttonTitLabel = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _buttonTitLabel;
}

-(void)setTopTitleWithNSString:(NSString *)string{
    self.timeLabel.text = string;
}

-(void)setButtonTitleWithNSString:(NSString *)string{
    self.buttonTitLabel.text = string;
}

#pragma mark - Setter Getter Methods


@end

//
//  ADPaymentSuccessContentView.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/14.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import "ADPaymentSuccessContentView.h"

@interface ADPaymentSuccessContentView()
/** 标题1  */
@property(nonatomic,strong)UILabel *title1Lab;
/** 提示语1  */
@property(nonatomic,strong)UILabel *tip1Lab;

@end

@implementation ADPaymentSuccessContentView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        [self setUpData];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.title1Lab];
    [self addSubview:self.tip1Lab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeConstraints];
}

#pragma mark - 填充数据
-(void)setUpData{
    self.title1Lab.text = @"订单支付成功!";
    self.tip1Lab.text = @"我们将尽快为您发货";
}

#pragma mark - Constraints
- (void)makeConstraints {
    WEAKSELF
    
    [self.title1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.mas_top).with.offset(60);
    }];
    
    [self.tip1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.mas_top).with.offset(kScreenHeight*0.75+10);
    }];
}

- (UILabel *)title1Lab {
    if (!_title1Lab) {
        _title1Lab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum16 TextColor:[UIColor blackColor]];
    }
    return _title1Lab;
}

- (UILabel *)tip1Lab {
    if (!_tip1Lab) {
        _tip1Lab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor blackColor]];
    }
    return _tip1Lab;
}

@end

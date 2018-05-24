//
//  ADPaymentOrderBottonView.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/5.
//  Copyright © 2018年 Adel. All rights reserved.
//  支付订单-底部页面

#import "ADPaymentOrderBottonView.h"

@interface ADPaymentOrderBottonView()
/* 支付 按钮 */
@property (strong , nonatomic)UIButton *payButton;
@end

@implementation ADPaymentOrderBottonView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
//        [self setUpData];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.payButton];
    
}

//#pragma mark - 填充数据
//-(void)setUpData{
//    [self.payButton setTitle:@"支付" forState:UIControlStateNormal];
//}

-(void)setTopTitleWithNSString:(NSString *)string{
    [self.payButton setTitle:string forState:UIControlStateNormal];
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

    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(50);
    }];
    
}

- (UIButton *)payButton {
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:kFontNum14];
        _payButton.backgroundColor = [UIColor redColor];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

#pragma mark - 支付 点击
- (void)payButtonClick {
//    NSLog(@"支付 点击");
    !_payBtnClickBlock ? : _payBtnClickBlock();
}


@end

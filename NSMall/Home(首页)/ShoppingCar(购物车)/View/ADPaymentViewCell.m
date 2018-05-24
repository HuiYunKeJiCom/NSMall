//
//  ADPaymentViewCell.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/5.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import "ADPaymentViewCell.h"

@interface ADPaymentViewCell()
@property (nonatomic, strong) UIView  *bgView;
/** 横线 */
@property(nonatomic,strong)UIView *lineView;
/** 图标 */
@property(nonatomic,strong)UIImageView *iconIV;
/** 支付方式 */
@property(nonatomic,strong)UILabel *paymentLab;
@end

@implementation ADPaymentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.lineView];
        [self.bgView addSubview:self.iconIV];
        [self.bgView addSubview:self.paymentLab];
        [self makeConstraints];
    }
    
    return self;
}

-(void)setUpPaymentWith:(NSString *)string{
    self.paymentLab.text = string;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
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
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left);
        make.top.equalTo(weakSelf.bgView.mas_top);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(1);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(20);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.paymentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconIV.mas_right).with.offset(5);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
//        _bgView.backgroundColor = [UIColor blueColor];
    }
    return _bgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

-(UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc] init];
        //        [_goodsIV setImage:[UIImage imageNamed:@"icon"]];
        [_iconIV setBackgroundColor:[UIColor greenColor]];
        [_iconIV setContentMode:UIViewContentModeScaleAspectFill];
        //        [_goodsIV setClipsToBounds:YES];
    }
    return _iconIV;
}

- (UILabel *)paymentLab {
    if (!_paymentLab) {
        _paymentLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:[UIColor blackColor]];
    }
    return _paymentLab;
}

@end

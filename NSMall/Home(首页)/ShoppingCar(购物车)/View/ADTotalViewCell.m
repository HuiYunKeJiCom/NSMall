//
//  ADTotalViewCell.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/1.
//  Copyright © 2018年 Adel. All rights reserved.
//  统计总数

#import "ADTotalViewCell.h"

@interface ADTotalViewCell()
@property (nonatomic, strong) UIView  *bgView;
/** 商品标题 */
@property(nonatomic,strong)UILabel *totalGoodsLab;
/** 商品数量 */
@property(nonatomic,strong)UILabel *goodsNumLab;
/** 商品单位 */
@property(nonatomic,strong)UILabel *goodsUnitLab;
/** 金额标题 */
@property(nonatomic,strong)UILabel *totalMoneyLab;
/** 金额数量 */
@property(nonatomic,strong)UILabel *moneyNumLab;
/** 金额单位 */
@property(nonatomic,strong)UILabel *moneyUnitLab;
/** 优惠券标题 */
@property(nonatomic,strong)UILabel *totalCouponLab;
/** 优惠券数量 */
@property(nonatomic,strong)UILabel *couponNumLab;
/** 优惠券单位 */
@property(nonatomic,strong)UILabel *couponUnitLab;
/** 运费标题 */
@property(nonatomic,strong)UILabel *totalFreightLab;
/** 运费数量 */
@property(nonatomic,strong)UILabel *freightNumLab;
/** 运费单位 */
@property(nonatomic,strong)UILabel *freightUnitLab;

@end

@implementation ADTotalViewCell

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
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.totalGoodsLab];
    [self.bgView addSubview:self.goodsNumLab];
    [self.bgView addSubview:self.goodsUnitLab];
    [self.bgView addSubview:self.totalMoneyLab];
    [self.bgView addSubview:self.moneyNumLab];
    [self.bgView addSubview:self.moneyUnitLab];
    [self.bgView addSubview:self.totalCouponLab];
    [self.bgView addSubview:self.couponNumLab];
    [self.bgView addSubview:self.couponUnitLab];
    [self.bgView addSubview:self.totalFreightLab];
    [self.bgView addSubview:self.freightNumLab];
    [self.bgView addSubview:self.freightUnitLab];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeConstraints];
}

#pragma mark - 填充数据
-(void)setUpData{
    self.totalGoodsLab.text = @"商品件数：";
    self.goodsUnitLab.text = @"件";
    self.totalMoneyLab.text = @"金额合计：";
    self.moneyUnitLab.text = @"元";
    self.totalCouponLab.text = @"优惠券抵扣：";
    self.couponNumLab.text = @"-0";
    self.couponUnitLab.text = @"元";
    self.totalFreightLab.text = @"运费：";
    self.freightUnitLab.text = @"元";
}

-(void)setUpDataWithNSDictionary:(NSDictionary *)dict{
    
    self.moneyNumLab.text = [NSString stringWithFormat:@"%.2f",[[dict valueForKey:@"totalPrice"] floatValue]];
    self.goodsNumLab.text = [NSString stringWithFormat:@"%ld",[[dict valueForKey:@"goodsNumber"] integerValue]];
    self.freightNumLab.text = [NSString stringWithFormat:@"%.0f",[[dict valueForKey:@"expressFee"] doubleValue]];
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
    
    [self.totalGoodsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(10);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(10);
    }];
    
    [self.goodsNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.totalGoodsLab.mas_right);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(10);
    }];
    
    [self.goodsUnitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodsNumLab.mas_right);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(10);
    }];
    
    [self.totalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(10);
        make.top.equalTo(weakSelf.totalGoodsLab.mas_bottom).with.offset(5);
    }];
    
    [self.moneyNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.totalMoneyLab.mas_right);
        make.top.equalTo(weakSelf.totalGoodsLab.mas_bottom).with.offset(5);
    }];
    
    [self.moneyUnitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.moneyNumLab.mas_right);
        make.top.equalTo(weakSelf.totalGoodsLab.mas_bottom).with.offset(5);
    }];
    
    [self.totalCouponLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(10);
        make.top.equalTo(weakSelf.totalMoneyLab.mas_bottom).with.offset(5);
    }];
    
    [self.couponNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.totalCouponLab.mas_right);
        make.top.equalTo(weakSelf.totalMoneyLab.mas_bottom).with.offset(5);
    }];
    
    [self.couponUnitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.couponNumLab.mas_right);
        make.top.equalTo(weakSelf.totalMoneyLab.mas_bottom).with.offset(5);
    }];
    
    [self.totalFreightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(10);
        make.top.equalTo(weakSelf.totalCouponLab.mas_bottom).with.offset(5);
    }];
    
    [self.freightNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.totalFreightLab.mas_right);
        make.top.equalTo(weakSelf.totalCouponLab.mas_bottom).with.offset(5);
    }];
    
    [self.freightUnitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.freightNumLab.mas_right);
        make.top.equalTo(weakSelf.totalCouponLab.mas_bottom).with.offset(5);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

- (UILabel *)totalGoodsLab {
    if (!_totalGoodsLab) {
        _totalGoodsLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _totalGoodsLab;
}

- (UILabel *)goodsNumLab {
    if (!_goodsNumLab) {
        _goodsNumLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _goodsNumLab;
}

- (UILabel *)goodsUnitLab {
    if (!_goodsUnitLab) {
        _goodsUnitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _goodsUnitLab;
}

- (UILabel *)totalMoneyLab {
    if (!_totalMoneyLab) {
        _totalMoneyLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _totalMoneyLab;
}

- (UILabel *)moneyNumLab {
    if (!_moneyNumLab) {
        _moneyNumLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _moneyNumLab;
}

- (UILabel *)moneyUnitLab {
    if (!_moneyUnitLab) {
        _moneyUnitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _moneyUnitLab;
}

- (UILabel *)totalCouponLab {
    if (!_totalCouponLab) {
        _totalCouponLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _totalCouponLab;
}

- (UILabel *)couponNumLab {
    if (!_couponNumLab) {
        _couponNumLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _couponNumLab;
}

- (UILabel *)couponUnitLab {
    if (!_couponUnitLab) {
        _couponUnitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _couponUnitLab;
}

- (UILabel *)totalFreightLab {
    if (!_totalFreightLab) {
        _totalFreightLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _totalFreightLab;
}

- (UILabel *)freightNumLab {
    if (!_freightNumLab) {
        _freightNumLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _freightNumLab;
}

- (UILabel *)freightUnitLab {
    if (!_freightUnitLab) {
        _freightUnitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _freightUnitLab;
}



@end

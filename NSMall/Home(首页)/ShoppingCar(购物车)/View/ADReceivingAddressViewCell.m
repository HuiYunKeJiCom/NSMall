//
//  ADReceivingAddressViewCell.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/1.
//  Copyright © 2018年 Adel. All rights reserved.
//  下单页面-收货地址

#import "ADReceivingAddressViewCell.h"
#import "ADAddressModel.h"

@interface ADReceivingAddressViewCell()
@property (nonatomic, strong) UIView  *bgView;
/** 地址 */
@property(nonatomic,strong)UILabel *addressLab;
/** 默认 */
@property(nonatomic,strong)UILabel *defaultLab;
/** 家 */
@property(nonatomic,strong)UILabel *homeLab;
/** 收货人 */
@property(nonatomic,strong)UILabel *receiverLab;
/** 收 */
@property(nonatomic,strong)UILabel *acceptLab;
/** 竖线1 */
@property(nonatomic,strong)UIView *lineView1;
/** 电话 */
@property(nonatomic,strong)UILabel *phoneLab;
/** 竖线2 */
@property(nonatomic,strong)UIView *lineView2;
/** 邮编标题 */
@property(nonatomic,strong)UILabel *zipCodeTitLab;
/** 邮编 */
@property(nonatomic,strong)UILabel *zipCodeLab;
/** 收货地址详情 */
@property(nonatomic,strong)UIButton *detailBtn;

@end

@implementation ADReceivingAddressViewCell

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
    [self.bgView addSubview:self.addressLab];
    [self.bgView addSubview:self.defaultLab];
    [self.bgView addSubview:self.homeLab];
    [self.bgView addSubview:self.receiverLab];
    [self.bgView addSubview:self.acceptLab];
    [self.bgView addSubview:self.lineView1];
    [self.bgView addSubview:self.phoneLab];
    [self.bgView addSubview:self.lineView2];
    [self.bgView addSubview:self.zipCodeTitLab];
    [self.bgView addSubview:self.zipCodeLab];
    [self.bgView addSubview:self.detailBtn];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeConstraints];
}

#pragma mark - 填充数据
-(void)setUpData{
    
    self.defaultLab.text = @" 默认 ";
    self.acceptLab.text = @"收";
    self.zipCodeTitLab.text = @"邮编：";
    
//    [self.detailBtn setTitle:@">" forState:UIControlStateNormal];
}

-(void)setAddressModel:(ADAddressModel *)addressModel{
    _addressModel = addressModel;
    
    NSString *areaName;
    NSRange range = [addressModel.area_name rangeOfString:@","];
    if (range.location!=NSNotFound) {
        areaName = [addressModel.area_name stringByReplacingOccurrencesOfString:@"," withString:@" "];
        
    }else{
        areaName = addressModel.area_name;
    }
    
    self.addressLab.text = [NSString stringWithFormat:@"%@%@",areaName,addressModel.detail_address];
    self.homeLab.text = addressModel.label;
    self.receiverLab.text = addressModel.trueName;
    self.phoneLab.text = addressModel.mobile;
    self.zipCodeLab.text = addressModel.post_code;
    
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
    
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(10);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(10);
        make.width.mas_equalTo(GetScaleWidth(200));
    }];
    
    [self.defaultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressLab.mas_right).with.offset(5);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(10);
    }];
    
    [self.homeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.defaultLab.mas_right).with.offset(5);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(10);
    }];
    
    [self.receiverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(10);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(-10);
    }];
    
    [self.acceptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.receiverLab.mas_right).with.offset(5);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(-10);
    }];

    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.acceptLab.mas_right).with.offset(5);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(-13);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(10);
    }];
    
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lineView1.mas_right).with.offset(5);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(-10);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.phoneLab.mas_right).with.offset(5);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(-13);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(10);
    }];
    
    [self.zipCodeTitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lineView2.mas_right).with.offset(5);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(-10);
    }];
    
    [self.zipCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.zipCodeTitLab.mas_right);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(-10);
    }];
    
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-20);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

- (UILabel *)addressLab {
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _addressLab;
}

- (UILabel *)defaultLab {
    if (!_defaultLab) {
        _defaultLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor whiteColor]];
        _defaultLab.backgroundColor = [UIColor redColor];
        _defaultLab.layer.cornerRadius = 3.0;
        _defaultLab.layer.masksToBounds = YES;
    }
    return _defaultLab;
}

- (UILabel *)homeLab {
    if (!_homeLab) {
        _homeLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor whiteColor]];
        _homeLab.backgroundColor = [UIColor yellowColor];
        _homeLab.layer.cornerRadius = 3.0;
        _homeLab.layer.masksToBounds = YES;
    }
    return _homeLab;
}

- (UILabel *)receiverLab {
    if (!_receiverLab) {
        _receiverLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _receiverLab;
}

- (UILabel *)acceptLab {
    if (!_acceptLab) {
        _acceptLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _acceptLab;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView1.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView1;
}

- (UILabel *)phoneLab {
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _phoneLab;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView2.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView2;
}

- (UILabel *)zipCodeTitLab {
    if (!_zipCodeTitLab) {
        _zipCodeTitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _zipCodeTitLab;
}

- (UILabel *)zipCodeLab {
    if (!_zipCodeLab) {
        _zipCodeLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _zipCodeLab;
}

- (UIButton *)detailBtn {
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailBtn.titleLabel.font = [UIFont systemFontOfSize:kFontNum12];
//        _detailBtn.backgroundColor = k_UIColorFromRGB(0xffffff);
        [_detailBtn setTitleColor:KColorText878686 forState:UIControlStateNormal];
        [_detailBtn addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_detailBtn setImage:[UIImage imageNamed:@"ico_home_back_black"] forState:UIControlStateNormal];
    }
    return _detailBtn;
}

#pragma mark - 收货地址详情 点击
- (void)detailButtonClick {
    NSLog(@"收货地址详情 点击");
    !_detailBtnClickBlock ? : _detailBtnClickBlock();
}

@end

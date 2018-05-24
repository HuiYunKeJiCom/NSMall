//
//  ADPaymentOrderView.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/5.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import "ADPaymentOrderView.h"
#import "ADBuildOrderModel.h"

@interface ADPaymentOrderView()
/** 标题1  */
@property(nonatomic,strong)UILabel *title1Lab;
/** 标题2  */
@property(nonatomic,strong)UILabel *title2Lab;
/** 提示语1  */
@property(nonatomic,strong)UILabel *tip1Lab;
/** 提示语2 */
@property(nonatomic,strong)UILabel *tip2Lab;
/** 收件信息标题 */
@property(nonatomic,strong)UILabel *receivingInfoTitLab;
/** 收件人 */
@property(nonatomic,strong)UILabel *addresseeLab;
/** 电话 */
@property(nonatomic,strong)UILabel *phoneLab;
/** 收件地址 */
@property(nonatomic,strong)UILabel *receiveAddressLab;
/** 付款标题 */
@property(nonatomic,strong)UILabel *paymentTitLab;
/** 金额 */
@property(nonatomic,strong)UILabel *paymentLab;
/** 单位 */
@property(nonatomic,strong)UILabel *unitLab;
@end

@implementation ADPaymentOrderView

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
    [self addSubview:self.title2Lab];
    [self addSubview:self.tip1Lab];
    [self addSubview:self.tip2Lab];
    [self addSubview:self.receivingInfoTitLab];
    [self addSubview:self.addresseeLab];
    [self addSubview:self.phoneLab];
    [self addSubview:self.receiveAddressLab];
    [self addSubview:self.paymentTitLab];
    [self addSubview:self.paymentLab];
    [self addSubview:self.unitLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeConstraints];
}

#pragma mark - 填充数据
-(void)setBuildOrderModel:(ADBuildOrderModel *)buildOrderModel{
    _buildOrderModel = buildOrderModel;
    self.addresseeLab.text = buildOrderModel.trueName;
    self.phoneLab.text = buildOrderModel.mobile;
    
    NSString *areaName;
    NSRange range = [buildOrderModel.area_name rangeOfString:@","];
    if (range.location!=NSNotFound) {
//        areaName = [buildOrderModel.area_name stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSArray *tempArr = [buildOrderModel.area_name componentsSeparatedByString:@","];
        areaName = [tempArr lastObject];
    }else{
        areaName = buildOrderModel.area_name;
    }
    
    self.receiveAddressLab.text = [NSString stringWithFormat:@"%@%@",areaName,buildOrderModel.detail_address];
    
//    self.receiveAddressLab.text = @"宝安区松柏路南岗第二工业区";
    self.paymentLab.text = buildOrderModel.payPrice;
}

-(void)setUpData{
    self.title1Lab.text = @"订单提交成功!";
    self.title2Lab.text = @"去付款咯~";
    self.tip1Lab.text = @"我们将尽快为您发货";
    self.tip2Lab.text = @"请在24小时0分内完成交付，超时后将取消订单";
    self.receivingInfoTitLab.text = @"收货信息：";
    self.paymentTitLab.text = @"应付金额：";
    self.unitLab.text = @"元";
}

#pragma mark - Constraints
- (void)makeConstraints {
    WEAKSELF
    
    [self.title1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.mas_top).with.offset(60);
    }];
    
    [self.title2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.title1Lab.mas_bottom).with.offset(10);
    }];
    
    [self.paymentTitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_centerX);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-10);
    }];
    
    [self.paymentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.paymentTitLab.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-10);
    }];
    
    [self.unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.paymentLab.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-10);
    }];
    
    [self.receivingInfoTitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(30);
        make.bottom.equalTo(weakSelf.paymentTitLab.mas_top).with.offset(-10);
    }];
    
    [self.addresseeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.receivingInfoTitLab.mas_right);
        make.bottom.equalTo(weakSelf.paymentTitLab.mas_top).with.offset(-10);
    }];
    
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addresseeLab.mas_right).with.offset(5);
        make.bottom.equalTo(weakSelf.paymentTitLab.mas_top).with.offset(-10);
    }];
    
    [self.receiveAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.phoneLab.mas_right).with.offset(5);
        make.bottom.equalTo(weakSelf.paymentTitLab.mas_top).with.offset(-10);
    }];
    
    [self.tip2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.bottom.equalTo(weakSelf.receivingInfoTitLab.mas_top).with.offset(-10);
    }];
    
    [self.tip1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.bottom.equalTo(weakSelf.tip2Lab.mas_top).with.offset(-10);
    }];
}

- (UILabel *)title1Lab {
    if (!_title1Lab) {
        _title1Lab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum16 TextColor:[UIColor blackColor]];
    }
    return _title1Lab;
}

- (UILabel *)title2Lab {
    if (!_title2Lab) {
        _title2Lab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum16 TextColor:[UIColor blackColor]];
    }
    return _title2Lab;
}

- (UILabel *)tip1Lab {
    if (!_tip1Lab) {
        _tip1Lab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor blackColor]];
    }
    return _tip1Lab;
}

- (UILabel *)tip2Lab {
    if (!_tip2Lab) {
        _tip2Lab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor blackColor]];
    }
    return _tip2Lab;
}

- (UILabel *)receivingInfoTitLab {
    if (!_receivingInfoTitLab) {
        _receivingInfoTitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor blackColor]];
    }
    return _receivingInfoTitLab;
}

- (UILabel *)addresseeLab {
    if (!_addresseeLab) {
        _addresseeLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor blackColor]];
    }
    return _addresseeLab;
}

- (UILabel *)phoneLab {
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor blackColor]];
    }
    return _phoneLab;
}

- (UILabel *)receiveAddressLab {
    if (!_receiveAddressLab) {
        _receiveAddressLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor blackColor]];
    }
    return _receiveAddressLab;
}

- (UILabel *)paymentTitLab {
    if (!_paymentTitLab) {
        _paymentTitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor blackColor]];
    }
    return _paymentTitLab;
}

- (UILabel *)paymentLab {
    if (!_paymentLab) {
        _paymentLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum16 TextColor:[UIColor redColor]];
    }
    return _paymentLab;
}

- (UILabel *)unitLab {
    if (!_unitLab) {
        _unitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor blackColor]];
    }
    return _unitLab;
}


@end

//
//  NSODAddressTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSODAddressTVCell.h"

@interface NSODAddressTVCell()
@property (nonatomic, strong) UIView  *bgView;
@property(nonatomic,strong)UILabel *receiverLab;/* 收货人 */
@property(nonatomic,strong)UILabel *phoneLab;/* 电话 */
@property(nonatomic,strong)UILabel *addressLab;/* 收货地址 */
@end

@implementation NSODAddressTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI{
//    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.bgView.x = 0;
//    self.bgView.y = 0;
    [self addSubview:self.bgView];
    
//    self.receiverLab = [[UILabel alloc]init];
//    self.receiverLab.x = 19;
//    self.receiverLab.y = 15;
//    self.receiverLab.font = UISystemFontSize(14);
//    self.receiverLab.textColor = kBlackColor;
    [self.bgView addSubview:self.receiverLab];
    
//    self.phoneLab = [[UILabel alloc]init];
//    self.phoneLab.font = UISystemFontSize(14);
//    self.phoneLab.textColor = kBlackColor;
    [self.bgView addSubview:self.phoneLab];
    
//    self.addressLab = [[UILabel alloc]init];
//    self.addressLab.font = UISystemFontSize(14);
//    self.addressLab.textColor = kBlackColor;
    [self.bgView addSubview:self.addressLab];
}

-(void)setOrderDetailModel:(NSOrderDetailModel *)orderDetailModel{
    _orderDetailModel = orderDetailModel;
    
    self.receiverLab.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"receiver", nil),orderDetailModel.recipient_name];
//    [self.receiverLab sizeToFit];
    
//    self.phoneLab.x = CGRectGetMaxX(self.receiverLab.frame)+24;
//    self.phoneLab.y = 15;
    self.phoneLab.text = orderDetailModel.recipient_phone;
//    [self.phoneLab sizeToFit];
    
//    self.addressLab.x = 19;
//    self.addressLab.y = CGRectGetMaxY(self.receiverLab.frame)+13;
    self.addressLab.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"receiving address", nil),orderDetailModel.recipient_address];
//    [self.addressLab sizeToFit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeConstraints];
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(65)));
    }];
    
    [self.receiverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(GetScaleWidth(19));
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(GetScaleWidth(6));
    }];
    
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.receiverLab.mas_right).with.offset(GetScaleWidth(24));
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(GetScaleWidth(6));
    }];
    
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(GetScaleWidth(19));
        make.top.equalTo(weakSelf.receiverLab.mas_bottom).with.offset(GetScaleWidth(13));
    }];
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectZero];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

- (UILabel *)receiverLab {
    if (!_receiverLab) {
        _receiverLab = [[UILabel alloc]init];
        _receiverLab.font = UISystemFontSize(14);
        _receiverLab.textColor = kBlackColor;
    }
    return _receiverLab;
}

- (UILabel *)phoneLab {
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc]init];
        _phoneLab.font = UISystemFontSize(14);
        _phoneLab.textColor = kBlackColor;
    }
    return _phoneLab;
}

- (UILabel *)addressLab {
    if (!_addressLab) {
        _addressLab = [[UILabel alloc]init];
        _addressLab.font = UISystemFontSize(14);
        _addressLab.textColor = kBlackColor;
    }
    return _addressLab;
}


@end

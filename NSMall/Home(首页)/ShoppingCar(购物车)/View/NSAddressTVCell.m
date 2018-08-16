//
//  NSAddressTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/30.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSAddressTVCell.h"

@interface NSAddressTVCell()
@property (nonatomic, strong) UIView  *bgView;
@property(nonatomic,strong)UILabel *receiverLab;/* 收货人 */
@property(nonatomic,strong)UILabel *phoneLab;/* 电话 */
@property(nonatomic,strong)UILabel *addressLab;/* 收货地址 */
@end

@implementation NSAddressTVCell

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
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.receiverLab];
    [self.bgView addSubview:self.phoneLab];
    [self.bgView addSubview:self.addressLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeConstraints];
}

-(void)setAddressModel:(NSAddressItemModel *)addressModel{
    _addressModel = addressModel;
    
    self.receiverLab.text = [NSString stringWithFormat:@"收货人:%@",addressModel.user_name];
    self.phoneLab.text = addressModel.user_phone;
    
    self.addressLab.text = [NSString stringWithFormat:@"收货地址:%@%@%@%@%@",addressModel.province_name,addressModel.city_name,addressModel.district_name,addressModel.street_name,addressModel.user_address];
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

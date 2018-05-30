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
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.x = 0;
    self.bgView.y = 0;
    [self addSubview:self.bgView];
    
    self.receiverLab = [[UILabel alloc]init];
    self.receiverLab.x = 19;
    self.receiverLab.y = 15;
    self.receiverLab.font = UISystemFontSize(14);
    self.receiverLab.textColor = kBlackColor;
    [self.bgView addSubview:self.receiverLab];
    
    self.phoneLab = [[UILabel alloc]init];
    self.phoneLab.font = UISystemFontSize(14);
    self.phoneLab.textColor = kBlackColor;
    [self.bgView addSubview:self.phoneLab];
    
    self.addressLab = [[UILabel alloc]init];
    self.addressLab.font = UISystemFontSize(14);
    self.addressLab.textColor = kBlackColor;
    [self.bgView addSubview:self.addressLab];
}

-(void)setAddressModel:(NSAddressItemModel *)addressModel{
    _addressModel = addressModel;
    
    self.receiverLab.text = [NSString stringWithFormat:@"收货人:%@",addressModel.user_name];
    [self.receiverLab sizeToFit];
    
    self.phoneLab.x = CGRectGetMaxX(self.receiverLab.frame)+24;
    self.phoneLab.y = 15;
    self.phoneLab.text = addressModel.user_phone;
    [self.phoneLab sizeToFit];
    
    self.addressLab.x = 19;
    self.addressLab.y = CGRectGetMaxY(self.receiverLab.frame)+13;
    self.addressLab.text = [NSString stringWithFormat:@"收货地址:%@%@%@%@%@",addressModel.province_name,addressModel.city_name,addressModel.district_name,addressModel.street_name,addressModel.user_address];
    [self.addressLab sizeToFit];
}

@end

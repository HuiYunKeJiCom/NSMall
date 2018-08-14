//
//  ADReceivingAddressCell.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/9.
//  Copyright © 2018年 Adel. All rights reserved.
//  收货地址Cell

#import "ADReceivingAddressCell.h"


@interface ADReceivingAddressCell()
/* 上半部分 */
@property (nonatomic, strong) UIView           *upView;
/** 收货人 */
@property(nonatomic,strong)UILabel *receiverLab;
/** 电话 */
@property(nonatomic,strong)UILabel *phoneLab;
/** 地址 */
@property(nonatomic,strong)UILabel *addressLab;
/** 家 标签 */
@property(nonatomic,strong)UILabel *homeLab;

/* 下半部分 */
@property (nonatomic, strong) UIView           *downView;
/** 设为默认 按钮 */
@property(nonatomic,strong)UIButton *setDefaultBtn;
/** 编辑 按钮 */
@property(nonatomic,strong)UIButton *editBtn;
/** 删除 按钮 */
@property(nonatomic,strong)UIButton *deleteBtn;
@end

@implementation ADReceivingAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        [self addSubview:self.upView];
        [self.upView addSubview:self.receiverLab];
        [self.upView addSubview:self.phoneLab];
        [self.upView addSubview:self.addressLab];
        [self.upView addSubview:self.homeLab];
        
        [self addSubview:self.downView];
        [self.downView addSubview:self.setDefaultBtn];
        [self.downView addSubview:self.editBtn];
        [self.downView addSubview:self.deleteBtn];
        
        [self makeConstraints];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame {
//    frame.origin.y += 10;
    [super setFrame:frame];
    
}

- (void)setModel:(NSAddressItemModel *)model {
    _model = model;
    self.receiverLab.text = model.user_name;
    self.phoneLab.text = model.user_phone;
    self.addressLab.text = [NSString stringWithFormat:@"%@%@%@ %@%@",model.province_name,model.city_name,model.district_name,model.street_name,model.user_address];
    
    if(model.is_default == 1){
        [self.setDefaultBtn setTitle:@"默认地址" forState:UIControlStateNormal];
        self.setDefaultBtn.userInteractionEnabled = NO;
        [self.setDefaultBtn.layer setMasksToBounds:NO];
        [self.setDefaultBtn.layer setBorderWidth:0];
        [self.setDefaultBtn setTitleColor:KMainColor forState:UIControlStateNormal];
    }else{
        [self.setDefaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
        self.setDefaultBtn.userInteractionEnabled = YES;
        [_setDefaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_setDefaultBtn.layer setBorderColor:[UIColor blackColor].CGColor];
        [_setDefaultBtn.layer setBorderWidth:1];
        [_setDefaultBtn.layer setMasksToBounds:YES];
        _setDefaultBtn.layer.cornerRadius = 3.0;
    }
    
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    
    if([model.user_tag isEqualToString:@"家"]){
        _homeLab.backgroundColor = [UIColor brownColor];
//        self.homeLab.text = @" 家 ";
    }else{
//        self.homeLab.text = @" 公司 ";
    }
    self.homeLab.text = model.user_tag;
    
    CGSize labelSize = [DCSpeedy dc_calculateTextSizeWithText:model.user_tag WithTextFont:kFontNum12 WithMaxW:80];
    self.homeLab.frame = CGRectMake(kScreenWidth-40-labelSize.width, 20, labelSize.width+10, labelSize.height);
    
}


#pragma mark - Constraints
- (void)makeConstraints {
    
    WEAKSELF
    [self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf);
        make.height.mas_equalTo(80);
    }];
    
    [self.receiverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.upView.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.upView.mas_top).with.offset(20);
    }];
    
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.receiverLab.mas_right).with.offset(5);
        make.top.equalTo(weakSelf.upView.mas_top).with.offset(20);
    }];
    
//    [self.homeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.upView.mas_right).with.offset(-30);
//        make.top.equalTo(weakSelf.upView.mas_top).with.offset(20);
//        make.height.mas_equalTo(20);
//    }];
    
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.upView.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.receiverLab.mas_bottom).with.offset(5);
    }];
    
    [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(30);
    }];
    
    [self.setDefaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.downView.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.downView.mas_top).with.offset(5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.downView.mas_right).with.offset(-10);
        make.top.equalTo(weakSelf.downView.mas_top).with.offset(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.deleteBtn.mas_left);
        make.top.equalTo(weakSelf.downView.mas_top).with.offset(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
}

- (UIView *)upView {
    if (!_upView) {
        _upView = [[UIView alloc] initWithFrame:CGRectZero];
        _upView.backgroundColor = [UIColor whiteColor];
    }
    return _upView;
}

- (UILabel *)receiverLab {
    if (!_receiverLab) {
        _receiverLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _receiverLab;
}

- (UILabel *)phoneLab {
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _phoneLab;
}

- (UILabel *)addressLab {
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _addressLab;
}

- (UILabel *)homeLab {
    if (!_homeLab) {
        _homeLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor whiteColor]];
        _homeLab.textAlignment = NSTextAlignmentCenter;
        _homeLab.backgroundColor = KMainColor;
        _homeLab.layer.cornerRadius = 5.0;
        _homeLab.layer.masksToBounds = YES;
    }
    return _homeLab;
}

- (UIView *)downView {
    if (!_downView) {
        _downView = [[UIView alloc] initWithFrame:CGRectZero];
        _downView.backgroundColor = [UIColor lightTextColor];
    }
    return _downView;
}

- (UIButton *)setDefaultBtn {
    if (!_setDefaultBtn) {
        _setDefaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _setDefaultBtn.titleLabel.font = [UIFont systemFontOfSize:kFontNum12];
        [_setDefaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_setDefaultBtn addTarget:self action:@selector(setDefaultButtonClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _setDefaultBtn;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:kFontNum12];
        [_editBtn setTitleColor:KColorText878686 forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:kFontNum12];
        [_deleteBtn setTitleColor:KColorText878686 forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _deleteBtn;
}

#pragma mark - 设为默认 点击
- (void)setDefaultButtonClick {
//    [self setDefaultAddressWithID:self.model.address_id];
    !_setDefaultBtnClickBlock ? : _setDefaultBtnClickBlock();
}

#pragma mark - 编辑 点击
- (void)editButtonClick {
//    NSLog(@"编辑 点击");
    !_editBtnClickBlock ? : _editBtnClickBlock();
}

#pragma mark - 删除 点击
- (void)deleteButtonClick {
    NSLog(@"删除 点击");
    !_deleteBtnClickBlock ? : _deleteBtnClickBlock();
}



@end

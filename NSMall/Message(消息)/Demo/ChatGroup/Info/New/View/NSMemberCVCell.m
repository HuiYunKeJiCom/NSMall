//
//  NSMemberCVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMemberCVCell.h"

@interface NSMemberCVCell()

@property(nonatomic,strong)UIView *bgView;/* 背景图 */

@end

@implementation NSMemberCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI{
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.avatarIV];
    [self.bgView addSubview:self.nickLab];
    [self.bgView addSubview:self.delBtn];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self makeConstraints];
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [self.avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left);
       make.right.equalTo(weakSelf.bgView.mas_right); make.top.equalTo(weakSelf.avatarIV.mas_bottom).with.offset(2);
        
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.bgView.mas_left);
//        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(-2);
        make.centerX.equalTo(weakSelf.avatarIV.mas_left);
        make.centerY.equalTo(weakSelf.avatarIV.mas_top);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        
    }];
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectZero];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

-(UIImageView *)avatarIV{
    if (!_avatarIV) {
        _avatarIV = [[UIImageView alloc] init];
        [_avatarIV setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _avatarIV;
}

-(UILabel *)nickLab{
    if (!_nickLab) {
        _nickLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:kGreyColor];
        _nickLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nickLab;
}

-(UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
//        _delBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, -15);
        [_delBtn setImage:kGetImage(@"appitem_del_btn_normal") forState:UIControlStateNormal];
        [_delBtn setImage:kGetImage(@"appitem_del_btn_pressed") forState:UIControlStateHighlighted];
        [_delBtn addTarget:self action:@selector(delButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _delBtn.alpha = 0.6;
    }
    return _delBtn;
}

-(void)setModel:(NSHuanXinUserModel *)model{
    _model = model;
    
    [self.avatarIV sd_setImageWithURL:[NSURL URLWithString:model.user_avatar]];
    self.nickLab.text = model.nick_name;
}

#pragma mark - 删除 点击
- (void)delButtonClick {
    //    NSLog(@"删除 点击");
    !_delBtnClickBlock ? : _delBtnClickBlock();
}

@end

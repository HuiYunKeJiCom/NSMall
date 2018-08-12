//
//  NSRedpacketTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSRedpacketTVCell.h"

@interface NSRedpacketTVCell()
@property(nonatomic,strong)UIView *bgView;/* 背景 */
@property(nonatomic,strong)UILabel *nickLab;/* 昵称 */
@property(nonatomic,strong)UILabel *timeLab;/* 时间 */
@property(nonatomic,strong)UILabel *amountLab;/* 金额 */

@end

@implementation NSRedpacketTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kWhiteColor;
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.nickLab];
    [self.bgView addSubview:self.timeLab];
    [self.bgView addSubview:self.amountLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeConstraints];
}

- (void)makeConstraints {
    WEAKSELF
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(10);
    }];
    
    [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-20);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.nickLab.mas_bottom).with.offset(10);
    }];
    
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _bgView;
}

- (UILabel *)nickLab {
    if (!_nickLab) {
        _nickLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:14 TextColor:[UIColor blackColor]];
    }
    return _nickLab;
}

- (UILabel *)amountLab {
    if (!_amountLab) {
        _amountLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:14 TextColor:[UIColor blackColor]];
    }
    return _amountLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:12 TextColor:[UIColor grayColor]];
    }
    return _timeLab;
}

-(void)setModel:(NSRPItemModel *)model{
    _model = model;
    
    self.nickLab.text = model.receive_user_name;
    self.amountLab.text = [NSString stringWithFormat:@"%.2fN",model.receive_amount];
    self.timeLab.text = model.receive_time;
}

@end

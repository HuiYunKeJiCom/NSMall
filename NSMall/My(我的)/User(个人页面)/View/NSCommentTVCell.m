//
//  NSCommentTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/14.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCommentTVCell.h"

@interface NSCommentTVCell()
@property (nonatomic, strong) UIView           *bgView;
@property(nonatomic,strong)UIImageView *avatarView;/* 头像 */
@property(nonatomic,strong)UILabel *nickLab;/* 昵称 */
@property(nonatomic,strong)UIImageView *levelIV;/* VIP等级 */
@property(nonatomic,strong)UILabel *levelLab;/* vip数字 */
@property(nonatomic,strong)UILabel *content;/* 评论内容 */
@property(nonatomic,strong)UILabel *timeLab;/* 评论日期 */
@property(nonatomic,strong)UIButton *delBtn;/* 删除 */

@end

@implementation NSCommentTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = KBGCOLOR;
        [self buildUI];
        [self makeConstraints];
    }
    
    return self;
}

-(void)buildUI{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.avatarView];
    [self.bgView addSubview:self.nickLab];
    [self.bgView addSubview:self.levelIV];
    [self.bgView addSubview:self.levelIV];
    [self.bgView addSubview:self.content];
    [self.bgView addSubview:self.timeLab];
    [self.bgView addSubview:self.delBtn];
}

-(void)setFrame:(CGRect)frame {
    //    frame.origin.y += 15;
    [super setFrame:frame];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setModel:(NSCommentItemModel *)model {
    _model = model;
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.user_avatar]];
    self.nickLab.text = model.user_name;
    self.content.text = model.content;
    self.timeLab.text = model.create_time;
    
    if(model.level != 0){
        self.levelLab.alpha = 1.0;
        self.levelIV.alpha = 1.0;
        self.levelLab.text = [NSString stringWithFormat:@"%ld",model.level];
    }else{
        self.levelLab.alpha = 0.0;
        self.levelIV.alpha = 0.0;
    }

    
}

-(void)makeConstraints {
    WEAKSELF

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.avatarView.mas_right).with.offset(10);
        make.centerY.equalTo(weakSelf.avatarView.mas_centerY);
    }];
    
    [self.levelIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nickLab.mas_right).with.offset(GetScaleWidth(5));
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(GetScaleWidth(12));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(30), GetScaleWidth(30)));
    }];
    
    [self.levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.levelIV.mas_centerX);
        make.centerY.equalTo(weakSelf.levelIV.mas_centerY).with.offset(-GetScaleWidth(4));
    }];

    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nickLab.mas_left);
        make.top.equalTo(weakSelf.avatarView.mas_bottom).with.offset(5);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nickLab.mas_left);
        make.top.equalTo(weakSelf.content.mas_bottom).with.offset(10);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).with.offset(-20);
        make.bottom.equalTo(self.timeLab.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(53),GetScaleWidth(23)));
    }];
    
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

-(UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        //        [_avatarView setBackgroundColor:[UIColor greenColor]];
        [_avatarView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _avatarView;
}

- (UILabel *)nickLab {
    if (!_nickLab) {
        _nickLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _nickLab;
}

-(UIImageView *)levelIV{
    if (!_levelIV) {
        _levelIV = [[UIImageView alloc] init];
        _levelIV.image = IMAGE(@"ico_level");
        [_levelIV setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _levelIV;
}

- (UILabel *)levelLab {
    if (!_levelLab) {
        _levelLab = [[UILabel alloc] init];
        _levelLab.font = [UIFont boldSystemFontOfSize:14];
        _levelLab.textColor = [UIColor whiteColor];
    }
    return _levelLab;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _content;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:[UIColor grayColor]];
    }
    return _timeLab;
}

-(UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.titleLabel.font = [UIFont systemFontOfSize:kFontNum14];
        // 设置圆角的大小
        _delBtn.layer.cornerRadius = 5;
        [_delBtn.layer setMasksToBounds:YES];
        _delBtn.layer.borderWidth = 1;
        _delBtn.layer.borderColor = [kRedColor CGColor];
        [_delBtn setTitleColor:kRedColor forState:UIControlStateNormal];
        [_delBtn setTitle:NSLocalizedString(@"delete", nil) forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}

#pragma mark - 删除 点击
- (void)deleteButtonClick {
    NSLog(@"删除 点击");
    !_deleteBtnClickBlock ? : _deleteBtnClickBlock();
}

@end

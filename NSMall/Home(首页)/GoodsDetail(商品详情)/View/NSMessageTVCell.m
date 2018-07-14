//
//  NSMessageTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMessageTVCell.h"

@interface NSMessageTVCell ()
@property (nonatomic, strong) UIView  *bgView;
@property (strong, nonatomic) UIView *bottomLineView;
@property(nonatomic,strong)UIButton *delBtn;/* 删除按钮 */
@end

@implementation NSMessageTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        [self makeConstraints];
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    //    frame.origin.y += 10;
    [super setFrame:frame];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - getter


- (UIImageView *)userIV {
    
    if (!_userIV) {
        _userIV = [[UIImageView alloc] initWithImage:IMAGE(@"draw_right_icon")];
//        _userIV.backgroundColor =kRedColor;
    }
    
    return _userIV;
}

- (UILabel *)userNameLb {
    
    if (!_userNameLb) {
        _userNameLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:kBlackColor];
    }
    
    return _userNameLb;
    
}

-(UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:kGreyColor];
    }
    return _timeLb;
}

- (UILabel *)contentLb {
    
    if (!_contentLb) {
        _contentLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:kBlackColor];
        _contentLb.textAlignment = NSTextAlignmentLeft;
    }
    
    return _contentLb;
    
}

- (UIView *)bottomLineView {
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = KColorTextf4f4f4;
    }
    
    return _bottomLineView;
}

-(UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [[UIButton alloc]init];
        [_delBtn setTitleColor:kRedColor forState:0];
        _delBtn.titleLabel.font = UISystemFontSize(13);
        [_delBtn addTarget:self action:@selector(delButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}

#pragma mark - setter

- (void)setMessageModel:(NSMessageModel *)messageModel {
    _messageModel = messageModel;
    
    [self.userIV sd_setImageWithURL:[NSURL URLWithString:messageModel.imagePath]];
    self.userNameLb.text = messageModel.userName;
    self.contentLb.text = messageModel.content;
    self.timeLb.text = messageModel.time;
    
    [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
    _delBtn.layer.cornerRadius = 5.0;//2.0是圆角的弧度，根据需求自己更改
    _delBtn.layer.borderColor = kRedColor.CGColor;//设置边框颜色
    _delBtn.layer.borderWidth = 1.0f;//设置边框宽度
}

#pragma mark - private methord

- (void)initViews{
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.backgroundColor = kWhiteColor;
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.userIV];
    [self.bgView addSubview:self.userNameLb];
    [self.bgView addSubview:self.contentLb];
    [self.bgView addSubview:self.timeLb];
    [self.bgView addSubview:self.delBtn];
    [self.bgView addSubview:self.bottomLineView];
}

- (void)makeConstraints {
    
    WEAKSELF
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [self.userIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).with.offset(GetScaleWidth(18));
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(GetScaleWidth(7));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(33), GetScaleWidth(33)));
    }];
    
    [self.userNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userIV.mas_right).with.offset(GetScaleWidth(6));
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(GetScaleWidth(18));
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userIV.mas_right).with.offset(GetScaleWidth(6));
        make.top.equalTo(weakSelf.userNameLb.mas_bottom).with.offset(GetScaleWidth(11));
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userIV.mas_right).with.offset(GetScaleWidth(6));
        make.top.equalTo(weakSelf.contentLb.mas_bottom).with.offset(GetScaleWidth(10));
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-GetScaleWidth(19));
        make.bottom.equalTo(weakSelf.timeLb.mas_bottom);
         make.size.mas_equalTo(CGSizeMake(GetScaleWidth(40), GetScaleWidth(20)));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)delButtonClick {
    !_delBtnClickBlock ? : _delBtnClickBlock();
}

@end

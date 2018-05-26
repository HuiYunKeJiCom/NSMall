//
//  NSMessageTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMessageTVCell.h"

@interface NSMessageTVCell ()

@property (strong, nonatomic) UIView *bottomLineView;

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
        _userIV.backgroundColor =kRedColor;
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
        _timeLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:[UIColor lightGrayColor]];
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

#pragma mark - setter

- (void)setMessageModel:(NSMessageModel *)messageModel {
    _messageModel = messageModel;
    
    self.userNameLb.text = messageModel.userName;
    self.contentLb.text = messageModel.content;
    self.timeLb.text = messageModel.time;
}

#pragma mark - private methord

- (void)initViews{
    
    [self.contentView addSubview:self.userIV];
    [self.contentView addSubview:self.userNameLb];
    [self.contentView addSubview:self.contentLb];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.bottomLineView];
}

- (void)makeConstraints {
    
    WEAKSELF
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
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
}

@end

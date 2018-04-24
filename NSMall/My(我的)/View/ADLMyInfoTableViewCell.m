//
//  ADLMyInfoTableViewCell.m
//  EasyLife
//
//  Created by 朱鹏 on 16/10/24.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import "ADLMyInfoTableViewCell.h"
#import "ADLMyInfoModel.h"

@interface ADLMyInfoTableViewCell ()

@property (strong, nonatomic) UIView *bottomLineView;

@end

@implementation ADLMyInfoTableViewCell

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


- (UIImageView *)leftImgView {
    
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] initWithImage:IMAGE(@"draw_right_icon")];
    }
    
    return _leftImgView;
}

- (UILabel *)titleLb {
    
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum15 TextColor:KColorText323232];
    }
    
    return _titleLb;
    
}

- (UILabel *)numLb {
    
    if (!_numLb) {
        _numLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:KColorText878686];
        _numLb.textAlignment = NSTextAlignmentRight;
    }
    
    return _numLb;
    
}

- (UIView *)bottomLineView {
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = KColorTextf4f4f4;
    }
    
    return _bottomLineView;
}

- (UIImageView *)arrowImgView {
    
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:IMAGE(@"ico_home_back_black")];
    }
    
    return _arrowImgView;
}

#pragma mark - setter

- (void)setMyInfoModel:(ADLMyInfoModel *)myInfoModel {
    
    if (!IsEmpty(myInfoModel.imageName)) {
        self.leftImgView.image = IMAGE(myInfoModel.imageName);
    }
    
    if (!IsEmpty(myInfoModel.title)) {
        self.titleLb.text = myInfoModel.title;
    }
    
    if (!IsEmpty(myInfoModel.num)) {
        self.numLb.text = myInfoModel.num;
    }
    
    //    self.numLb.text = [NSString stringWithFormat:@"(%@)",IsEmpty(myInfoModel.num)?@"0":myInfoModel.num];
    
}

#pragma mark - private methord

- (void)initViews{
    
    [self.contentView addSubview:self.leftImgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.numLb];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.bottomLineView];
    
}

- (void)makeConstraints {
    
    WEAKSELF
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).with.offset(15);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(75*0.5, 75*0.5));
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImgView.mas_right).with.offset(10);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(-15);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(40*0.5, 40*0.5));
    }];
    
    [self.numLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.arrowImgView.mas_left).with.offset(-10);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
    }];
    
}



@end

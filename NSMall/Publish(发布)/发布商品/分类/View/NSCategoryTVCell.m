//
//  NSCategoryTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/22.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCategoryTVCell.h"
#import "ADLMyInfoModel.h"

@interface NSCategoryTVCell()
@property (strong, nonatomic) UIView *bottomLineView;
@end

@implementation NSCategoryTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = KBGCOLOR;
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
        _numLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum15 TextColor:KColorText878686];
        _numLb.textAlignment = NSTextAlignmentRight;
    }
    
    return _numLb;
    
}

- (UIImageView *)numIV {
    
    if (!_numIV) {
        _numIV = [[UIImageView alloc] initWithImage:IMAGE(@"draw_right_icon")];
        //        _numIV.backgroundColor = [UIColor redColor];
    }
    
    return _numIV;
}

- (UIView *)bottomLineView {
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = KBGCOLOR;
    }
    
    return _bottomLineView;
}

- (UIImageView *)arrowImgView {
    
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:IMAGE(@"my_ico_right_arrow")];
    }
    
    return _arrowImgView;
}

#pragma mark - setter

- (void)setMyInfoModel:(ADLMyInfoModel *)myInfoModel {
    
    if (!IsEmpty(myInfoModel.imageName)) {
        self.leftImgView.image = IMAGE(myInfoModel.imageName);
        self.titleLb.frame = CGRectMake(GetScaleWidth(18)+GetScaleWidth(25), GetScaleWidth(19), kScreenWidth*0.5, GetScaleWidth(14));
    }else{
        [self.leftImgView removeFromSuperview];
        self.titleLb.frame = CGRectMake(GetScaleWidth(29), GetScaleWidth(15), kScreenWidth*0.5, GetScaleWidth(12));
    }
    
    if (!IsEmpty(myInfoModel.title)) {
        self.titleLb.text = myInfoModel.title;
        [self.titleLb sizeToFit];
    }
    
    if (!IsEmpty(myInfoModel.num)) {
        if([myInfoModel.num hasSuffix:@".png"]){
            self.numIV.alpha = 1.0;
            self.numIV.image = IMAGE(myInfoModel.num);
        }else{
            self.numLb.alpha = 1.0;
            self.numLb.text = myInfoModel.num;
        }
    }
    
    //    self.numLb.text = [NSString stringWithFormat:@"(%@)",IsEmpty(myInfoModel.num)?@"0":myInfoModel.num];
    
}

#pragma mark - private methord

- (void)initViews{
    
    [self.contentView addSubview:self.leftImgView];
    [self.contentView addSubview:self.titleLb];
    self.numLb.alpha = 0.0;
    [self.contentView addSubview:self.numLb];
    self.numIV.alpha = 0.0;
    [self.contentView addSubview:self.numIV];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.bottomLineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)makeConstraints {
    
    WEAKSELF
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).with.offset(GetScaleWidth(19));
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(20), GetScaleWidth(20)));
    }];
    
    //    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
    //    make.left.equalTo(weakSelf.contentView).with.offset(GetScaleWidth(29));
    //        make.centerY.equalTo(weakSelf.contentView);
    //    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(-GetScaleWidth(19));
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(5), GetScaleWidth(9)));
    }];
    
    [self.numLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.arrowImgView.mas_left).with.offset(-GetScaleWidth(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.numIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.arrowImgView.mas_left).with.offset(-GetScaleWidth(15));
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(72), GetScaleWidth(72)));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
    }];
    
}
@end

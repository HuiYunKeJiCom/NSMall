//
//  NSCategoryTableViewCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCategoryTableViewCell.h"

@interface NSCategoryTableViewCell ()

@property (strong, nonatomic) UIView *bottomLineView;

@end

@implementation NSCategoryTableViewCell

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

- (UILabel *)titleLb {
    
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum15 TextColor:KColorText323232];
    }
    
    return _titleLb;
    
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
        _arrowImgView = [[UIImageView alloc] initWithImage:IMAGE(@"my_ico_right_arrow")];
    }
    
    return _arrowImgView;
}

#pragma mark - setter

- (void)setMyInfoModel:(CategoryModel *)myInfoModel {
    _myInfoModel = myInfoModel;
    if (!IsEmpty(myInfoModel.name)) {
        self.titleLb.text = myInfoModel.name;
    }
    
    if(myInfoModel.children.count == 0){
        self.arrowImgView.alpha = 0.0;
    }else{
        self.arrowImgView.alpha = 1.0;
    }
}

#pragma mark - private methord

- (void)initViews{
    
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.bottomLineView];
}

- (void)makeConstraints {
    
    WEAKSELF
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(GetScaleWidth(29));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(-GetScaleWidth(27));
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(16*0.5, 28*0.5));
    }];
  
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
    }];
    
}


@end

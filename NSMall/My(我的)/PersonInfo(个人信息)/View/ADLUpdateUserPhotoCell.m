//
//  ADLUpdateUserPhotoCell.m
//  Lock
//
//  Created by occ on 2017/5/22.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ADLUpdateUserPhotoCell.h"

@implementation ADLUpdateUserPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initViews];
        [self makeConstraints];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initViews];
    [self makeConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - getter


- (UILabel *)titleLb {
    
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum15 TextColor:KColorText333333];
    }
    
    return _titleLb;
    
}



- (FFSpearteLineView *)lineView {
    if (!_lineView) {
        _lineView = [[FFSpearteLineView alloc] initWithFrame:CGRectZero];
    }
    return _lineView;
}

- (UIImageView *)photoImgView {
    
    if (!_photoImgView) {
        _photoImgView = [[UIImageView alloc] initWithImage:IMAGE(@"my_ico_head")];
//        _photoImgView.layer.cornerRadius = 59 / 2.0;
//        _photoImgView.layer.masksToBounds = YES;
    }
    
    return _photoImgView;
}


#pragma mark - private methord

- (void)initViews{
    
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.photoImgView];
    [self.contentView addSubview:self.lineView];
}

- (void)makeConstraints {
    
    WEAKSELF
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(GetScaleWidth(19));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(GetScaleWidth(-39));
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}


@end

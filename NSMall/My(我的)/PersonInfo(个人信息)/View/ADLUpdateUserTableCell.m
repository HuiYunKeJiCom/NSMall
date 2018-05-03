//
//  ADLUpdateUserTableCell.m
//  Lock
//
//  Created by occ on 2017/5/22.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ADLUpdateUserTableCell.h"

@implementation ADLUpdateUserTableCell

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
    // Initialization code
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


- (UILabel *)descLabel {
    
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum15 TextColor:KColorText999999];
    }
    
    return _descLabel;
    
}


- (FFSpearteLineView *)lineView {
    if (!_lineView) {
        _lineView = [[FFSpearteLineView alloc] initWithFrame:CGRectZero];
    }
    return _lineView;
}

- (UIImageView *)arrowImgView {
    
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:IMAGE(@"my_ico_right_arrow")];
    }
    
    return _arrowImgView;
}


#pragma mark - private methord

- (void)initViews{
    
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.lineView];
    
}

- (void)makeConstraints {
    
    WEAKSELF
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(GetScaleWidth(16));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(GetScaleWidth(-16));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.arrowImgView.mas_left).with.offset(GetScaleWidth(-7));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).with.offset(GetScaleWidth(16));
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}


@end

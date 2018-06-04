//
//  NSSortLeftTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSSortLeftTVCell.h"

@interface NSSortLeftTVCell()
/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;

@end

@implementation NSSortLeftTVCell

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.isShow = NO;
//        self.isSelected = NO;
        [self setUpUI];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = PFR15Font;
    [self addSubview:_titleLabel];
    
    _indicatorView = [[UIView alloc] init];
    _indicatorView.hidden = NO;
    _indicatorView.backgroundColor = KMainColor;
    [self addSubview:_indicatorView];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    WEAKSELF
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(GetScaleWidth(18));
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(GetScaleWidth(19));
    }];
    
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(4);
    }];
}

#pragma mark - cell点击
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _indicatorView.hidden = NO;
        _titleLabel.textColor = KMainColor;
        self.backgroundColor = [UIColor whiteColor];
    }else{
        _indicatorView.hidden = YES;
        _titleLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
    }
}

//-(void)setIsSelected:(BOOL)isSelected{
//    NSLog(@"设置被选中");
//    _isSelected = isSelected;
//    if (isSelected) {
//        _indicatorView.hidden = NO;
//        _titleLabel.textColor = KMainColor;
//        self.backgroundColor = [UIColor whiteColor];
//    }else{
//        _indicatorView.hidden = YES;
//        _titleLabel.textColor = [UIColor blackColor];
//        self.backgroundColor = [UIColor clearColor];
//    }
//}
#pragma mark - Setter Getter Methods
- (void)setModel:(CategoryModel *)model
{
    _model = model;
    self.titleLabel.text = model.name;
}

@end

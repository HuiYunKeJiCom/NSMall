//
//  NSShopViewTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/15.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSShopViewTVCell.h"

@interface NSShopViewTVCell()
@property (nonatomic, strong) UIView  *bgView;
@property (strong, nonatomic) UIView *topLineView;
@property(nonatomic,strong)UIImageView *shopIV;/* 店铺图片 */
@property(nonatomic,strong)UILabel *shopNameL;/* 店铺名称 */
@property(nonatomic,strong)UILabel *shopDescrL;/* 店铺描述 */
@property(nonatomic,strong)UILabel *distanceLabel;/* 距离 */

@end

@implementation NSShopViewTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.bgView];
        [self addSubview:self.topLineView];
        [self addSubview:self.shopIV];
        [self addSubview:self.shopNameL];
        [self addSubview:self.shopDescrL];
        [self addSubview:self.distanceLabel];
 
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame {
    //    frame.origin.y += 10;
    [super setFrame:frame];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self makeConstraints];
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    WEAKSELF
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(1);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.7, 1));
    }];
    
    [self.shopIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(GetScaleWidth(5));
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(GetScaleWidth(10));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(60), GetScaleWidth(60)));
    }];
    
    [self.shopNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.shopIV.mas_right).with.offset(GetScaleWidth(10));
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(GetScaleWidth(20));
    }];
    
    [self.shopDescrL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.shopIV.mas_right).with.offset(GetScaleWidth(10));
        make.top.equalTo(weakSelf.shopNameL.mas_bottom).with.offset(GetScaleWidth(5));
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-GetScaleWidth(10));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
    }];
}

-(void)setStoreModel:(NSStoreModel *)storeModel{
    _storeModel = storeModel;
    
    [self.shopIV sd_setImageWithURL:[NSURL URLWithString:storeModel.storeImageList[0]]];
    self.shopNameL.text = storeModel.name;
    self.distanceLabel.text = [NSString stringWithFormat:@"距离%@",self.storeModel.distance];
    for (LabelItemModel *tag in storeModel.labelList) {
        
        self.shopDescrL.text = [[self.shopDescrL.text stringByAppendingString:tag.label_name] stringByAppendingString:@"、"];
    }
    NSString *tagString = [self removeLastOneChar:self.shopDescrL.text];
    self.shopDescrL.text = tagString;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLineView.backgroundColor = KBGCOLOR;
    }
    return _topLineView;
}

-(UIImageView *)shopIV{
    if (!_shopIV) {
        _shopIV = [[UIImageView alloc] init];
        [_shopIV setBackgroundColor:[UIColor greenColor]];
        [_shopIV setContentMode:UIViewContentModeScaleAspectFill];
        //        [_goodsIV setClipsToBounds:YES];
    }
    return _shopIV;
}

- (UILabel *)shopNameL {
    if (!_shopNameL) {
        _shopNameL = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum15 TextColor:[UIColor blackColor]];
        _shopNameL.textAlignment = NSTextAlignmentLeft;
    }
    return _shopNameL;
}

- (UILabel *)shopDescrL {
    if (!_shopDescrL) {
        _shopDescrL = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:KBGCOLOR];
        _shopDescrL.textAlignment = NSTextAlignmentLeft;
    }
    return _shopDescrL;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:kGreyColor];
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _distanceLabel;
}


-(NSString*) removeLastOneChar:(NSString*)origin
{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];// 去掉最后一个","
    }else{
        cutted = origin;
    }
    return cutted;
}

@end

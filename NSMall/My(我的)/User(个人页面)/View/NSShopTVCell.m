//
//  NSShopTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/14.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSShopTVCell.h"
@interface NSShopTVCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView           *bgView;
@property(nonatomic,strong)UILabel *shopName;/* 店铺名称 */
@property(nonatomic,strong)UILabel *timeLab;/* 时间 */
@property(nonatomic,strong)UIScrollView *imageSV;/* 图片滚动 */
@property(nonatomic,strong)UILabel *detailLab;/* 描述 */

@end

@implementation NSShopTVCell

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
    [self.bgView addSubview:self.shopName];
    [self.bgView addSubview:self.timeLab];
    [self.bgView addSubview:self.imageSV];
    [self.bgView addSubview:self.detailLab];
}

-(void)setFrame:(CGRect)frame {
    //    frame.origin.y += 15;
    [super setFrame:frame];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];

}

- (void)setModel:(NSShopListItemModel *)model {
    _model = model;
    
    self.shopName.text = model.name;
    self.timeLab.text = model.update_time;
    self.detailLab.text = model.introduce;
    
    float itemWidth = (kScreenWidth-GetScaleWidth(40)-GetScaleWidth(20))/3.0;
    self.imageSV.contentSize = CGSizeMake((itemWidth+GetScaleWidth(10))*model.storeImageList.count, 0);
    for(int i=0;i<model.storeImageList.count;i++){
        UIImageView *goodsIV = [[UIImageView alloc]initWithFrame:CGRectMake((itemWidth+GetScaleWidth(10))*i+GetScaleWidth(20), 0, itemWidth, itemWidth)];
        [goodsIV sd_setImageWithURL:[NSURL URLWithString:model.storeImageList[i]]];
        [self.imageSV addSubview:goodsIV];
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
    
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(GetScaleWidth(20));
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(GetScaleWidth(10));
    }];

    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(GetScaleWidth(20));
        make.top.equalTo(weakSelf.shopName.mas_bottom).with.offset(5);
    }];
    
    [self.imageSV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left);
    make.top.equalTo(weakSelf.timeLab.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, (kScreenWidth-GetScaleWidth(40)-GetScaleWidth(20))/3.0));
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(GetScaleWidth(20));
        make.top.equalTo(weakSelf.imageSV.mas_bottom).with.offset(GetScaleWidth(10));
    }];
  
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

- (UILabel *)shopName {
    if (!_shopName) {
        _shopName = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:[UIColor blackColor]];
//        _shopName.textAlignment = NSTextAlignmentLeft;
    }
    return _shopName;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor grayColor]];
    }
    return _timeLab;
}

- (UIScrollView *)imageSV {
    if (!_imageSV) {
        _imageSV = [[UIScrollView alloc]initWithFrame:CGRectZero];
        //        _SV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //        _imageViewScrollView.backgroundColor = [UIColor redColor];
        _imageSV.showsVerticalScrollIndicator = NO;
        _imageSV.showsHorizontalScrollIndicator = NO;
        _imageSV.delegate = self;
        //        _SV.directionalLockEnabled = YES;
        //        _SV.pagingEnabled = YES;
    }
    return _imageSV;
}

- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _detailLab;
}

@end

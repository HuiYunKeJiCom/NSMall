//
//  NSGoodsView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGoodsView.h"

@interface NSGoodsView()
@property(nonatomic,strong)UIImageView *goodsIV;/* 商品图片 */
@property(nonatomic,strong)UILabel *detailLab;/* 商品描述 */
@property(nonatomic,strong)UIView *lineView2;/* 分割线2 */
@end

@implementation NSGoodsView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI
{
    self.goodsIV = [[UIImageView alloc] init];
    [self.goodsIV setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.goodsIV];
    
    self.detailLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    [self addSubview:self.detailLab];
    
    self.lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
    self.lineView2.backgroundColor = KBGCOLOR;
    [self addSubview:self.lineView2];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)setModel:(NSOrderProductItemModel *)model{
    _model = model;
    self.goodsIV.x = 18;
    self.goodsIV.y = 10;
    self.goodsIV.size = CGSizeMake(53, 53);
    [self.goodsIV sd_setImageWithURL:[NSURL URLWithString:model.product_imge]];
    self.detailLab.x =  CGRectGetMaxX(self.goodsIV.frame)+12;
    self.detailLab.text = model.introduce;
    CGSize detailSize = [self contentSizeWithTitle:model.introduce andFont:14];
    [self.detailLab sizeToFit];
    self.detailLab.y = self.goodsIV.centerY-detailSize.height*0.5;
    self.lineView2.x = 0;
    self.lineView2.y = CGRectGetMaxY(self.goodsIV.frame)+6;
    self.lineView2.size = CGSizeMake(kScreenWidth, 1);
    
}

#pragma mark - 消失
- (void)dealloc
{
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

@end

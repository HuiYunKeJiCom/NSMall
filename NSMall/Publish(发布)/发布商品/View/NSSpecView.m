//
//  NSSpecView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSSpecView.h"

@interface NSSpecView()
@property(nonatomic,strong)UIView *bgView;/* 背景 */
@property(nonatomic,strong)UILabel *specLabel;/* 规格标题 */
@property(nonatomic,strong)UITextField *specTF;/* 规格 */
@property(nonatomic,strong)UIView *specLineV;/* 分割线 */
@property(nonatomic,strong)UILabel *priceLabel;/* 价格标题 */
@property(nonatomic,strong)UITextField *priceTF;/* 价格 */
@property(nonatomic,strong)UIView *priceLineV;/* 分割线 */
@property(nonatomic,strong)UILabel *inventoryLabel;/*  库存标题 */
@property(nonatomic,strong)UITextField *inventoryTF;/*  库存 */
@property(nonatomic,strong)UIButton *delButton;/*  删除按钮 */
@end

@implementation NSSpecView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
//        [self setUpData];
    }
    
    return self;
}

-(void)initViews{
    self.bgView = [[UIView alloc] init];
    self.bgView.x = 0;
    self.bgView.y = 0;
    self.bgView.size = CGSizeMake(kScreenWidth-30, GetScaleWidth(43)*3+10);
    self.bgView.backgroundColor = KMainColor;
    [self addSubview:self.bgView];
    
    self.specLabel = [[UILabel alloc] init];
    self.specLabel.text = @"规格";
    self.specLabel.x = 29;
    self.specLabel.y = 15;
    [self.specLabel sizeToFit];
    [self.bgView addSubview:self.specLabel];
    
    self.specLineV = [[UIView alloc] init];
    self.specLineV.x = 0;
    self.specLineV.y = CGRectGetMaxY(self.specLabel.frame)+15;
    [self.bgView addSubview:self.specLineV];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.text = @"价格";
    self.priceLabel.x = 29;
    self.priceLabel.y = CGRectGetMaxY(self.specLabel.frame)+30;
    [self.priceLabel sizeToFit];
    [self.bgView addSubview:self.priceLabel];
    
    self.inventoryLabel = [[UILabel alloc] init];
    self.inventoryLabel.text = @"库存";
    self.inventoryLabel.x = 29;
    self.inventoryLabel.y = CGRectGetMaxY(self.priceLabel.frame)+30;
    [self.inventoryLabel sizeToFit];
    [self.bgView addSubview:self.inventoryLabel];
}

@end

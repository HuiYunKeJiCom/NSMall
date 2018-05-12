//
//  NSSpecView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSSpecView.h"

@interface NSSpecView()
@property(nonatomic,strong)UILabel *specLabel;/* 规格标题 */
@property(nonatomic,strong)UITextField *specTF;/* 规格 */
@property(nonatomic,strong)UILabel *priceLabel;/* 价格标题 */
@property(nonatomic,strong)UITextField *priceTF;/* 价格 */
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
    self.specLabel = [[UILabel alloc] init];
    self.specLabel.text = @"规格";
    self.specLabel.x = 10;
    self.specLabel.y = 10;
    [self.specLabel sizeToFit];
    [self addSubview:self.specLabel];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.text = @"价格";
    self.priceLabel.x = 10;
    self.priceLabel.y = CGRectGetMaxY(self.specLabel.frame);
    [self.priceLabel sizeToFit];
    [self addSubview:self.priceLabel];
    
    self.inventoryLabel = [[UILabel alloc] init];
    self.inventoryLabel.text = @"库存";
    self.inventoryLabel.x = 10;
    self.inventoryLabel.y = CGRectGetMaxY(self.priceLabel.frame);
    [self.inventoryLabel sizeToFit];
    [self addSubview:self.inventoryLabel];
}

@end

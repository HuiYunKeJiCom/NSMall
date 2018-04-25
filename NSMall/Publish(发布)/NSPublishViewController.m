//
//  NSPublishViewController.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSPublishViewController.h"

@interface NSPublishViewController ()
/** 线上商品 按钮 */
@property(nonatomic,strong)UIButton * onLineGoods;
/** 线下店铺 按钮 */
@property(nonatomic,strong)UIButton * underLineShop;

/** 线上 */
@property(nonatomic,strong)UILabel *onLine;
/** 线下 */
@property(nonatomic,strong)UILabel *underLine;
@end

@implementation NSPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void)createUI{
    self.onLineGoods  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.onLineGoods addTarget:self action:@selector(getGoodsOrShop:) forControlEvents:UIControlEventTouchUpInside];
    self.onLineGoods.left = GetScaleWidth(65);
    self.onLineGoods.top = GetScaleWidth(425);
    self.onLineGoods.size = CGSizeMake(GetScaleWidth(80), GetScaleWidth(80));
    self.onLineGoods.tag = 10;
    [self.onLineGoods setImage:[UIImage imageNamed:@"publish_ico_goods"] forState:UIControlStateNormal];
    [self.view addSubview:self.onLineGoods];
    
    self.onLine = [[UILabel alloc] init];
    self.onLine.centerX = self.onLineGoods.centerX-GetScaleWidth(27);
    self.onLine.y = CGRectGetMaxY(self.onLineGoods.frame)+GetScaleWidth(15);
    self.onLine.font = [UIFont systemFontOfSize:kFontNum15];
    self.onLine.textColor = KColorText323232;
    self.onLine.text = KLocalizableStr(@"线上商品");
    [self.onLine sizeToFit];
    [self.view addSubview:self.onLine];
    
    self.underLineShop  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.underLineShop addTarget:self action:@selector(getGoodsOrShop:) forControlEvents:UIControlEventTouchUpInside];
    self.underLineShop.right = GetScaleWidth(246);
    self.underLineShop.top = GetScaleWidth(425);
    self.underLineShop.size = CGSizeMake(GetScaleWidth(80), GetScaleWidth(80));
    self.underLineShop.tag = 20;
    [self.underLineShop setImage:[UIImage imageNamed:@"publish_ico_shop"] forState:UIControlStateNormal];
    [self.view addSubview:self.underLineShop];
    
    self.underLine = [[UILabel alloc] init];
    self.underLine.centerX = self.underLineShop.centerX-GetScaleWidth(27);
    self.underLine.y = CGRectGetMaxY(self.underLineShop.frame)+GetScaleWidth(15);
    self.underLine.font = [UIFont systemFontOfSize:kFontNum15];
    self.underLine.textColor = KColorText323232;
    self.underLine.text = KLocalizableStr(@"线下店铺");
    [self.underLine sizeToFit];
    [self.view addSubview:self.underLine];
}

-(void)getGoodsOrShop:(UIButton *)button{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

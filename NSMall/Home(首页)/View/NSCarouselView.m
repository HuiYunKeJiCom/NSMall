//
//  NSCarouselView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/15.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCarouselView.h"
#import <SDCycleScrollView.h>
#import "UIButton+Bootstrap.h"

@interface NSCarouselView()<SDCycleScrollViewDelegate>
/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)UIButton *classifyBtn;/* 分类按钮 */
@property(nonatomic,strong)UIButton *shopCartBtn;/* 购物车按钮 */
@property(nonatomic,strong)UIButton *QRBtn;/* 二维码按钮 */
@property(nonatomic,strong)UIButton *myOrderBtn;/* 我的订单按钮 */
@end

@implementation NSCarouselView

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
    self.backgroundColor = [UIColor whiteColor];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.dc_height-GetScaleWidth(112)) delegate:self placeholderImage:nil];
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    [self addSubview:_cycleScrollView];
    
    
    float itemWidth = GetScaleWidth(70);
    float spaceWidth = (kScreenWidth-4*GetScaleWidth(70))/5.0;
    self.classifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.classifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.classifyBtn setImageWithTitle:IMAGE(@"home_ico_category")
                              withTitle:@"分类" position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self addSubview:self.classifyBtn];
    
    self.classifyBtn.x = spaceWidth;
    self.classifyBtn.y = CGRectGetMaxY(_cycleScrollView.frame)-GetScaleWidth(10);
    self.classifyBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.classifyBtn addTarget:self action:@selector(classifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.shopCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shopCartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.shopCartBtn setImageWithTitle:IMAGE(@"home_ico_buycar")
                              withTitle:@"购物车" position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self addSubview:self.shopCartBtn];
    self.shopCartBtn.x = itemWidth+2*spaceWidth;
    self.shopCartBtn.y = CGRectGetMaxY(_cycleScrollView.frame)-GetScaleWidth(10);
    self.shopCartBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.shopCartBtn addTarget:self action:@selector(shopCartButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.QRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.QRBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.QRBtn setImageWithTitle:IMAGE(@"home_ico_qrcode")
                        withTitle:@"二维码" position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self addSubview:self.QRBtn];
    self.QRBtn.x = itemWidth*2+3*spaceWidth;
    self.QRBtn.y = CGRectGetMaxY(_cycleScrollView.frame)-GetScaleWidth(10);
    self.QRBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.QRBtn addTarget:self action:@selector(QRButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.myOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.myOrderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.myOrderBtn setImageWithTitle:IMAGE(@"homg_ico_order")
                             withTitle:@"我的订单" position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self addSubview:self.myOrderBtn];
    self.myOrderBtn.x = itemWidth*3+4*spaceWidth;
    self.myOrderBtn.y = CGRectGetMaxY(_cycleScrollView.frame)-GetScaleWidth(10);
    self.myOrderBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.myOrderBtn addTarget:self action:@selector(myOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];

    UIView *view = [[UIView alloc]init];
    view.x=0;
    view.y=CGRectGetMaxY(self.shopCartBtn.frame);
    view.size = CGSizeMake(kScreenWidth, GetScaleWidth(6));
    view.backgroundColor = KBGCOLOR;
    [self addSubview:view];
    
}

- (void)setImageGroupArray:(NSArray *)imageGroupArray
{
    _imageGroupArray = imageGroupArray;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"default_160"];
    if (imageGroupArray.count == 0) return;
    _cycleScrollView.imageURLStringsGroup = _imageGroupArray;
    
}

#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了%zd轮播图",index);
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)classifyButtonClick {
    !_classifyBtnClickBlock ? : _classifyBtnClickBlock();
}

- (void)shopCartButtonClick {
    !_shopCartBtnClickBlock ? : _shopCartBtnClickBlock();
}

- (void)QRButtonClick {
    !_QRBtnClickBlock ? : _QRBtnClickBlock();
}

- (void)myOrderButtonClick {
    !_myOrderBtnClickBlock ? : _myOrderBtnClickBlock();
}

@end

//
//  GoodAttributesView.m
//  AiMeiBang
//
//  Created by Lingxiu on 16/1/25.
//  Copyright © 2016年 zym. All rights reserved.
//

#import "GoodAttributesView.h"
#import "UIButton+Bootstrap.h"
#import "GoodAttrModel.h"
#import "UIImageView+WebCache.h"

@interface GoodAttributesView ()
{
    UIButton *_selectedButton;
    NSMutableArray *_mutableArr;
    UILabel *_firstAttributeLbl;
    UILabel *_secondAttributeLbl;
    
    NSString *_goods_attr_value_1;
//    NSString *_goods_attr_value_2;
}
//@property(nonatomic,strong)NSMutableArray *priceArr;/* 价格数组 */
//@property(nonatomic,strong)NSMutableArray *stockArr;/* 库存数组 */
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIImageView *iconImgView;

@property (nonatomic, weak) UILabel *goodsPriceLbl;
/** 购买数量Lbl */
@property (nonatomic, weak) UILabel *buyNumsLbl;
// 放置属性的scrollView
@property (nonatomic, weak) UIScrollView *scrollView;
// 存放buttons的数组
@property (nonatomic, strong) NSMutableArray *firstBtnsArr;
@end
@implementation GoodAttributesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5];
//        self.priceArr = [NSMutableArray array];
//        self.stockArr = [NSMutableArray array];
        [self setupBasicView];
    }
    return self;
}

/**
 *  设置视图的基本内容
 */
- (void)setupBasicView {
    // 添加手势，点击背景视图消失
    /** 使用的时候注意名字不能用错，害我定格了几天才发现。FK
     UIGestureRecognizer
     UITapGestureRecognizer // 点击手势
     UISwipeGestureRecognizer // 轻扫手势
     */
    UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [self addGestureRecognizer:tapBackGesture];
    
    UIView *contentView = [[UIView alloc] initWithFrame:(CGRect){0, kScreenHeight - kATTR_VIEW_HEIGHT, kScreenWidth, kATTR_VIEW_HEIGHT}];
    contentView.backgroundColor = [UIColor whiteColor];
    // 添加手势，遮盖整个视图的手势，
    UITapGestureRecognizer *contentViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [contentView addGestureRecognizer:contentViewTapGesture];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIView *iconBackView = [[UIView alloc] initWithFrame:(CGRect){11, -24, 92, 92}];
    iconBackView.backgroundColor = kWhiteColor;
    iconBackView.layer.borderColor = LXBorderColor.CGColor;
    iconBackView.layer.borderWidth = 1;
    iconBackView.layer.cornerRadius = 3;
    [contentView addSubview:iconBackView];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, 92, 92}];
    [iconImgView setImage:[UIImage imageNamed:@"hdl"]];
    [iconBackView addSubview:iconImgView];
    self.iconImgView = iconImgView;
    
    UIButton *XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    XBtn.frame = CGRectMake(kScreenWidth - 28, 10, 19, 19);
    [XBtn setBackgroundImage:[UIImage imageNamed:@"逆购网app产品说明选择颜色尺寸弹窗"] forState:UIControlStateNormal];
    [XBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:XBtn];
    
    UILabel *goodsNameLbl = [[UILabel alloc] init];
    goodsNameLbl.text = @"商品名字";
    goodsNameLbl.textColor = kRedColor;
    goodsNameLbl.font = [UIFont systemFontOfSize:15];
    CGFloat goodsNameLblX = CGRectGetMaxX(iconBackView.frame) + 12;
    CGFloat goodsNameLblY = 14;
    CGSize size = [goodsNameLbl.text sizeWithFont:goodsNameLbl.font];
    goodsNameLbl.frame = (CGRect){goodsNameLblX, goodsNameLblY, size};
    [contentView addSubview:goodsNameLbl];
    self.goodsNameLbl = goodsNameLbl;
    
    UILabel *goodsPriceLbl = [[UILabel alloc] initWithFrame:(CGRect){goodsNameLbl.frame.origin.x, CGRectGetMaxY(goodsNameLbl.frame) + 9, 150, 20}];
    goodsPriceLbl.text = @"99元";
    goodsPriceLbl.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:goodsPriceLbl];
    self.goodsPriceLbl = goodsPriceLbl;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = kRedColor;
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"8预约上门时间"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(0, contentView.frame.size.height - 42, kScreenWidth, 42);
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureBtn];
    
    UIScrollView *attrScrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0, CGRectGetMaxY(iconImgView.frame), kScreenWidth, sureBtn.frame.origin.y - CGRectGetMaxY(iconImgView.frame) - 10}];
    attrScrollView.bounces = YES;
    attrScrollView.backgroundColor = kWhiteColor;
    [contentView addSubview:attrScrollView];
    self.scrollView = attrScrollView;
}
- (void)setGood_img:(NSString *)good_img {
    _good_img = good_img;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:good_img] placeholderImage:nil];
}
- (void)setGood_name:(NSString *)good_name {
    _good_name = good_name;
    self.goodsNameLbl.text = good_name;
}
- (void)setGood_price:(NSString *)good_price {
    _good_price = good_price;
    self.goodsPriceLbl.text = [NSString stringWithFormat:@"%@", good_price];
}
/**
 *  设置属性控件 - setter方法
    默认传的是两组属性
 */
- (void)setGoodAttrsArr:(NSArray *)goodAttrsArr {
    _goodAttrsArr = goodAttrsArr;
    

//    self.priceArr = ((GoodAttrModel *)goodAttrsArr[0]).attr_price;
//    self.stockArr = ((GoodAttrModel *)goodAttrsArr[0]).attr_stock;
    
    // 第一组属性
    self.goods_attr_1 = ((GoodAttrModel *)goodAttrsArr[0]).attr_id;
    self.good_price = ((GoodAttrModel *)goodAttrsArr[0]).attr_stock[0];
    self.goodsNameLbl.text = ((GoodAttrModel *)goodAttrsArr[0]).attr_price[0];
    
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(11, 17, kScreenWidth-13-11, 1)];
    line1.backgroundColor=HX_RGB(226, 228, 229);
    [self.scrollView addSubview:line1];
    
    NSArray *attrValueArr0 = ((GoodAttrModel *)goodAttrsArr[0]).attr_value;
    CGFloat one_btnsX = 11;
    CGFloat one_btnY = CGRectGetMaxY(line1.frame) + 20;
    for (int i = 0; i < attrValueArr0.count ; i++) {
        NSString *btnTittle = ((GoodAttrValueModel *)attrValueArr0[i]).attr_value;
        CGSize size = [btnTittle sizeWithAttributes:@{kButtonTextFont:NSFontAttributeName}];
//        [NSDictionary dictionaryWithObjectsAndKeys:kButtonTextFont, NSFontAttributeName, nil]
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnTittle forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
        btn.tag = i;
        [btn addTarget:self action:@selector(attrs1BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(one_btnsX, one_btnY, size.width + 30, 35);
        one_btnsX += kBigMargin + size.width + kBigMargin;
        
        while (one_btnsX  > kScreenWidth) {
            one_btnsX = 11;
            one_btnY += 45;
            if ((one_btnsX + size.width + 30) > kScreenWidth) {
                one_btnsX = 11;
                break;
            }
            btn.frame = CGRectMake(one_btnsX, one_btnY, size.width + 30, 35);
            one_btnsX += 15 + size.width + kBigMargin;
        }
        [btn defaultStyleWithNormalTitleColor:HX_RGB(136, 137, 138) andHighTitleColor:kWhiteColor andBorderColor:LXBorderColor andBackgroundColor:kWhiteColor andHighBgColor:KMainColor andSelectedBgColor:KMainColor withcornerRadius:8];
        [self.scrollView addSubview:btn];
        [self.firstBtnsArr addObject:btn];
        if(i ==0){
            [self attrs1BtnClick:btn];
        }
    }
    // 获取 第一个属性中最后一个按钮
    UIButton *btn = (UIButton *)[self.firstBtnsArr lastObject];
    
    

    UILabel *numLab=[[UILabel alloc] initWithFrame:CGRectMake(11, CGRectGetMaxY(btn.frame)+18, 80, kBigMargin)];
    [numLab setText:@"购买数量"];
    numLab.font=kContentTextFont;
    numLab.textColor=HX_RGB(136, 137, 138);
    [self.scrollView addSubview:numLab];
    
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    CGFloat minusBtnWH = 35;
    CGFloat minusBtnX = kScreenWidth-122-19-19;
    CGFloat minusBtnY = CGRectGetMaxY(numLab.frame)-10-35*0.5;
    minusBtn.frame = CGRectMake(minusBtnX, minusBtnY, minusBtnWH, minusBtnWH);
    [minusBtn defaultStyleWithNormalTitleColor:[UIColor blackColor] andHighTitleColor:HX_RGB(125, 125, 125) andBorderColor:LXBorderColor andBackgroundColor:HX_RGB(250, 250, 250) andHighBgColor:HX_RGB(220, 220, 220) withcornerRadius:1];
    [minusBtn addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:minusBtn];
    
    // count
    UILabel *buyNumsLbl = [[UILabel alloc] init];
    buyNumsLbl.text = [NSString stringWithFormat:@"%d", self.buyNum];
    buyNumsLbl.textAlignment = NSTextAlignmentCenter;
    buyNumsLbl.layer.borderWidth = 1;
    buyNumsLbl.layer.borderColor = LXBorderColor.CGColor;
    CGFloat buyNumsLblW = minusBtnWH * 2;
    CGFloat buyNumsLblH = minusBtnWH;
    CGFloat buyNumsLblX = CGRectGetMaxX(minusBtn.frame) - 1;
    CGFloat buyNumsLblY = minusBtnY;
    buyNumsLbl.frame = CGRectMake(buyNumsLblX, buyNumsLblY, buyNumsLblW, buyNumsLblH);
    [self.scrollView addSubview:buyNumsLbl];
    self.buyNumsLbl = buyNumsLbl;
    
    // +
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
    CGFloat plusBtnWH = 35;
    CGFloat plusBtnX = CGRectGetMaxX(buyNumsLbl.frame);
    CGFloat plusBtnY = minusBtnY;
    plusBtn.frame = CGRectMake(plusBtnX, plusBtnY, plusBtnWH, plusBtnWH);
    [plusBtn defaultStyleWithNormalTitleColor:[UIColor blackColor] andHighTitleColor:HX_RGB(125, 125, 125) andBorderColor:LXBorderColor andBackgroundColor:HX_RGB(250, 250, 250) andHighBgColor:HX_RGB(220, 220, 220) withcornerRadius:1];
    [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:plusBtn];
    
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(11, CGRectGetMaxY(plusBtn.frame)+16, kScreenWidth-13-11, 1)];
    line2.backgroundColor=HX_RGB(226, 228, 229);
    [self.scrollView addSubview:line2];
    
    CGFloat contentHeight = CGRectGetMaxY(buyNumsLbl.frame) + kSmallMargin;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, contentHeight);
}


- (void)showInView:(UIView *)view {
    [view addSubview:self];
    __weak typeof(self) _weakSelf = self;
    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kATTR_VIEW_HEIGHT);;
    
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _weakSelf.contentView.frame = CGRectMake(0, kScreenHeight - kATTR_VIEW_HEIGHT, kScreenWidth, kATTR_VIEW_HEIGHT);
    }];
}
- (void)removeView {
    __weak typeof(self) _weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor clearColor];
        _weakSelf.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kATTR_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [_weakSelf removeFromSuperview];
    }];
}

#pragma mark - 按钮点击事件
- (void)sureBtnClick {
    // 购买数量
    NSString *num = self.buyNumsLbl.text;
    // 属性ID str
    NSString *attr_id1 = [NSString stringWithFormat:@"%@-%@", _goods_attr_1, _goods_attr_value_1];
    NSString *attr_id = [NSString stringWithFormat:@"%@|%@", attr_id1];
    if (self.sureBtnsClick) {
        self.sureBtnsClick(num, attr_id, self.goods_attr_value_1);
    }
    [self removeView];
}
/**
 *     第一组按钮的点击事件
 */
-(void)attrs1BtnClick:(UIButton *)button {
    
    GoodAttrModel *model = self.goodAttrsArr[0];
    self.good_price = model.attr_stock[button.tag];
    self.goodsNameLbl.text = model.attr_price[button.tag];
    
    button.selected = !button.selected;
    if (button.selected) {
        for (UIButton *btn in self.firstBtnsArr) {
            btn.selected = NO;
        }
        UIButton *btn = [self.firstBtnsArr objectAtIndex:button.tag];
        btn.selected = YES;
        
        self.goods_attr_value_1 = button.titleLabel.text;
    } else {
        self.goods_attr_value_1 = nil;
    }
}

- (void)minusBtnClick {
    if (self.buyNum == 1) return;
    
    self.buyNumsLbl.text = [NSString stringWithFormat:@"%d", --self.buyNum];
}

- (void)plusBtnClick {
    self.buyNumsLbl.text = [NSString stringWithFormat:@"%d", ++self.buyNum];
}
#pragma mark - 懒加载
- (NSMutableArray *)firstBtnsArr
{
    if (!_firstBtnsArr) {
        self.firstBtnsArr  = [[NSMutableArray alloc] init];
    }
    return _firstBtnsArr;
}

- (int)buyNum
{
    if (!_buyNum) {
        self.buyNum = 1;
    }
    return _buyNum;
}

@end

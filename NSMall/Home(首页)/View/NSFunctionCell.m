//
//  NSFunctionCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/15.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSFunctionCell.h"
#import "UIButton+Bootstrap.h"

@interface NSFunctionCell()
@property (nonatomic, strong) UIView           *bgView;
@property(nonatomic,strong)UIButton *classifyBtn;/* 分类按钮 */
@property(nonatomic,strong)UIButton *shopCartBtn;/* 购物车按钮 */
@property(nonatomic,strong)UIButton *QRBtn;/* 二维码按钮 */
@property(nonatomic,strong)UIButton *myOrderBtn;/* 我的订单按钮 */
@end

@implementation NSFunctionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(73+30))];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    float itemWidth = GetScaleWidth(70);
    float spaceWidth = (kScreenWidth-4*GetScaleWidth(70))/5.0;
    self.classifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.classifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.classifyBtn setImageWithTitle:IMAGE(@"home_ico_category")
                                              withTitle:@"分类" position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.bgView addSubview:self.classifyBtn];
    
    self.classifyBtn.x = spaceWidth;
    self.classifyBtn.y = -GetScaleWidth(10);
    self.classifyBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.classifyBtn addTarget:self action:@selector(classifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.shopCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shopCartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.shopCartBtn setImageWithTitle:IMAGE(@"home_ico_buycar")
                              withTitle:@"购物车" position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.bgView addSubview:self.shopCartBtn];
    self.shopCartBtn.x = itemWidth+2*spaceWidth;
    self.shopCartBtn.y = -GetScaleWidth(10);
    self.shopCartBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.shopCartBtn addTarget:self action:@selector(shopCartButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.QRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.QRBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.QRBtn setImageWithTitle:IMAGE(@"home_ico_qrcode")
                              withTitle:@"收付款" position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.bgView addSubview:self.QRBtn];
    self.QRBtn.x = itemWidth*2+3*spaceWidth;
    self.QRBtn.y = -GetScaleWidth(10);
    self.QRBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.QRBtn addTarget:self action:@selector(QRButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.myOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.myOrderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.myOrderBtn setImageWithTitle:IMAGE(@"homg_ico_order")
                              withTitle:@"我的订单" position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.bgView addSubview:self.myOrderBtn];
    self.myOrderBtn.x = itemWidth*3+4*spaceWidth;
    self.myOrderBtn.y = -GetScaleWidth(10);
    self.myOrderBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.myOrderBtn addTarget:self action:@selector(myOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
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

//
//  NSGoodsDetailVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGoodsDetailVC.h"
#import "GoodsDetailAPI.h"
#import "ADOrderTopToolView.h"
#import "UIButton+Bootstrap.h"

@interface NSGoodsDetailVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *SV;/* 滚动 */
@end

@implementation NSGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
    [self setUpNavTopView];
    [self setUpBottomView];
//    self.currentPage = 1;
//    [self requestAllOrder:NO];
}

-(void)buildUI{
    self.SV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopBarHeight,kScreenWidth,kScreenHeight-TopBarHeight-GetScaleWidth(50))];
    self.SV.backgroundColor = KBGCOLOR;
//    self.SV.pagingEnabled = YES;
    self.SV.delegate = self;
    self.SV.showsVerticalScrollIndicator = NO;
//    self.SV.directionalLockEnabled = YES;
    self.SV.tag = 100;
    [self.view addSubview:self.SV];
    
    //商品信息
    UIView *goodsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(65))];
    goodsView.backgroundColor = kWhiteColor;
    [self.SV addSubview:goodsView];
    
    CGSize nameSize = [self contentSizeWithTitle:@"家乡脐橙" andFont:15];
    UILabel *goodsName = [[UILabel alloc] initWithFrame:CGRectMake(GetScaleWidth(18), GetScaleWidth(18),nameSize.width,nameSize.height) FontSize:15];
    goodsName.textColor = kBlackColor;
    goodsName.text = @"家乡脐橙";
    [goodsView addSubview:goodsName];
    
    CGSize priceSize = [self contentSizeWithTitle:@"N26/¥150" andFont:14];
    UILabel *goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(GetScaleWidth(18), CGRectGetMaxY(goodsName.frame)+GetScaleWidth(7),priceSize.width,priceSize.height) FontSize:14];
    goodsPrice.textColor = kRedColor;
    goodsPrice.text = @"N26/¥150";
    [goodsView addSubview:goodsPrice];
    
    CGSize shipSize = [self contentSizeWithTitle:@"运费:N4" andFont:14];
    UILabel *goodsShip = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsPrice.frame)+GetScaleWidth(10), CGRectGetMaxY(goodsName.frame)+GetScaleWidth(7),shipSize.width,shipSize.height) FontSize:14];
    goodsShip.textColor = [UIColor lightGrayColor];
    goodsShip.text = @"运费:N4";
    [goodsView addSubview:goodsShip];
    
    //商品简介
    UIView *goodsIntroductionV = [[UIView alloc]initWithFrame:CGRectZero];
    goodsIntroductionV.backgroundColor = kWhiteColor;
    [self.SV addSubview:goodsIntroductionV];
    goodsIntroductionV.x = 0;
    goodsIntroductionV.y = CGRectGetMaxY(goodsView.frame)+GetScaleWidth(10);
    
    float height = GetScaleWidth(15);
    
    UILabel *goodsDetail = [[UILabel alloc] initWithFrame:CGRectZero FontSize:14];
    goodsDetail.textColor = kBlackColor;
    goodsDetail.text = @"运费:N4";
    [goodsIntroductionV addSubview:goodsDetail];
    
    goodsDetail.text = @"家里自己种的脐橙成熟啦.今年大丰收,只卖15NBS一箱,买到就是赚到.2箱起免快递,全国包邮,不甜退货";
    goodsDetail.numberOfLines = 0;
    goodsDetail.x = GetScaleWidth(18);
    goodsDetail.y = height;
    CGSize maximumLabelSize = CGSizeMake(kScreenWidth-GetScaleWidth(18+28), 9999);//labelsize的最大值
    CGSize expectSize = [goodsDetail sizeThatFits:maximumLabelSize];
    goodsDetail.size = CGSizeMake(expectSize.width, expectSize.height);
    height = height+expectSize.height+16;
    
    float itemWidth = kScreenWidth-38;//323
    float itemHeight = 205*(kScreenWidth-38)/323.0;
    for(int i=0;i<3;i++){
        UIImageView *goodsIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        goodsIV.x = GetScaleWidth(19);
//        if(i==0){
//            goodsIV.y = height;
//            height += itemHeight+15;
//        }else{
            goodsIV.y = height;
            height += itemHeight+15;
//        }
        goodsIV.size = CGSizeMake(itemWidth, itemHeight);
        goodsIV.backgroundColor = kRedColor;
//        [goodsIV sd_setImageWithURL:[NSURL URLWithString:productModel.productImageList[i]]];
        
        [goodsIntroductionV addSubview:goodsIV];
    }
    goodsIntroductionV.size = CGSizeMake(kScreenWidth, height+GetScaleWidth(4));
    
    //卖家信息
    UIView *sellerView = [[UIView alloc]initWithFrame:CGRectMake(0, height+GetScaleWidth(10)+GetScaleWidth(75), kScreenWidth, GetScaleWidth(54))];
    sellerView.backgroundColor = kWhiteColor;
    [self.SV addSubview:sellerView];

    CGSize userNameSize = [self contentSizeWithTitle:@"Winder" andFont:14];
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(GetScaleWidth(18), GetScaleWidth(13),userNameSize.width,userNameSize.height) FontSize:14];
    userName.textColor = kBlackColor;
    userName.text = @"Winder";
    [sellerView addSubview:userName];
    
    UIImageView *sellerIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    sellerIV.x = kScreenWidth - GetScaleWidth(19);
    sellerIV.y = GetScaleWidth(10);
    sellerIV.size = CGSizeMake(GetScaleWidth(34), GetScaleWidth(34));
    sellerIV.backgroundColor = kRedColor;
    //        [sellerIV sd_setImageWithURL:[NSURL URLWithString:productModel.productImageList[i]]];
    [sellerView addSubview:sellerIV];
    
    self.SV.contentSize = CGSizeMake(self.SV.bounds.size.width, height+GetScaleWidth(79)+GetScaleWidth(54));
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"商品详情")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

#pragma mark - 底部按钮(收藏 留言 购物车 加入购物车 立即购买)
-(void)setUpBottomView{
    [self setUpLeftTwoButton];//收藏 留言 购物车
    
    [self setUpRightTwoButton];//加入购物车 立即购买
}

#pragma mark - 收藏 购物车
- (void)setUpLeftTwoButton
{
    CGFloat buttonW = kScreenWidth * 0.5*0.35;
    CGFloat buttonH = GetScaleWidth(50);
    CGFloat buttonY = kScreenHeight - buttonH;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, buttonY, kScreenWidth, buttonH)];
    bottomView.backgroundColor = kWhiteColor;
    bottomView.layer.borderWidth = 1;
    bottomView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:bottomView];
    
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectionBtn setImageWithTitle:IMAGE(@"goods_detail_ico_fav") withTitle:@"收藏" position:@"left" font:UISystemFontSize(13) forState:UIControlStateNormal];
        collectionBtn.tag = 2;
//    collectionBtn.backgroundColor = kRedColor;
    [collectionBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
//        [collectionBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        collectionBtn.frame = CGRectMake(0, 12, buttonW, buttonH);
        [bottomView addSubview:collectionBtn];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    [messageBtn setImageWithTitle:IMAGE(@"goods_detail_ico_message") withTitle:@"留言" position:@"left" font:UISystemFontSize(13) forState:UIControlStateNormal];
    messageBtn.tag = 3;
    //        [messageBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.frame = CGRectMake(buttonW, 12, buttonW, buttonH);
    [bottomView addSubview:messageBtn];
    
    UIButton *buycarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buycarBtn setImageWithTitle:IMAGE(@"goods_detail_ico_buycar") withTitle:@"购物车" position:@"left" font:UISystemFontSize(13) forState:UIControlStateNormal];
    [buycarBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    buycarBtn.tag = 4;
    //        [buycarBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    buycarBtn.frame = CGRectMake(buttonW*2, 12, buttonW+20, buttonH);
    [bottomView addSubview:buycarBtn];
    
}

#pragma mark - 加入购物车 立即购买
- (void)setUpRightTwoButton
{
    NSArray *titles = @[@"加入购物车",@"立即购买"];
    CGFloat buttonW = 75;
    CGFloat buttonH = 28;
    CGFloat buttonY = kScreenHeight - buttonH-11;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = UISystemFontSize(14);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = i + 20;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        if(i==0){
            button.backgroundColor = KMainColor;
        }else{
            button.backgroundColor = kRedColor;
        }
//        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = kScreenWidth-4-buttonW-(buttonW+11)*(1-i);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);

        [self.view addSubview:button];
    }
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

@end

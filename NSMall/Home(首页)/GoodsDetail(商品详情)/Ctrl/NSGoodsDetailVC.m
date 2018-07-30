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
#import "NSMessageTV.h"
#import "GoodsDetailAPI.h"
#import "NSGoodsDetailModel.h"
#import "GoodAttributesView.h"
#import "GoodAttrModel.h"
#import "NSAddCartParam.h"
#import "LZCartViewController.h"
#import "NSNewFirmOrderVC.h"

#import "NSProductCommentParam.h"
#import "NSCommentItemModel.h"
#import "NSPublishCommentParam.h"
#import "UserPageVC.h"
#import "UITextView+ZWPlaceHolder.h"

@interface NSGoodsDetailVC ()<UIScrollViewDelegate,NSMessageTVDelegate,UIAlertViewDelegate,UITextViewDelegate>
@property(nonatomic,strong)UIScrollView *SV;/* 滚动 */
@property(nonatomic,strong)NSGoodsDetailModel *model;/* 商品详情模型 */
@property(nonatomic,copy)NSString *productID;/* 商品ID */
@property (nonatomic, assign) BOOL isCollect;
@property(nonatomic)NSInteger collectNum;/* 收藏人数 */
@property (nonatomic, strong) NSArray *goodAttrsArr;
@property(nonatomic,strong)NSMutableDictionary *goodSpecDict;/* 规格字典 */
@property(nonatomic,strong)NSMessageTV *messageTV;/* 留言列表 */
@property(nonatomic,strong)NSProductCommentParam *param;/* 获取评论列表的参数 */
@property(nonatomic)float height;/* 高度 */
@property(nonatomic,strong)UIView *noMoreV;/* 无更多数据 */

@property(nonatomic,strong)UIView *messageView;/* 留言View */
@property (nonatomic, copy) NSIndexPath *deleteIndexPath;/* 待删除的评论IndexPath */
@property(nonatomic,strong)UIView *commentView;/* 评论View */
@property(nonatomic,strong)UIView *bottomV;/* 底部留言View */
@property(nonatomic,strong)UITextView *messageTF;/* 评论框 */
@end

@implementation NSGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.param = [NSProductCommentParam new];
    [self setUpNavTopView];
//    self.currentPage = 1;
//    [self requestAllOrder:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didClickKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didKboardDisappear:) name:UIKeyboardWillHideNotification object:nil];

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
    
    CGSize nameSize = [self contentSizeWithTitle:self.model.name andFont:15];
    UILabel *goodsName = [[UILabel alloc] initWithFrame:CGRectMake(GetScaleWidth(18), GetScaleWidth(18),nameSize.width,nameSize.height) FontSize:15];
    goodsName.textColor = kBlackColor;
    goodsName.text = self.model.name;
    [goodsView addSubview:goodsName];
    
    UILabel *goodsPrice = [[UILabel alloc] initWithFrame:CGRectZero FontSize:14];
    goodsPrice.text = [NSString stringWithFormat:@"N%.2f",self.model.show_price];
    CGSize priceSize = [self contentSizeWithTitle:goodsPrice.text andFont:14];
    goodsPrice.frame = CGRectMake(GetScaleWidth(18), CGRectGetMaxY(goodsName.frame)+GetScaleWidth(7),priceSize.width,priceSize.height);
    goodsPrice.textColor = kRedColor;
    [goodsView addSubview:goodsPrice];
    
    CGSize shipSize = [self contentSizeWithTitle:[NSString stringWithFormat:@"运费:N%.2f",self.model.ship_price] andFont:14];
    UILabel *goodsShip = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsPrice.frame)+GetScaleWidth(10), CGRectGetMaxY(goodsName.frame)+GetScaleWidth(7),shipSize.width,shipSize.height) FontSize:14];
    goodsShip.textColor = kGreyColor;
    goodsShip.text = [NSString stringWithFormat:@"运费:N%.2f",self.model.ship_price];
    [goodsView addSubview:goodsShip];
    
    //商品简介
    UIView *goodsIntroductionV = [[UIView alloc]initWithFrame:CGRectZero];
    goodsIntroductionV.backgroundColor = kWhiteColor;
    [self.SV addSubview:goodsIntroductionV];
    goodsIntroductionV.x = 0;
    goodsIntroductionV.y = CGRectGetMaxY(goodsView.frame)+GetScaleWidth(10);
    
    self.height = GetScaleWidth(15);
    
    UILabel *goodsDetail = [[UILabel alloc] initWithFrame:CGRectZero FontSize:14];
    goodsDetail.textColor = kBlackColor;
    [goodsIntroductionV addSubview:goodsDetail];
    goodsDetail.text = self.model.introduce;
    goodsDetail.numberOfLines = 0;
    goodsDetail.x = GetScaleWidth(18);
    goodsDetail.y = self.height;
    CGSize maximumLabelSize = CGSizeMake(kScreenWidth-GetScaleWidth(18+28), 9999);//labelsize的最大值
    CGSize expectSize = [goodsDetail sizeThatFits:maximumLabelSize];
    goodsDetail.size = CGSizeMake(expectSize.width, expectSize.height);
    self.height = self.height+expectSize.height+16;
    


    
    float itemWidth = (kScreenWidth-GetScaleWidth(22)-GetScaleWidth(16))/3.0;
    
    UIScrollView *imageSV = [[UIScrollView alloc]init];
    //    self.imageSV.backgroundColor = [UIColor greenColor];
    [goodsIntroductionV addSubview:imageSV];
    imageSV.x = GetScaleWidth(19);
    imageSV.y = self.height;
    imageSV.size = CGSizeMake(kScreenWidth, itemWidth);
    
    imageSV.contentSize = CGSizeMake((itemWidth+GetScaleWidth(8))*self.model.productImageList.count, 0);
    self.height = itemWidth+GetScaleWidth(10)+self.height;
    for(int i=0;i<self.model.productImageList.count;i++){
        UIImageView *goodsIV = [[UIImageView alloc]initWithFrame:CGRectMake((itemWidth+GetScaleWidth(8))*i, 0, itemWidth, itemWidth)];
        [goodsIV sd_setImageWithURL:[NSURL URLWithString:self.model.productImageList[i]]];
        [imageSV addSubview:goodsIV];
    }

    goodsIntroductionV.size = CGSizeMake(kScreenWidth, self.height+GetScaleWidth(4));
    
    //卖家信息
    UIView *sellerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height+GetScaleWidth(10)+GetScaleWidth(75), kScreenWidth, GetScaleWidth(54))];
    sellerView.backgroundColor = kWhiteColor;
    [self.SV addSubview:sellerView];
    
    CGSize userNameSize = [self contentSizeWithTitle:self.model.user_name andFont:14];
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(GetScaleWidth(18), GetScaleWidth(13),userNameSize.width,userNameSize.height) FontSize:14];
    userName.textColor = kBlackColor;
    userName.text = self.model.user_name;
    [sellerView addSubview:userName];
    
    if(self.model.is_certification == 0){
        CGSize certificationSize = [self contentSizeWithTitle:@"未认证" andFont:12];
        UILabel *certificationLab = [[UILabel alloc] initWithFrame:CGRectMake(GetScaleWidth(5)+CGRectGetMaxX(userName.frame), GetScaleWidth(13),certificationSize.width+GetScaleWidth(10),certificationSize.height+GetScaleWidth(2)) FontSize:12];
        certificationLab.textAlignment = NSTextAlignmentCenter;
        certificationLab.backgroundColor = KBGCOLOR;
        certificationLab.textColor = kWhiteColor;
        certificationLab.text = @"未认证";
        //设置圆角
        certificationLab.layer.cornerRadius = 5;
        //将多余的部分切掉
        certificationLab.layer.masksToBounds = YES;
        [sellerView addSubview:certificationLab];
    }else{
        CGSize certificationSize = [self contentSizeWithTitle:@"实名认证" andFont:12];
        UILabel *certificationLab = [[UILabel alloc] initWithFrame:CGRectMake(GetScaleWidth(5)+CGRectGetMaxX(userName.frame), GetScaleWidth(13),certificationSize.width+GetScaleWidth(10),certificationSize.height+GetScaleWidth(2)) FontSize:12];
        certificationLab.textAlignment = NSTextAlignmentCenter;
        certificationLab.backgroundColor = KMainColor;
        certificationLab.textColor = kWhiteColor;
        certificationLab.text = @"实名认证";
        //设置圆角
        certificationLab.layer.cornerRadius = 5;
        //将多余的部分切掉
        certificationLab.layer.masksToBounds = YES;
        [sellerView addSubview:certificationLab];
    }

    UIImageView *sellerIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    sellerIV.x = kScreenWidth - GetScaleWidth(19)-GetScaleWidth(34);
    sellerIV.y = GetScaleWidth(10);
    sellerIV.size = CGSizeMake(GetScaleWidth(34), GetScaleWidth(34));
//    sellerIV.backgroundColor = kRedColor;
    [sellerIV sd_setImageWithURL:[NSURL URLWithString:self.model.user_avatar]];
    [sellerView addSubview:sellerIV];
    sellerIV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkUserPage)];
    [sellerIV addGestureRecognizer:myTap];
    
    
    NSString *shopContentStr = [NSString stringWithFormat:@"%lu商品  %lu店铺  %lu评价",self.model.product_number,self.model.store_number,self.model.comment_number];
    
    CGSize shopContentSize = [self contentSizeWithTitle:shopContentStr andFont:13];
    UILabel *shopContent = [[UILabel alloc] initWithFrame:CGRectMake(GetScaleWidth(18), GetScaleWidth(10)+GetScaleWidth(34)-shopContentSize.height,shopContentSize.width,shopContentSize.height) FontSize:13];
    shopContent.textColor = kGreyColor;
    shopContent.text = shopContentStr;
    [sellerView addSubview:shopContent];
    
    //留言
    self.messageView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sellerView.frame), kScreenWidth, GetScaleWidth(312))];
    self.messageView.backgroundColor = kWhiteColor;
    [self.SV addSubview:self.messageView];
    
    CGSize titleSize = [self contentSizeWithTitle:@"留言" andFont:15];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(GetScaleWidth(18), GetScaleWidth(25),titleSize.width,titleSize.height) FontSize:15];
    titleLab.textColor = kBlackColor;
    titleLab.text = @"留言";
    [self.messageView addSubview:titleLab];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame)+GetScaleWidth(12), kScreenWidth, GetScaleWidth(1))];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.messageView addSubview:lineView];
    
    self.messageTV = [[NSMessageTV alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.messageTV.backgroundColor = kWhiteColor;
    self.messageTV.bounces = NO;
    self.messageTV.tbDelegate = self;
    self.messageTV.isRefresh = NO;
    self.messageTV.isLoadMore = NO;
    self.messageTV.tableFooterView = [UIView new]; //去除多余分割线
    if (@available(iOS 11.0, *)) {
        self.messageTV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.messageTV.x = 0;
    self.messageTV.y = CGRectGetMaxY(lineView.frame)+GetScaleWidth(10);
    [self.messageView addSubview:self.messageTV];

    [self requestAllOrder:NO];
    
    self.noMoreV = [[UIView alloc]init];
    self.noMoreV.backgroundColor = kWhiteColor;
    [self.messageView addSubview:self.noMoreV];
    
    UILabel *noMoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(40)) FontSize:14];
    [self.noMoreV addSubview:noMoreLabel];
    noMoreLabel.textAlignment = NSTextAlignmentCenter;
    noMoreLabel.textColor = kGreyColor;
    noMoreLabel.text = @"没有更多数据";

    
}

-(void)getDataWithProductID:(NSString *)productId andCollectNum:(NSInteger)collectNum{
    self.productID = productId;
    self.collectNum = collectNum;
    [GoodsDetailAPI getDetailWithGoodsID:productId success:^(NSGoodsDetailModel *model) {
        DLog(@"获取商品详情成功");
        self.model = model;
        if(model.is_collect == 1){
            self.isCollect = YES;
        }else{
            self.isCollect = NO;
        }
        [self buildUI];
        [self setUpBottomView];
    } failure:^(NSError *error) {
        DLog(@"获取商品详情失败");
    }];
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
    
    [self createBottomView];
    
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
    bottomView.layer.borderColor = [KBGCOLOR CGColor];
    [self.view addSubview:bottomView];
    
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(self.isCollect){
        [collectionBtn setImageWithTitle:IMAGE(@"goods_detail_ico_fav_on") withTitle:@"收藏" position:@"left" font:UISystemFontSize(13) forState:UIControlStateNormal];
    }else{
        [collectionBtn setImageWithTitle:IMAGE(@"goods_detail_ico_fav") withTitle:@"收藏" position:@"left" font:UISystemFontSize(13) forState:UIControlStateNormal];
    }

    collectionBtn.frame = CGRectMake(0, 2, buttonW+20, buttonH);
    [bottomView addSubview:collectionBtn];
        collectionBtn.tag = 2;
//    collectionBtn.backgroundColor = kRedColor;
    [collectionBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        [collectionBtn addTarget:self action:@selector(collectionGoods:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    [messageBtn setImageWithTitle:IMAGE(@"goods_detail_ico_message") withTitle:@"留言" position:@"left" font:UISystemFontSize(13) forState:UIControlStateNormal];
    messageBtn.tag = 3;
    [messageBtn addTarget:self action:@selector(showBottomV) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.frame = CGRectMake(buttonW+10, 2, buttonW, buttonH);
    [bottomView addSubview:messageBtn];
    
    UIButton *buycarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buycarBtn setImageWithTitle:IMAGE(@"goods_detail_ico_buycar") withTitle:@"购物车" position:@"left" font:UISystemFontSize(13) forState:UIControlStateNormal];
    [buycarBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    buycarBtn.tag = 4;
    [buycarBtn addTarget:self action:@selector(goToCart) forControlEvents:UIControlEventTouchUpInside];
    buycarBtn.frame = CGRectMake(buttonW*2, 2, buttonW+20, buttonH);
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
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = kScreenWidth-4-buttonW-(buttonW+11)*(1-i);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);

        [self.view addSubview:button];
    }
}

-(void)createBottomView{
    
    self.commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    
    self.bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-GetScaleWidth(150), kScreenWidth, GetScaleWidth(150))];
    self.bottomV.backgroundColor = kWhiteColor;
    self.bottomV.layer.borderWidth = 1;
    self.bottomV.alpha = 0.0;
    self.bottomV.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:self.bottomV];
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.backgroundColor = kRedColor;
//    backBtn.x = 19;
//    backBtn.y = 15;
//    backBtn.size = CGSizeMake(20, 20);
//    [backBtn addTarget:self action:@selector(hideBottomV) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomV addSubview:backBtn];
    
    self.messageTF = [[UITextView alloc] initWithFrame:CGRectMake(GetScaleWidth(10), GetScaleWidth(15), kScreenWidth-GetScaleWidth(20), GetScaleWidth(90))];
    self.messageTF.textColor = [UIColor lightGrayColor];
    self.messageTF.backgroundColor = KBGCOLOR;
    self.messageTF.font = [UIFont systemFontOfSize:14];
    self.messageTF.delegate = self;
    self.messageTF.zw_placeHolder = @"请输入评论内容";
    self.messageTF.zw_placeHolderColor = [UIColor lightGrayColor];
    
    self.messageTF.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
//    self.messageTF = [[UITextField alloc]init];
//    self.messageTF.delegate = self;
//    self.messageTF.textColor = kBlackColor;
//    self.messageTF.backgroundColor = kWhiteColor;
//    self.messageTF.font = UISystemFontSize(14);
//    self.messageTF.x = 58;
//    self.messageTF.y = 10;
//    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, GetScaleWidth(25))];
//    self.messageTF.leftView = paddingView;
//    self.messageTF.leftViewMode = UITextFieldViewModeAlways;
//    self.messageTF.size = CGSizeMake(kScreenWidth-136, 25);
//    self.messageTF.clearsOnBeginEditing = YES;
    [self.bottomV addSubview:self.messageTF];
    self.messageTF.layer.cornerRadius = 5.0;//2.0是圆角的弧度，根据需求自己更改
//    self.messageTF.layer.borderColor = kBlackColor.CGColor;//设置边框颜色
//    self.messageTF.layer.borderWidth = 1.0f;//设置边框宽度
    
    UIButton *sendBtn = [[UIButton alloc]init];
    [sendBtn setTitleColor:kWhiteColor forState:0];
    sendBtn.titleLabel.font = UISystemFontSize(13);
    //    [snedBtn addTarget:self action:@selector(delButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.layer.cornerRadius = 5.0;//2.0是圆角的弧度，根据需求自己更改
    //    snedBtn.layer.borderColor = KMainColor.CGColor;//设置边框颜色
    //    snedBtn.layer.borderWidth = 1.0f;//设置边框宽度
    sendBtn.backgroundColor = KMainColor;
    [sendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomV addSubview:sendBtn];
    sendBtn.x = kScreenWidth-GetScaleWidth(75);
    sendBtn.y = CGRectGetMaxY(self.messageTF.frame)+GetScaleWidth(10);
    sendBtn.size = CGSizeMake(GetScaleWidth(60), GetScaleWidth(25));
}

-(void)showBottomV{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomV.alpha = 1.0;
    }];
}

-(void)hideBottomV{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomV.alpha = 0.0;
    }];
}

-(void)sendComment{
    NSPublishCommentParam *param = [NSPublishCommentParam new];
    param.productId = self.productID;
    param.content = self.messageTF.text;
    
    [GoodsDetailAPI publishComment:param success:^(NSCommentItemModel * _Nullable result) {
        DLog(@"发布商品评论成功");
        
        [self.messageTV.data insertObject:[[NSMessageModel alloc] initWithUserName:result.user_name imagePath:result.user_avatar content:result.content time:result.create_time commentId:result.comment_id userId:result.user_id] atIndex:0];
        
        self.messageView.size = CGSizeMake(kScreenWidth, self.messageTV.data.count*GetScaleWidth(95)+GetScaleWidth(172));
        self.messageTV.size = CGSizeMake(kScreenWidth, self.messageTV.data.count*GetScaleWidth(95));
        self.SV.contentSize = CGSizeMake(self.SV.bounds.size.width, self.height+GetScaleWidth(203)+GetScaleWidth(40)+(self.messageTV.data.count)*GetScaleWidth(95));
        self.noMoreV.y = CGRectGetMaxY(self.messageTV.frame);
        [self.messageTV reloadData];
        self.messageTF.text = @"";
        
    } failure:^(NSError *error) {
        DLog(@"发布商品评论失败");
    }];
    
}

-(void)setModel:(NSGoodsDetailModel *)model{
    _model = model;
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

-(void)collectionGoods:(UIButton *)btn{
    
        [GoodsDetailAPI changeProductCollectState:self.productID success:^(NSCollectModel *model) {
            DLog(@"收藏成功");
            if(self.isCollect){
                [btn setImageWithTitle:IMAGE(@"goods_detail_ico_fav") withTitle:@"收藏" position:@"left" font:UISystemFontSize(13) forState:UIControlStateNormal];
                self.isCollect = NO;
            }else{
                [btn setImageWithTitle:IMAGE(@"goods_detail_ico_fav_on") withTitle:@"收藏" position:@"left" font:UISystemFontSize(13) forState:UIControlStateNormal];
                self.isCollect = YES;
            }
            btn.frame = CGRectMake(0, -12, kScreenWidth * 0.5*0.35+20, GetScaleWidth(50));
        } failure:^(NSError *error) {
            DLog(@"收藏失败");
        }];
}


-(void)bottomButtonClick:(UIButton *)button{
    if(button.tag == 20){
        //加入购物车
        if(self.model.productSpecList.count == 0){
            NSAddCartParam *param = [NSAddCartParam new];
            param.productId = self.productID;
            param.buyNumber = @"1";
            [GoodsDetailAPI addProductToCartWithParam:param success:^{
                DLog(@"加入购物车成功");
                
            } faulre:^(NSError *error) {
                DLog(@"加入购物车失败");
            }];
        }else{
            [self addGoodAttributesView];
        }
        
    }else{
        //立即购买
        if(self.model.productSpecList.count == 0){
            NSAddCartParam *param = [NSAddCartParam new];
            param.productId = self.productID;
            param.buyNumber = @"1";
            NSNewFirmOrderVC *firmOrderVC = [NSNewFirmOrderVC new];
            [firmOrderVC loadDataWithParam:param];
            [self.navigationController pushViewController:firmOrderVC animated:YES];
            
        }else{
            [self addBuyNowGoodAttributesView];
        }
    }
}

-(void)addGoodAttributesView{
    
    GoodAttrModel *model1 = [GoodAttrModel new];
    model1.attr_id = @"11";
    model1.attr_name = nil;
    model1.attr_value = [NSMutableArray array];
    for(int i=0;i<self.model.productSpecList.count;i++){
        NSDetailItemModel *itemModel = self.model.productSpecList[i];
        GoodAttrValueModel *value = [GoodAttrValueModel new];
        value.attr_value = itemModel.spec_name;
        [model1.attr_value addObject:value];
        [self.goodSpecDict setValue:itemModel.product_spec_id forKey:itemModel.spec_name];
    }
    
    self.goodAttrsArr = [NSArray arrayWithObjects: model1, nil];
    
    GoodAttributesView *attributesView = [[GoodAttributesView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}];
    attributesView.goodAttrsArr = self.goodAttrsArr;
    attributesView.sureBtnsClick = ^(NSString *num, NSString *attrs, NSString *goods_attr_value_1) {
        NSAddCartParam *param = [NSAddCartParam new];
        param.productId = self.productID;
        param.buyNumber = num;
        [GoodsDetailAPI addProductToCartWithParam:param success:^{
            DLog(@"加入购物车成功");
        } faulre:^(NSError *error) {
            DLog(@"加入购物车失败");
        }];
    };
    
    attributesView.good_img = self.model.productImageList[0];
    if(self.model.stock == -1){
        attributesView.good_price = @"无限供应";
    }else{
        attributesView.good_price = [NSString stringWithFormat:@"库存 %lu 件",self.model.stock];
    }
    
    attributesView.goodsNameLbl.text = [NSString stringWithFormat:@"N%.2f",self.model.show_price];
    
    [attributesView showInView:self.navigationController.view];
}

-(void)addBuyNowGoodAttributesView{
    
    GoodAttrModel *model1 = [GoodAttrModel new];
    model1.attr_id = @"12";
    model1.attr_name = nil;
    model1.attr_value = [NSMutableArray array];
    for(int i=0;i<self.model.productSpecList.count;i++){
        NSDetailItemModel *itemModel = self.model.productSpecList[i];
        GoodAttrValueModel *value = [GoodAttrValueModel new];
        value.attr_value = itemModel.spec_name;
        [model1.attr_value addObject:value];
        [self.goodSpecDict setValue:itemModel.product_spec_id forKey:itemModel.spec_name];
    }
    
    self.goodAttrsArr = [NSArray arrayWithObjects: model1, nil];
    
    GoodAttributesView *attributesView = [[GoodAttributesView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}];
    attributesView.goodAttrsArr = self.goodAttrsArr;
    attributesView.sureBtnsClick = ^(NSString *num, NSString *attrs, NSString *goods_attr_value_1) {
        NSAddCartParam *param = [NSAddCartParam new];
        param.productId = self.productID;
        param.buyNumber = num;
        NSNewFirmOrderVC *firmOrderVC = [NSNewFirmOrderVC new];
        [firmOrderVC loadDataWithParam:param];
        [self.navigationController pushViewController:firmOrderVC animated:YES];
    };
    
    attributesView.good_img = self.model.productImageList[0];
    if(self.model.stock == -1){
        attributesView.good_price = @"无限供应";
    }else{
        attributesView.good_price = [NSString stringWithFormat:@"库存 %lu 件",self.model.stock];
    }
    attributesView.goodsNameLbl.text = [NSString stringWithFormat:@"N%.2f",self.model.show_price];
    
    [attributesView showInView:self.navigationController.view];
}

-(NSMutableDictionary *)goodSpecDict{
    if (!_goodSpecDict) {
        _goodSpecDict = [NSMutableDictionary dictionary];
    }
    return _goodSpecDict;
}

-(void)goToCart{
    LZCartViewController *cartVC = [LZCartViewController new];
    [self.navigationController pushViewController:cartVC animated:YES];
}

- (void)requestAllOrder:(BOOL)more {
    
    self.param.productId = self.model.product_id;
//    NSCommonParam *param = [NSCommonParam new];
//    param.currentPage = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.currentPage]];
    
    WEAKSELF
    [GoodsDetailAPI getkProductCommentList:self.param success:^(NSCommentListModel * _Nullable result) {
        NSLog(@"获取商品评论列表成功");
//        weakSelf.messageTV.data = [NSMutableArray arrayWithArray:result.commentList];
        
        for (NSCommentItemModel *itemModel in result.commentList) {
            [weakSelf.messageTV.data addObject:[[NSMessageModel alloc] initWithUserName:itemModel.user_name imagePath:itemModel.user_avatar content:itemModel.content time:itemModel.create_time commentId:itemModel.comment_id userId:itemModel.user_id]];
        }
        self.messageView.size = CGSizeMake(kScreenWidth, result.commentList.count*GetScaleWidth(95)+GetScaleWidth(172));
        self.messageTV.size = CGSizeMake(kScreenWidth, result.commentList.count*GetScaleWidth(95));
        self.SV.contentSize = CGSizeMake(self.SV.bounds.size.width, self.height+GetScaleWidth(203)+GetScaleWidth(40)+(result.commentList.count)*GetScaleWidth(95));
        self.noMoreV.x = 0;
        self.noMoreV.y = CGRectGetMaxY(self.messageTV.frame);
        self.noMoreV.size = CGSizeMake(kScreenWidth, kScreenHeight -self.noMoreV.y);
        [weakSelf.messageTV reloadData];
    } failure:^(NSError *error) {
        NSLog(@"获取商品评论列表失败");
    }];

}

-(void)deleteCommentWithIndexPath:(NSIndexPath *)indexPath{
    
    self.deleteIndexPath = indexPath;
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除该评论?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

-(void)goToUserPageWithIndexPath:(NSIndexPath *)indexPath{
    DLog(@"跳转至个人页面");
    NSMessageModel *model = self.messageTV.data[indexPath.section];
    //跳转至个人页面
    UserPageVC *userPageVC = [UserPageVC new];
    [userPageVC setUpDataWithUserId:model.userId];
    [self.navigationController pushViewController:userPageVC animated:YES];
}

-(void)removeComment{
    DLog(@"removeComment");
    NSMessageModel *model = self.messageTV.data[self.deleteIndexPath.section];
    
    [GoodsDetailAPI delCommentWithParam:model.commentId success:^{
        DLog(@"删除评论成功");
        [self.messageTV.data removeObjectAtIndex:self.deleteIndexPath.section];
        
        self.messageView.size = CGSizeMake(kScreenWidth, self.messageTV.data.count*GetScaleWidth(95)+GetScaleWidth(172));
        self.messageTV.size = CGSizeMake(kScreenWidth, self.messageTV.data.count*GetScaleWidth(95));
        self.SV.contentSize = CGSizeMake(self.SV.bounds.size.width, self.height+GetScaleWidth(203)+GetScaleWidth(40)+(self.messageTV.data.count)*GetScaleWidth(95));
        self.noMoreV.y = CGRectGetMaxY(self.messageTV.frame);
        
        [self.messageTV reloadData];
    } faulre:^(NSError *error) {
        DLog(@"删除评论失败");
        DLog(@"error = %@",error);
    }];

}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { //
        [self removeComment];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];// 使当前文本框失去第一响应者的特权，就会回收键盘了
    
    return YES;
}

#pragma mark -      键盘即将跳出

-(void)didClickKeyboard:(NSNotification *)sender{
    
    CGFloat durition = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyboardRect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:durition animations:^{
        
        self.bottomV.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
        
    }];
    
}

#pragma mark -      当键盘即将消失

-(void)didKboardDisappear:(NSNotification *)sender{
    
    CGFloat duration = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.bottomV.transform = CGAffineTransformIdentity;
        
    }];
    
}

-(void)checkUserPage{
    DLog(@"跳转至个人页面");
    //跳转至个人页面
    UserPageVC *userPageVC = [UserPageVC new];
    [userPageVC setUpDataWithUserId:self.model.user_id];
    [self.navigationController pushViewController:userPageVC animated:YES];
}


@end

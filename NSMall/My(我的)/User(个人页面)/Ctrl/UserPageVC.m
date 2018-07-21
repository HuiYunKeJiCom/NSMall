//
//  UserPageVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import "UserPageVC.h"
#import "UserPageAPI.h"
#import "UserPageModel.h"
#import "UserHeaderV.h"
#import "ADOrderTopToolView.h"
#import "UIButton+Bootstrap.h"
#import "ThreePageSelectBar.h"
#import "NSGoodsVM.h"
#import "NSShopVM.h"
#import "SearchParam.h"
#import "HomePageAPI.h"
#import "SearchModel.h"


@interface UserPageVC ()
@property(nonatomic,strong)UserPageModel *userPageM;/* 个人页面模型 */
@property(nonatomic,strong)UIScrollView *totalSV;/* 总的滚动SV */
@property(nonatomic,strong)UserHeaderV *headerV;/* 头部View */
@property(nonatomic,strong)UIView *btnV;/* 按钮View */
//@property(nonatomic,strong)UIView * identificateV;/* 实名认证View */
@property(nonatomic,strong)UIView * listV;/* 列表View */
@property(nonatomic,strong)UIButton *classifyBtn;/* 发起聊天 按钮 */
@property(nonatomic,strong)UIButton *shopCartBtn;/* 加为好友 按钮 */
@property(nonatomic,strong)UIButton *QRBtn;/* 二维码 按钮 */

@property (nonatomic,strong)ThreePageSelectBar *pageSelectBar;//标签页选择bar
@property (nonatomic,strong)UIScrollView *mainScrollView;//主scrollView
@property (nonatomic,strong)NSMutableArray *shellViews;//shellViews数组

@property (nonatomic,strong)NSGoodsVM *goodsVM;//商品
@property (nonatomic,strong)NSShopVM *shopVM;//店铺
//@property (nonatomic,strong)ADGoodsParameterViewModel *parameterViewModel;//
//@property (nonatomic,strong)ADUserEvaluationViewModel *userEvaluationiViewModel;//
//@property (nonatomic,strong)ADRelatedGoodsViewModel *relatedGoodsViewModel;//

@property(nonatomic)NSInteger currentPage;/* 当前页数 */
@property(nonatomic,strong)SearchModel *searchModel;/* 搜索结果模型 */
@property(nonatomic,strong)NSString *userId;/* 查询的userId */
@end

@implementation UserPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _shellViews = [NSMutableArray array];
    _goodsVM = [[NSGoodsVM alloc]init];
    _shopVM = [[NSShopVM alloc]init];
    
    self.view.backgroundColor = KBGCOLOR;
    [self createUI];
//    [self setUpDataWithUserId:nil];
    [self setUpNavTopView];
    [self makeConstraints];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:NSLocalizedString(@"personal center", nil)];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

-(void)createUI{
    self.currentPage = 1;
    
    self.totalSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopBarHeight, kScreenWidth, kScreenHeight-TopBarHeight)];
    [self.view addSubview:self.totalSV];
    self.totalSV.showsVerticalScrollIndicator = NO;
//    self.totalSV.backgroundColor = kRedColor;
    
    
    //头部
    self.headerV = [[UserHeaderV alloc]init];
    self.headerV.backgroundColor = kWhiteColor;
    [self.totalSV addSubview:self.headerV];
    self.headerV.x = 0;
    self.headerV.y = 0;
    self.headerV.size = CGSizeMake(kScreenWidth, GetScaleWidth(204));
    
    self.headerV.editBtnClickBlock = ^{
        DLog(@"点击编辑");
    };
    self.headerV.shareBtnClickBlock = ^{
        DLog(@"点击分享");
    };
    
    //按钮View
    self.btnV = [[UIView alloc]init];
    self.btnV.backgroundColor = kWhiteColor;
    [self.totalSV addSubview:self.btnV];
    self.btnV.x = 0;
    self.btnV.y = CGRectGetMaxY(self.headerV.frame)+GetScaleWidth(10);
    self.btnV.size = CGSizeMake(kScreenWidth, GetScaleWidth(90));
    
    float itemWidth = GetScaleWidth(70);
    float spaceWidth = (kScreenWidth-3*GetScaleWidth(70))/4.0;
    self.classifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.classifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.classifyBtn setImageWithTitle:IMAGE(@"mypage_ico_create_chat")
                              withTitle:NSLocalizedString(@"launch chat", nil) position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.btnV addSubview:self.classifyBtn];
    
    self.classifyBtn.x = spaceWidth;
    self.classifyBtn.y = -GetScaleWidth(10);
    self.classifyBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.classifyBtn addTarget:self action:@selector(classifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.shopCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shopCartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.shopCartBtn setImageWithTitle:IMAGE(@"mypage_ico_add_friend")
                              withTitle:NSLocalizedString(@"be friend", nil) position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.btnV addSubview:self.shopCartBtn];
    self.shopCartBtn.x = itemWidth+2*spaceWidth;
    self.shopCartBtn.y = -GetScaleWidth(10);
    self.shopCartBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.shopCartBtn addTarget:self action:@selector(shopCartButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.QRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.QRBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.QRBtn setImageWithTitle:IMAGE(@"mypage_ico_qrcode")
                        withTitle:NSLocalizedString(@"QR code", nil) position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.btnV addSubview:self.QRBtn];
    self.QRBtn.x = itemWidth*2+3*spaceWidth;
    self.QRBtn.y = -GetScaleWidth(10);
    self.QRBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.QRBtn addTarget:self action:@selector(QRButtonClick) forControlEvents:UIControlEventTouchUpInside];

//    //实名认证View
//    self.identificateV = [[UIView alloc]init];
//    self.identificateV.backgroundColor = kWhiteColor;
//    [self.totalSV addSubview:self.identificateV];
//    self.identificateV.x = 0;
//    self.identificateV.y = CGRectGetMaxY(self.btnV.frame)+GetScaleWidth(10);
//    self.identificateV.size = CGSizeMake(kScreenWidth, GetScaleWidth(48));
//
//    UITapGestureRecognizer *viewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(identificateClick)];
//    // 2. 将点击事件添加到imageView上
//    [self.identificateV addGestureRecognizer:viewTapGestureRecognizer];
//
//    UIImageView *certificationIV = [[UIImageView alloc]init];
//    certificationIV.backgroundColor = [UIColor purpleColor];
//    [self.identificateV addSubview:certificationIV];
//    certificationIV.x = GetScaleWidth(18);
//    certificationIV.y = GetScaleWidth(15);
//    certificationIV.size = CGSizeMake(GetScaleWidth(23), GetScaleWidth(19));
//
//    UILabel *certificationL = [[UILabel alloc]init];
//    certificationL.textColor = kBlackColor;
//    certificationL.font = UISystemFontSize(14);
//    certificationL.text = @"实名认证";
//    [self.identificateV addSubview:certificationL];
//    certificationL.x = GetScaleWidth(48);
//    certificationL.y = GetScaleWidth(18);
//    certificationL.size = CGSizeMake(GetScaleWidth(53), GetScaleWidth(13));
//
//    UIImageView *arrowIV = [[UIImageView alloc]init];
//    arrowIV.image = IMAGE(@"my_ico_right_arrow");
//    [self.identificateV addSubview:arrowIV];
//    arrowIV.x = kScreenWidth - GetScaleWidth(19)-GetScaleWidth(9);
//    arrowIV.y = GetScaleWidth(19);
//    arrowIV.size = CGSizeMake(GetScaleWidth(5), GetScaleWidth(9));
    
    self.listV = [[UIView alloc]init];
    self.listV.backgroundColor = kWhiteColor;
    [self.totalSV addSubview:self.listV];
    
    self.listV.x = 0;
    self.listV.y = GetScaleWidth(314);
    
    
//    self.listV.backgroundColor = kRedColor;
    
    
}


- (void)buildUI{
    //副标题
    _pageSelectBar = [[ThreePageSelectBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) options:@[NSLocalizedString(@"goods", nil),NSLocalizedString(@"shop", nil),NSLocalizedString(@"comment", nil)] selectBlock:^(NSString *option, NSInteger index) {
        _mainScrollView.contentOffset = CGPointMake((_mainScrollView.contentSize.width/3) * index, 0);
        if(index == 0){
            [self searchWithType:@"0" andUserId:self.userId];
        }else if(index == 1){
            [self searchWithType:@"1" andUserId:self.userId];
        }
    }];
    //    _pageSelectBar.backgroundColor = [UIColor redColor];
    _pageSelectBar.top = 0;
    _pageSelectBar.left = 0;
    [self.listV addSubview:_pageSelectBar];
    
    _mainScrollView = [UIScrollView new];
    _mainScrollView.size = CGSizeMake(kScreenWidth, self.listV.height);
    //    AppHeight - _pageSelectBar.bottom
    _mainScrollView.left = 0;
    _mainScrollView.top = _pageSelectBar.bottom;
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.width * 3, 0);
    _mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.alwaysBounceHorizontal = YES;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.listV addSubview:_mainScrollView];
    
    for (int i = 0; i < 3; i++) {
        UIView *shellView = [[UIView alloc]init];
        shellView.size = _mainScrollView.size;
        shellView.top = 0;
        shellView.left = _mainScrollView.width * i;
        shellView.backgroundColor = [UIColor whiteColor];
        [_mainScrollView addSubview:shellView];
        [_shellViews addObject:shellView];
    }
    
    _goodsVM.goodsTV.frame = ((UIView *)_shellViews[0]).bounds;
    [(UIView *)_shellViews[0] addSubview:_goodsVM.goodsTV];

    _shopVM = [[NSShopVM alloc]init];
    _shopVM.shopTV.frame = ((UIView *)_shellViews[1]).bounds;
    [(UIView *)_shellViews[1] addSubview:_shopVM.shopTV];

// _userEvaluationiViewModel.userEvaluationListView.frame = ((UIView *)_shellViews[2]).bounds;
//    [(UIView *)_shellViews[2] addSubview:_userEvaluationiViewModel.userEvaluationListView];

}

-(void)setUpDataWithUserId:(NSString *)userId{
    
    self.userId = userId;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    [UserPageAPI getUserById:userId success:^(UserPageModel * _Nullable result) {
        DLog(@"获取指定用户信息成功");
        self.userPageM = result;
        self.headerV.userPageM = self.userPageM;
        dispatch_group_leave(group);
    } faulre:^(NSError *error) {
        DLog(@"获取指定用户信息失败");
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //请求完成后的处理、
        NSLog(@"完成");
        [self searchWithType:@"0" andUserId:userId];
    });
    
}

-(void)searchWithType:(NSString *)searchType andUserId:(NSString *)userId{
    
    SearchParam *param = [SearchParam new];
    
    param.currentPage = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.currentPage]];
    param.searchType = searchType;
    param.sortType = @"ASC";
    param.userId = userId;
    
    WEAKSELF
    [HomePageAPI searchProductOrShop:param success:^(SearchModel *result) {
        NSLog(@"获取列表成功");
        if([searchType isEqualToString:@"0"]){
            weakSelf.goodsVM.goodsTV.data = [NSMutableArray arrayWithArray:result.productList];
            weakSelf.listV.size = CGSizeMake(kScreenWidth, GetScaleWidth(40)+result.productList.count*GetScaleWidth(265));
            [self buildUI];
            [weakSelf.goodsVM reloadData];
            
        }else if([searchType isEqualToString:@"1"]){
            weakSelf.shopVM.shopTV.data = [NSMutableArray arrayWithArray:result.storeList];
            self.listV.size = CGSizeMake(kScreenWidth, GetScaleWidth(40)+result.storeList.count*GetScaleWidth(126));
            [self buildUI];
            [self.shopVM.shopTV reloadData];
        }
        
        
        self.totalSV.contentSize = CGSizeMake(0, self.listV.size.height+GetScaleWidth(352));
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"获取列表失败");
        [self cutCurrentPage];
    }];
}



- (void)makeConstraints {
    
//    WEAKSELF
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)classifyButtonClick {
    DLog(@"点击发起聊天");
}

- (void)shopCartButtonClick {
    DLog(@"点击加为好友");
}

- (void)QRButtonClick {
    DLog(@"点击二维码");
}

- (void)identificateClick {
    DLog(@"实名认证");
}

-(void)cutCurrentPage{
    if(self.currentPage != 1){
        self.currentPage -= 1;
    }
}

@end

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
#import "NSCommentVM.h"
#import "SearchParam.h"
#import "HomePageAPI.h"
#import "SearchModel.h"
#import "NSMessageAPI.h"
#import "ChatViewController.h"
#import "ADLUpdateUserInformCtrl.h"
#import "NSUserCommentParam.h"
#import "GoodsDetailAPI.h"
#import "NSGoodsShowCellTest.h"
#import "NSGoodsDetailVC.h"

@interface UserPageVC ()<EMContactManagerDelegate,UIScrollViewDelegate,NSCommentVMDelegate,NSGoodsVMDelegate>
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
@property(nonatomic,strong)NSCommentVM *commentVM;/* 评论 */

@property(nonatomic)NSInteger currentPage;/* 当前页数 */
@property(nonatomic,strong)SearchModel *searchModel;/* 搜索结果模型 */
@property(nonatomic,strong)NSString *userId;/* 查询的userId */
@property(nonatomic,strong)UIView *shareView;/* 分享View */
@property(nonatomic,strong)UIImageView * scanView;
@property(nonatomic,strong)UIView *bgView;/* 二维码背景图 */
@end

@implementation UserPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _shellViews = [NSMutableArray array];
    
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    self.view.backgroundColor = KBGCOLOR;
    [self createUI];
    [self buildUI];
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
    
    
    
    WEAKSELF
    self.headerV.editBtnClickBlock = ^{
        DLog(@"点击编辑");
        ADLUpdateUserInformCtrl *userInfoVC = [ADLUpdateUserInformCtrl new];
        [weakSelf.navigationController pushViewController:userInfoVC animated:YES];
    };
    self.headerV.shareBtnClickBlock = ^{
        DLog(@"点击分享");
        [weakSelf QRButtonClick];
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
        }else if(index == 2){
            [self getCommentByUserId:self.userId];
        }
    }];
    //    _pageSelectBar.backgroundColor = [UIColor redColor];
    _pageSelectBar.top = 0;
    _pageSelectBar.left = 0;
    [self.listV addSubview:_pageSelectBar];
    
    _mainScrollView = [UIScrollView new];
    _mainScrollView.size = CGSizeMake(kScreenWidth, kScreenHeight);
    //    AppHeight - _pageSelectBar.bottom
    _mainScrollView.left = 0;
    _mainScrollView.delegate = self;
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
    
    _goodsVM = [[NSGoodsVM alloc]init];
//    _goodsVM.goodsTV.backgroundColor = [UIColor greenColor];
    _goodsVM.delegate = self;
    _goodsVM.goodsTV.frame = ((UIView *)_shellViews[0]).bounds;
    [(UIView *)_shellViews[0] addSubview:_goodsVM.goodsTV];

    _shopVM = [[NSShopVM alloc]init];
//    _shopVM.shopTV.backgroundColor = kRedColor;
    _shopVM.shopTV.frame = ((UIView *)_shellViews[1]).bounds;
    [(UIView *)_shellViews[1] addSubview:_shopVM.shopTV];

    _commentVM = [[NSCommentVM alloc]init];
    _commentVM.delegate = self;
    //    _shopVM.shopTV.backgroundColor = kRedColor;
    _commentVM.commentTV.frame = ((UIView *)_shellViews[2]).bounds;
    [(UIView *)_shellViews[2] addSubview:_commentVM.commentTV];
}

-(void)setUpDataWithUserId:(NSString *)userId{
    
    self.userId = userId;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    [UserPageAPI getUserById:userId success:^(UserPageModel * _Nullable result) {
        DLog(@"获取指定用户信息成功");
        self.userPageM = result;
        self.headerV.userPageM = self.userPageM;
        UserModel *userModel = [UserModel modelFromUnarchive];
        if([self.userPageM.user_id isEqualToString:userModel.user_id]){
            self.headerV.editBtn.alpha = 1.0;
        }else{
            self.headerV.editBtn.alpha = 0.0;
        }
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
            [weakSelf.goodsVM.goodsTV.data removeAllObjects];
            weakSelf.goodsVM.goodsTV.data = [NSMutableArray arrayWithArray:result.productList];
            weakSelf.listV.size = CGSizeMake(kScreenWidth, GetScaleWidth(40)+result.productList.count*GetScaleWidth(265));
//            [self buildUI];
            weakSelf.goodsVM.goodsTV.height = weakSelf.listV.height;
            weakSelf.mainScrollView.height = weakSelf.listV.height;
            [weakSelf.goodsVM.goodsTV reloadData];
            self.totalSV.contentSize = CGSizeMake(0, self.listV.size.height+GetScaleWidth(300));
        }else if([searchType isEqualToString:@"1"]){
            [weakSelf.shopVM.shopTV.data removeAllObjects];
            weakSelf.shopVM.shopTV.data = [NSMutableArray arrayWithArray:result.storeList];
            self.listV.size = CGSizeMake(kScreenWidth, GetScaleWidth(80)+result.storeList.count*GetScaleWidth(200));
            weakSelf.shopVM.shopTV.height = weakSelf.listV.height;
            weakSelf.mainScrollView.height = weakSelf.listV.height;
    
//            [self buildUI];
            [self.shopVM.shopTV reloadData];
            self.totalSV.contentSize = CGSizeMake(0, self.listV.size.height+GetScaleWidth(290));
        }
  
    } failure:^(NSError *error) {
        NSLog(@"获取列表失败");
        [self cutCurrentPage];
    }];
}

-(void)getCommentByUserId:(NSString *)userId{
    [self.commentVM.commentTV.data removeAllObjects];
    NSUserCommentParam *param = [NSUserCommentParam new];
    param.currentPage = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.currentPage]];
    param.userId = userId;
    WEAKSELF
    [UserPageAPI getCommentByUser:param success:^(NSCommentListModel * _Nullable result) {
        weakSelf.commentVM.commentTV.data = [NSMutableArray arrayWithArray:result.commentList];
        self.listV.size = CGSizeMake(kScreenWidth, GetScaleWidth(80)+result.commentList.count*GetScaleWidth(120));
        weakSelf.commentVM.commentTV.height = weakSelf.listV.height;
        weakSelf.mainScrollView.height = weakSelf.listV.height;
        [self.commentVM.commentTV reloadData];
        self.totalSV.contentSize = CGSizeMake(0, self.listV.size.height+GetScaleWidth(290));
    } faulre:^(NSError *error) {
        
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
    UserModel *userModel = [UserModel modelFromUnarchive];
    if([userModel.user_id isEqualToString:self.userPageM.user_id]){
        [Common AppShowToast:@"不能跟自己聊天"];
    }else{
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.userPageM.hx_user_name conversationType:EMConversationTypeChat];
        chatController.title = self.userPageM.nick_name;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

- (void)shopCartButtonClick {
    DLog(@"点击加为好友");
    
    UserModel *userModel = [UserModel modelFromUnarchive];
    if([userModel.user_id isEqualToString:self.userPageM.user_id]){
        [Common AppShowToast:@"不能加自己为好友"];
    }else{
        
        NSString *msg = [userModel.hx_user_name stringByAppendingString:NSLocalizedString(@"add friend with you", nil)];
        EMError *error = [[EMClient sharedClient].contactManager addContact:self.userPageM.hx_user_name message:msg];
        
//        [NSMessageAPI addFriendWithParam:self.userPageM.hx_user_name success:^{
//
//        } faulre:^(NSError *error) {
////            [Common AppShowToast:NSLocalizedString(@"add friends fail", nil)];
//        }];
        
        if (!error) {
            [Common AppShowToast:NSLocalizedString(@"add friends success", nil)];
            [NSMessageAPI acceptFriendWithParam:self.userPageM.hx_user_name success:^{
                DLog(@"添加好友成功");
            } faulre:^(NSError *error) {
            }];
        }else{
            DLog(@"添加好友error = %@",error.mj_keyValues);
            [Common AppShowToast:NSLocalizedString(@"add friends fail", nil)];
        }
    }
}

- (void)QRButtonClick {
    DLog(@"点击二维码");
    
    UIWindow *window = [[UIApplication  sharedApplication ]keyWindow ];
    NSArray *viewArray = [window subviews];
    for (UIView *view in viewArray) {
        if(view.tag == 100){
            self.shareView = view;
        }else if(view.tag == 200){
            self.bgView = view;
        }
    }
    
    for (UIView *view in [self.bgView subviews]) {
        if(view.tag == 20){
            self.scanView = (UIImageView *)view;
        }else if(view.tag == 30){
            UIButton *btn = (UIButton *)view;
            [btn addTarget:self action:@selector(hideQRCode) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self showQRCode:self.userPageM.user_id];
}

- (void)identificateClick {
    DLog(@"实名认证");
}

-(void)cutCurrentPage{
    if(self.currentPage != 1){
        self.currentPage -= 1;
    }
}

-(void)showQRCode:(NSString *)userID{
    
    self.shareView.alpha = 0.9;
    self.bgView.alpha = 1;
    
    [self setUpFilter:[NSString stringWithFormat:@"hid:%@",userID]];
}

-(void)hideQRCode{
    DLog(@"隐藏二维码");
    self.shareView.alpha = 0;
    self.bgView.alpha = 0;
}

-(void)setUpFilter:(NSString*)string {
    /*
     注意:
     1.生成二维码时, 不建议让二维码保存过多数据, 因为数据越多, 那么二维码就越密集,那么扫描起来就越困难
     2.二维码有三个定位点, 着三个定位点不能被遮挡, 否则扫描不出来
     3.二维码即便缺失一部分也能正常扫描出结果, 但是需要注意, 这个缺失的范围是由限制的, 如果太多那么也扫面不出来
     */
    // 1.创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.还原滤镜默认属性
    [filter setDefaults];
    // 3.将需要生成二维码的数据转换为二进制
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 4.给滤镜设置数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 5.生成图片
    CIImage *qrcodeImage =  [filter outputImage];
    
    // 6.显示图片
    
    self.scanView.image = [self createNonInterpolatedUIImageFormCIImage:qrcodeImage withSize:120];
    
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *qrCodeImage = [UIImage imageWithCGImage:scaledImage];
    return qrCodeImage;
}

#pragma mark - 好友申请处理结果回调
/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    DLog(@"添加好友同意");
    //    [NSMessageAPI acceptFriendWithParam:self.friendName success:^{
    //        DLog(@"添加好友成功");
    //    } faulre:^(NSError *error) {
    //    }];
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    NSLog(@"%@",aUsername);
    NSString *message = [NSString stringWithFormat:@"%@ 拒绝了你的好友请求",aUsername];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友添加消息" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
//    DLog(@"index = %lu",index);
//    _mainScrollView.contentOffset = CGPointMake((_mainScrollView.contentSize.width/3) * index, 0);
//    if(index == 0){
//        [self searchWithType:@"0" andUserId:self.userId];
//    }else if(index == 1){
//        [self searchWithType:@"1" andUserId:self.userId];
//    }else if(index == 2){
//        //            [self searchWithType:@"1" andUserId:self.userId];
//    }
}

-(void)delCommentWith:(NSIndexPath *)indexPath{
    if(self.commentVM.commentTV.data.count > indexPath.section){
        NSCommentItemModel *model = self.commentVM.commentTV.data[indexPath.section];
        [GoodsDetailAPI delCommentWithParam:model.comment_id success:^{
            DLog(@"删除评论成功");
            [self getCommentByUserId:self.userId];
        } faulre:^(NSError *error) {
            
        }];
    }
    
}

-(void)didSelectWith:(NSIndexPath *)indexPath{
    NSGoodsShowCellTest *cell = [self.goodsVM.goodsTV cellForRowAtIndexPath:indexPath];
//    DLog(@"product_id = %@",cell.productModel.product_id);
    NSGoodsDetailVC *detailVC = [NSGoodsDetailVC new];
    [detailVC getDataWithProductID:cell.productModel.product_id andCollectNum:cell.productModel.favorite_number];
    [self.navigationController pushViewController:detailVC animated:YES];

}

-(void)likeClickAtIndexPath:(NSIndexPath *)indexPath{
    NSGoodsShowCellTest *cell = [self.goodsVM.goodsTV cellForRowAtIndexPath:indexPath];
    [HomePageAPI changeProductLikeState:cell.productModel.product_id success:^(NSLikeModel *model) {
        DLog(@"点赞成功");
//        DLog(@"model = %@",model.mj_keyValues);
        if(cell.isLike){
            [cell.likeBtn setImageWithTitle:IMAGE(@"ico_like") withTitle:@"喜欢" position:@"left" font:UISystemFontSize(14) forState:UIControlStateNormal];
            cell.isLike = NO;
        }else{
            [cell.likeBtn setImageWithTitle:IMAGE(@"home_ico_like_press") withTitle:[NSString stringWithFormat:@"喜欢(%@)",[NSNumber numberWithInteger:model.like_number]] position:@"left" font:UISystemFontSize(14) forState:UIControlStateNormal];
            cell.isLike = YES;
        }
        
    } failure:^(NSError *error) {
        DLog(@"点赞失败");
    }];
}

-(void)showGoodsQRCode:(NSIndexPath *)indexPath{
//    DLog(@"分享");
    [self QRButtonClick];
    self.shareView.alpha = 0.9;
    self.bgView.alpha = 1;
    NSGoodsShowCellTest *cell = [self.goodsVM.goodsTV cellForRowAtIndexPath:indexPath];
    //    NSString *goodsID = cell.productModel.product_id;
    [self setUpFilter:[NSString stringWithFormat:@"gid:%@",cell.productModel.product_id]];
}

@end

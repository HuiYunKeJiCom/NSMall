//
//  NSCollectionListVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/18.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCollectionListVC.h"
#import "ProductListModel.h"
#import "ProductListItemModel.h"
#import "NSGoodsShowCellTest.h"
#import "UserInfoAPI.h"
#import "ADOrderTopToolView.h"
#import "NSCommonParam.h"
#import "NSGoodsDetailVC.h"
#import "HomePageAPI.h"
#import "UserPageVC.h"
#import "UIButton+Bootstrap.h"

@interface NSCollectionListVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *goodsTable;
@property(nonatomic)NSInteger currentPage;/* 当前页数 */
@property(nonatomic,strong)UIView *shareView;/* 分享View */
@property(nonatomic,strong)UIImageView * scanView;
@property(nonatomic,strong)UIView *bgView;/* 二维码背景图 */
@end

@implementation NSCollectionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.goodsTable];
    [self setUpNavTopView];
    [self makeConstraints];
    self.currentPage = 1;
    [self requestAllOrder:NO];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:NSLocalizedString(@"my collection", nil)];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    [self.goodsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight+1);
    }];
    
}

- (void)requestAllOrder:(BOOL)more {
    [self.goodsTable updateLoadState:more];
    
    NSCommonParam *param = [NSCommonParam new];
    param.currentPage = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.currentPage]];
    
    WEAKSELF
    [UserInfoAPI getMyCollectionList:param success:^(ProductListModel * _Nullable result) {
        NSLog(@"获取我的收藏成功");
        weakSelf.goodsTable.data = [NSMutableArray arrayWithArray:result.productList];
        [self.goodsTable updatePage:more];
        self.goodsTable.noDataView.hidden = self.goodsTable.data.count;
        [self.goodsTable reloadData];
    } failure:^(NSError *error) {
        NSLog(@"获取我的收藏失败");
        [self cutCurrentPag];
    }];
}

- (BaseTableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.isLoadMore = YES;
        _goodsTable.isRefresh = YES;
        _goodsTable.delegateBase = self;
        _goodsTable.backgroundColor = KBGCOLOR;
        [_goodsTable registerClass:[NSGoodsShowCellTest class] forCellReuseIdentifier:@"NSGoodsShowCellTest"];
        
    }
    return _goodsTable;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return GetScaleWidth(0);
    }else{
        //设置间隔高度
        return GetScaleWidth(15);
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(5))];
    sectionView.backgroundColor = kGreyColor;
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsTable.data.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return GetScaleWidth(191);
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSGoodsShowCellTest *cell = [tableView dequeueReusableCellWithIdentifier:@"NSGoodsShowCellTest"];
    if (self.goodsTable.data.count > indexPath.section) {
        ProductListItemModel *model = self.goodsTable.data[indexPath.section];
        //        NSLog(@"model = %@",model.mj_keyValues);
        cell.productModel = model;
        WEAKSELF
        cell.likeBtnClickBlock = ^{
            [weakSelf likeClickAtIndexPath:indexPath];
        };
        cell.commentBtnClickBlock = ^{
            [weakSelf tableView:self.goodsTable didSelectRowAtIndexPath:indexPath];
        };
        cell.shareBtnClickBlock = ^{
            [weakSelf showGoodsQRCode:indexPath];
        };
        cell.headerClickBlock = ^{
            [weakSelf goToUserPageWithIndexPath:indexPath];
        };
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if(indexPath.section != 0){
    DLog(@"跳转到详情页");
    NSGoodsShowCellTest *cell = [self.goodsTable cellForRowAtIndexPath:indexPath];
    DLog(@"product_id = %@",cell.productModel.product_id);
    NSGoodsDetailVC *detailVC = [NSGoodsDetailVC new];
    [detailVC getDataWithProductID:cell.productModel.product_id andCollectNum:cell.productModel.favorite_number];
    [self.navigationController pushViewController:detailVC animated:YES];
    //    }
}

- (void)baseTableVIew:(BaseTableView *)tableView refresh:(BOOL)flag {
    [self requestAllOrder:NO];
}

- (void)baseTableView:(BaseTableView *)tableView loadMore:(BOOL)flag {
    self.currentPage += 1;
    [self requestAllOrder:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cutCurrentPag{
    if(self.currentPage != 1){
        self.currentPage -= 1;
    }
}

-(void)likeClickAtIndexPath:(NSIndexPath *)indexPath{
    NSGoodsShowCellTest *cell = [self.goodsTable cellForRowAtIndexPath:indexPath];
    [HomePageAPI changeProductLikeState:cell.productModel.product_id success:^(NSLikeModel *model) {
        DLog(@"点赞成功");
        DLog(@"model = %@",model.mj_keyValues);
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
            [btn addTarget:self action:@selector(hideGoodsQRCode) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.shareView.alpha = 0.9;
    self.bgView.alpha = 1;
    NSGoodsShowCellTest *cell = [self.goodsTable cellForRowAtIndexPath:indexPath];
    //    NSString *goodsID = cell.productModel.product_id;
    [self setUpFilter:[NSString stringWithFormat:@"gid:%@",cell.productModel.product_id]];
}

-(void)hideGoodsQRCode{
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

-(void)goToUserPageWithIndexPath:(NSIndexPath *)indexPath{
    DLog(@"跳转至个人页面");
    NSGoodsShowCellTest *cell = [self.goodsTable cellForRowAtIndexPath:indexPath];
    //跳转至个人页面
    UserPageVC *userPageVC = [UserPageVC new];
    [userPageVC setUpDataWithUserId:cell.productModel.user_id];
    [self.navigationController pushViewController:userPageVC animated:YES];
}



@end

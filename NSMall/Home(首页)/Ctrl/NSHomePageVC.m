//
//  NSHomePageVC.m
//  NSMall
//
//  Created by apple on 2018/4/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSHomePageVC.h"
#import "LoginAPI.h"
#import "HomePageAPI.h"
#import "NSGoodsShowCell.h"
#import "ProductListItemModel.h"
#import "DCHomeTopToolView.h"  //头部
#import "NSCarouselView.h"//轮播图
#import "AdvertItemModel.h"
#import "NSFunctionCell.h"
#import "UIButton+Bootstrap.h"
#import "NSOrderListVC.h"
#import "LZCartViewController.h"
#import "NSGoodsDetailVC.h"
#import "NSSortVC.h"
#import "HistoryVC.h"
#import "LZCartViewController.h"
#import "NSGoodsShowCellTest.h"
#import "NSCreateQRCodeVC.h"
#import "ADLScanningController.h"

@interface NSHomePageVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>

@property (nonatomic,strong)BaseTableView *tableView;//
/* 顶部工具View */
@property (nonatomic, strong) DCHomeTopToolView *topToolView;
@property(nonatomic,strong)NSMutableArray *imageGroupArray;/* 广告图路径数组 */
@property(nonatomic,strong)NSMutableDictionary *imageDict;/* 图片字典 */
@property(nonatomic,strong)UIView *shareView;/* 分享View */
@property(nonatomic,strong)UIImageView * scanView;
@property(nonatomic,strong)UIView *bgView;/* 二维码背景图 */
@end

@implementation NSHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = kWhiteColor;
    [self requestAllOrder:NO];
    [self buildUI];
    
    [self setUpNavTopView];
    
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[[UIApplication  sharedApplication ]keyWindow ] addSubview : self.shareView];
    self.shareView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9];
    self.shareView.alpha = 0;
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = kWhiteColor;
    [[[UIApplication  sharedApplication ]keyWindow ] addSubview:self.bgView];
    self.bgView.x = 30;
    self.bgView.y = kScreenHeight*0.25;
    self.bgView.size = CGSizeMake(kScreenWidth-60, kScreenHeight*0.5);
    self.bgView.alpha = 0;
    
    self.scanView = [[UIImageView alloc] init];
    self.scanView.layer.cornerRadius = 4;
    self.scanView.layer.masksToBounds = YES;
    self.scanView.backgroundColor = [UIColor greenColor];
    self.scanView.x = kScreenWidth*0.5-95;
    self.scanView.y = kScreenHeight*0.5*0.55-105;
    self.scanView.size = CGSizeMake(150, 150);
    //    self.scanView.center = self.bgView.center;
    [self.bgView addSubview:self.scanView];

    UIButton *closeBtn = [[UIButton alloc]init];
    closeBtn.backgroundColor = kRedColor;
    closeBtn.x = kScreenWidth-60-10;
    closeBtn.y = -10;
    closeBtn.size = CGSizeMake(20, 20);
    [self.bgView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(hideGoodsQRCode) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[DCHomeTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    [self.navigationController setNavigationBarHidden:YES];
    WEAKSELF
    _topToolView.rightItemClickBlock = ^{
        NSLog(@"点击了首页扫一扫");
        ADLScanningController *scanVC = [ADLScanningController new];
        [weakSelf.navigationController pushViewController:scanVC animated:YES];
    };
    _topToolView.searchButtonClickBlock = ^{
        NSLog(@"点击了首页搜索");
        HistoryVC *hVC = [HistoryVC new];
        [weakSelf.navigationController pushViewController:hVC animated:YES];
    };
    [self.view addSubview:_topToolView];

}

- (void)buildUI{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, TopBarHeight, kScreenWidth, AppHeight - TopBarHeight-TabBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = KBGCOLOR;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.isLoadMore = YES;
    _tableView.isRefresh = YES;
    _tableView.delegateBase = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    _tableView.estimatedRowHeight = GetScaleWidth(259);
    [_tableView registerClass:[NSGoodsShowCell class] forCellReuseIdentifier:@"NSGoodsShowCell"];
    [_tableView registerClass:[NSGoodsShowCellTest class] forCellReuseIdentifier:@"NSGoodsShowCellTest"];
}

- (void)requestAllOrder:(BOOL)more {
    [self.tableView updateLoadState:more];
    WEAKSELF
    
    //异步加载数据
    
    [self.imageGroupArray removeAllObjects];
    [self.imageDict removeAllObjects];
    
    //    dispatch_queue_t queue = dispatch_queue_create("HomePageDataRequest", DISPATCH_QUEUE_CONCURRENT);
    
//    __block NSInteger requestCount = 0;
//
//    //第一个网络请求
//    [HomePageAPI getProductList:nil success:^(ProductListModel * _Nullable result) {
//        NSLog(@"获取产品列表成功");
//        weakSelf.tableView.data = [NSMutableArray arrayWithArray:result.productList];
//        [weakSelf.tableView updatePage:more];
//        weakSelf.tableView.noDataView.hidden = weakSelf.tableView.data.count;
//        //            [weakSelf.tableView reloadData];
//        requestCount++;
//        if (self.complete) {
//            self.complete();
//        }
//
//    } failure:^(NSError *error) {
//        NSLog(@"获取产品列表失败");
//    }];
//
//    //第二个网络请求
//    [HomePageAPI getHomePageAdvertInfro:@{@"advertCode":@"indexHeadAdvert"} success:^(AdvertListModel * _Nullable result) {
//        NSLog(@"count = %lu",result.advertList.count);
//        NSLog(@"获取广告数据成功");
//        for(AdvertItemModel *model in result.advertList){
//            //            NSLog(@"path = %@",model.pic_img);
//            [weakSelf.imageGroupArray addObject:model.pic_img];
//            [weakSelf.imageDict setValue:model forKey:model.pic_img];
//        }
//        //            [weakSelf.tableView reloadData];
//
//        requestCount++;
//        if (self.complete) {
//            self.complete();
//        }
//
//    } failure:^(NSError *error) {
//        NSLog(@"获取广告数据失败");
//    }];
//
//    self.complete = ^{
//        //请求网络的数量等于3表示三个网络请求已完成
//        if (requestCount == 2) {
//            //在这里 进行请求后的方法，回到主线程
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //更新UI操作
//                [weakSelf.tableView reloadData];
//            });
//        }
//    };
    
    
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);

    [HomePageAPI getProductList:nil success:^(ProductListModel * _Nullable result) {
        NSLog(@"获取产品列表成功");
        weakSelf.tableView.data = [NSMutableArray arrayWithArray:result.productList];
        [weakSelf.tableView updatePage:more];
        weakSelf.tableView.noDataView.hidden = weakSelf.tableView.data.count;
        //            [weakSelf.tableView reloadData];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        NSLog(@"获取产品列表失败");
    }];

    dispatch_group_enter(group);

    [HomePageAPI getHomePageAdvertInfro:@{@"advertCode":@"indexHeadAdvert"} success:^(AdvertListModel * _Nullable result) {
//        NSLog(@"count = %lu",result.advertList.count);
//        NSLog(@"获取广告数据成功");
        for(AdvertItemModel *model in result.advertList){
            //            NSLog(@"path = %@",model.pic_img);
            [weakSelf.imageGroupArray addObject:model.pic_img];
            [weakSelf.imageDict setValue:model forKey:model.pic_img];
        }
        //            [weakSelf.tableView reloadData];
        //处理数据
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        NSLog(@"获取广告数据失败");
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //请求完成后的处理、
        NSLog(@"完成");
        [weakSelf.tableView reloadData];
    });
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableView.data.count;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
////        return GetScaleWidth(259);
////        return UITableViewAutomaticDimension;
//        return [tableView fd_heightForCellWithIdentifier:@"NSGoodsShowCellTest" cacheByIndexPath:indexPath configuration:^(NSGoodsShowCellTest *cell) {
//            [self configureCell:cell atIndexPath:indexPath];
//        }];
////    }
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return GetScaleWidth(160+73+6+39);
    }else{
        //设置间隔高度
        return GetScaleWidth(6);
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        NSCarouselView *carouselView = [[NSCarouselView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,GetScaleWidth(160+73+6+39))];
//        carouselView.backgroundColor = kRedColor;
        carouselView.imageGroupArray = self.imageGroupArray;
        carouselView.classifyBtnClickBlock = ^{
            DLog(@"点击了分类");
            NSSortVC *sortVC = [NSSortVC new];
            [self.navigationController pushViewController:sortVC animated:YES];
        };
        carouselView.QRBtnClickBlock = ^{
            DLog(@"点击了二维码");
            NSCreateQRCodeVC *qrCodeVC = [NSCreateQRCodeVC new];
//            qrCodeVC.QRString = @"shshfeihashasds";
            [self.navigationController pushViewController:qrCodeVC animated:YES];
        };
        carouselView.shopCartBtnClickBlock = ^{
            DLog(@"点击了购物车");
            LZCartViewController *cartVC = [LZCartViewController new];
            [self.navigationController pushViewController:cartVC animated:YES];
        };
        carouselView.myOrderBtnClickBlock = ^{
            DLog(@"点击了我的订单");
            NSOrderListVC *orderListVC = [NSOrderListVC new];
            [self.navigationController pushViewController:orderListVC animated:YES];
        };
        return carouselView;
    }else{
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(6))];
        sectionView.backgroundColor = kClearColor;
        return sectionView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;//把高度设置很小，效果可以看成footer的高度等于0
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSGoodsShowCellTest *cell = [tableView dequeueReusableCellWithIdentifier:@"NSGoodsShowCellTest"];
        if (!cell) {
            cell = [[NSGoodsShowCellTest alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSGoodsShowCellTest"];
        }
        WEAKSELF
//        if (self.tableView.data.count > indexPath.section) {
            ProductListItemModel *model = self.tableView.data[indexPath.section];
            cell.productModel = model;
//            [self configureCell:cell atIndexPath:indexPath];
            cell.likeBtnClickBlock = ^{
                [weakSelf likeClickAtIndexPath:indexPath];
            };
    cell.shareBtnClickBlock = ^{
        [weakSelf showGoodsQRCode:indexPath];
    };
//        }
        return cell;
//    }
    
}

//- (void)configureCell:(NSGoodsShowCellTest *)cell atIndexPath:(NSIndexPath *)indexPath {
//    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
//    ProductListItemModel *model = self.tableView.data[indexPath.section];
//    cell.productModel = model;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section != 0){
        DLog(@"跳转到详情页");
        NSGoodsShowCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
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
    [self requestAllOrder:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableDictionary *)imageDict{
    if (!_imageDict) {
        _imageDict = [NSMutableDictionary dictionary];
    }
    return _imageDict;
}

-(NSMutableArray *)imageGroupArray{
    if (!_imageGroupArray) {
        _imageGroupArray = [NSMutableArray array];
    }
    return _imageGroupArray;
}

-(void)likeClickAtIndexPath:(NSIndexPath *)indexPath{
    NSGoodsShowCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
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
    
    self.shareView.alpha = 0.9;
    self.bgView.alpha = 1;
    NSGoodsShowCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
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

@end

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

@end

@implementation NSHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = kWhiteColor;
    
    [self setUpNavTopView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildUI];
    [self requestAllOrder:NO];
    
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
    _tableView.backgroundColor = [UIColor lightGrayColor];
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
        NSLog(@"count = %lu",result.advertList.count);
        NSLog(@"获取广告数据成功");
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
    
    
    
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    dispatch_group_async(group, dispatch_get_main_queue(), ^{
//        [HomePageAPI getProductList:nil success:^(ProductListModel * _Nullable result) {
//            NSLog(@"获取产品列表成功");
//            weakSelf.tableView.data = [NSMutableArray arrayWithArray:result.productList];
//            [weakSelf.tableView updatePage:more];
//            weakSelf.tableView.noDataView.hidden = weakSelf.tableView.data.count;
//            //            [weakSelf.tableView reloadData];
//        } failure:^(NSError *error) {
//            NSLog(@"获取产品列表失败");
//        }];
//    });
//
//    dispatch_group_async(group, queue, ^{
//        [HomePageAPI getHomePageAdvertInfro:@{@"advertCode":@"indexHeadAdvert"} success:^(AdvertListModel * _Nullable result) {
//            NSLog(@"count = %lu",result.advertList.count);
//            NSLog(@"获取广告数据成功");
//            for(AdvertItemModel *model in result.advertList){
//                //            NSLog(@"path = %@",model.pic_img);
//                [weakSelf.imageGroupArray addObject:model.pic_img];
//                [weakSelf.imageDict setValue:model forKey:model.pic_img];
//            }
//            //            [weakSelf.tableView reloadData];
//        } failure:^(NSError *error) {
//            NSLog(@"获取广告数据失败");
//        }];
//    });
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        [weakSelf.tableView reloadData];
//    });
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
            qrCodeVC.QRString = @"shshfeihashasds";
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
        sectionView.backgroundColor = KBGCOLOR;
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
    [self requestAllOrder:YES];
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


@end

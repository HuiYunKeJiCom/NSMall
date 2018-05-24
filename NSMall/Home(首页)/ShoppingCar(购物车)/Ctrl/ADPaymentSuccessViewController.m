//
//  ADPaymentSuccessViewController.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/14.
//  Copyright © 2018年 Adel. All rights reserved.
//  购物车-下单页面-支付订单-支付成功

#import "ADPaymentSuccessViewController.h"
#import "ADOrderTopToolView.h"
#import "ADPaymentOrderBottonView.h"
//#import "ADOrderListViewController.h"//我的订单
#import "ADPaymentSuccessContentView.h"
#import "ADPaymentGoodsModel.h"
#import "ADPaymentGoodsCell.h"

@interface ADPaymentSuccessViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
/* 顶部Nva */
@property (strong , nonatomic)ADOrderTopToolView *topToolView;
/* 内容View */
@property (strong , nonatomic)ADPaymentSuccessContentView *contentView;
/* 商品tableview */
@property (nonatomic, strong) BaseTableView         *goodsTable;
/* 底部View */
@property (strong , nonatomic)ADPaymentOrderBottonView *bottomView;
@end

@implementation ADPaymentSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self setUpNavTopView];
    [self setUpContentView];
    [self.view addSubview:self.goodsTable];
    [self requestAllOrder:NO];
    [self setupCustomBottomView];
    
    [self makeConstraints];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _topToolView.hidden = NO;
    _topToolView.backgroundColor = [UIColor whiteColor];
    [_topToolView setTopTitleWithNSString:KLocalizableStr(@"支付成功")];
    WEAKSELF
    _topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //    _topToolView.rightItemClickBlock = ^{
    //        NSLog(@"点击设置");
    //    };
    
    [self.view addSubview:_topToolView];
    
}

#pragma mark - Constraints
- (void)makeConstraints {
    WEAKSELF
    [self.goodsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(200);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-130, 410));
    }];
}

#pragma mark - contentView
- (void)setUpContentView
{
    _contentView = [[ADPaymentSuccessContentView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-50)];
//    _contentView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_contentView];

}

#pragma mark -- 自定义底部视图
- (void)setupCustomBottomView {
//        WEAKSELF
    _bottomView = [[ADPaymentOrderBottonView alloc] initWithFrame:CGRectMake(0, kScreenHeight -  50, kScreenWidth, 50)];
    [_bottomView setTopTitleWithNSString:@"查看订单"];
    _bottomView.payBtnClickBlock = ^{
                //跳转到我的订单页面
//                ADOrderListViewController *orderListVC = [[ADOrderListViewController alloc] init];
//                [weakSelf.navigationController pushViewController:orderListVC animated:YES];
    };
    
    [self.view addSubview:_bottomView];
}

- (void)requestAllOrder:(BOOL)more {
    [self.goodsTable updateLoadState:more];
    
    WEAKSELF
    [weakSelf handleTransferResult:nil more:more];
}

- (void)handleTransferResult:(NSDictionary *)result more:(BOOL)more{
    
    NSArray *dataArr = @[@{@"id":@"123456",@"goodsName":@"ADEL爱迪尔4920B",@"type":@"智能指纹锁",@"detail1":@"三合一(咖啡铜色)",@"detail2":@"左侧开"},@{@"id":@"123456",@"goodsName":@"ADEL爱迪尔4920B",@"type":@"智能指纹锁",@"detail1":@"三合一(咖啡铜色)",@"detail2":@"左侧开"},@{@"id":@"123456",@"goodsName":@"ADEL爱迪尔4920B",@"type":@"智能指纹锁",@"detail1":@"三合一(咖啡铜色)",@"detail2":@"左侧开"}];
    
    [self.goodsTable.data removeAllObjects];
    for (NSDictionary *dic in dataArr) {
        ADPaymentGoodsModel *model = [ADPaymentGoodsModel mj_objectWithKeyValues:dic];
        [self.goodsTable.data addObject:model];
    }
    
    [self.goodsTable updatePage:more];
    //    self.allOrderTable.isLoadMore = dataArr.count >= k_RequestPageSize ? YES : NO;
    self.goodsTable.noDataView.hidden = self.goodsTable.data.count;
    
    [self.goodsTable reloadData];
}

- (BaseTableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.isLoadMore = NO;
        _goodsTable.isRefresh = NO;
        _goodsTable.scrollEnabled = NO;
        _goodsTable.delegateBase = self;
        //        _goodsTable.backgroundColor = [UIColor greenColor];
        [_goodsTable registerClass:[ADPaymentGoodsCell class] forCellReuseIdentifier:@"ADPaymentGoodsCell"];
    }
    return _goodsTable;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.goodsTable.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    return kScreenWidth == 320 ? 40 : GetScaleWidth(40);
        return 130;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(10))];
    sectionView.backgroundColor = [UIColor lightGrayColor];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else{
        return GetScaleWidth(10);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        ADPaymentGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADPaymentGoodsCell"];
        if (self.goodsTable.data.count > indexPath.row) {
            ADPaymentGoodsModel *model = self.goodsTable.data[indexPath.row];
            cell.model = model;
        }
//        cell.backgroundColor = [UIColor redColor];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

@end

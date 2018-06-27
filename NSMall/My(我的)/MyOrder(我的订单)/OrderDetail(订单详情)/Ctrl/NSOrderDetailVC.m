//
//  NSOrderDetailVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSOrderDetailVC.h"
#import "ADOrderTopToolView.h"
#import "OrderDetailAPI.h"
#import "OrderDetailParam.h"
#import "NSOrderDetailModel.h"

//#import "NSFirmOrderCell.h"
#import "NSODAddressTVCell.h"
//#import "CartAPI.h"
//#import "NSBuildOrderParam.h"
//
//#import "ADReceivingAddressViewController.h"//地址列表
//#import "NSWalletListModel.h"
//#import "WalletAPI.h"

@interface NSOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *goodsTable;
@property(nonatomic,strong)NSOrderDetailModel *orderDetailModel;/* 订单详情模型 */
@end

@implementation NSOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KBGCOLOR;
    [self.view addSubview:self.goodsTable];
    [self setUpNavTopView];
    [self makeConstraints];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"订单详情")];
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
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
    }];
    
}

-(void)loadDataWithType:(NSString *)type andOrderID:(NSString *)orderID{
    
    OrderDetailParam *param = [OrderDetailParam new];
    param.type = type;
    param.orderId = orderID;
    
    [OrderDetailAPI getOrderDetailWithParam:param success:^(NSOrderDetailModel *orderDetailModel) {
        DLog(@"获取订单详情成功");
        self.orderDetailModel = orderDetailModel;
    } faulre:^(NSError *error) {
        DLog(@"获取订单详情失败");
    }];
}

- (void)requestAllOrder:(BOOL)more {
    [self.goodsTable updateLoadState:more];
    
    WEAKSELF
//    [CartAPI checkCartDataWithParam:self.cartId success:^(NSFirmOrderModel *firmOrderModel) {
//        NSLog(@"获取获取购物车结算页面数据成功");
//        weakSelf.firmOrderModel = firmOrderModel;
//        weakSelf.goodsTable.data = [NSMutableArray arrayWithArray:firmOrderModel.cartList];
//        [self.goodsTable updatePage:more];
//        self.goodsTable.noDataView.hidden = self.goodsTable.data.count;
//        [self.goodsTable reloadData];
//        [self setUpButtomView];
//    } faulre:^(NSError *error) {
//        NSLog(@"获取获取购物车结算页面数据失败");
//    }];
    
}

- (BaseTableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.isLoadMore = YES;
        _goodsTable.isRefresh = YES;
        _goodsTable.delegateBase = self;
//        [_goodsTable registerClass:[NSFirmOrderCell class] forCellReuseIdentifier:@"NSFirmOrderCell"];
        [_goodsTable registerClass:[NSODAddressTVCell class] forCellReuseIdentifier:@"NSODAddressTVCell"];
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
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(15))];
    sectionView.backgroundColor = KBGCOLOR;
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.goodsTable.data.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section == 0){
        return GetScaleWidth(65);
//    }else{
//        LZShopModel *shopModel = self.goodsTable.data[indexPath.section-1];
//        //        DLog(@"cellHeight = %.2f",shopModel.cellHeight);
//        return shopModel.cellHeight;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if(indexPath.section == 0){
        NSODAddressTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSAddressTVCell"];
        cell.orderDetailModel = self.orderDetailModel;
        return cell;
//    }else{
//        NSFirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSFirmOrderCell"];
//        if (self.goodsTable.data.count > indexPath.section-1) {
//            LZShopModel *model = self.goodsTable.data[indexPath.section-1];
//            //        NSLog(@"model = %@",model.mj_keyValues);
//            cell.shopModel = model;
//        }
//
//        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section==0){
//        
//        ADReceivingAddressViewController *receivingAddressVC = [[ADReceivingAddressViewController alloc] init];
//        receivingAddressVC.addressBlock = ^(NSAddressItemModel *model) {
//            self.firmOrderModel.defaultAddress = model;
//            [self.goodsTable reloadData];
//        };
//        [self.navigationController pushViewController:receivingAddressVC animated:YES];
//    }
}

- (void)baseTableVIew:(BaseTableView *)tableView refresh:(BOOL)flag {
    //    [self requestAllOrder:NO];
}

- (void)baseTableView:(BaseTableView *)tableView loadMore:(BOOL)flag {
    //    [self requestAllOrder:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

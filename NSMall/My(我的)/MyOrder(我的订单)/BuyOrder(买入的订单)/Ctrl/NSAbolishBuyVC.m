//
//  NSAbolishOrderBuyVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSAbolishBuyVC.h"
#import "NSMyOrderTVCell.h"
#import "NSOrderListItemModel.h"
#import "MyOrderAPI.h"
#import "MyOrderParam.h"
#import "NSOrderDetailVC.h"

@interface NSAbolishBuyVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *allOrderTable;
/** 当前页数 */
@property(nonatomic)NSInteger currentPage;

@end

@implementation NSAbolishBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.allOrderTable];
    [self makeConstraints];
}

-(void)viewWillAppear:(BOOL)animated{
    self.currentPage = 1;
    [self requestAllOrder:NO];
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    [self.allOrderTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
        //    make.top.equalTo(self.view).with.offset(TopBarHeight);
    }];
    
}

- (void)requestAllOrder:(BOOL)more {
    [self.allOrderTable updateLoadState:more];
    
    MyOrderParam *param = [MyOrderParam new];
    param.currentPage = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.currentPage]];
    param.type = @"0";
    param.orderStatus = @"11";
    WEAKSELF
    [MyOrderAPI getMyOrderList:param success:^(NSOrderListModel * _Nullable result) {
        DLog(@"获取订单列表成功");
        //        DLog(@"result = %@",result.mj_keyValues);
        weakSelf.allOrderTable.data = [NSMutableArray arrayWithArray:result.orderList];
        [self.allOrderTable updatePage:more];
        self.allOrderTable.noDataView.hidden = self.allOrderTable.data.count;
        [self.allOrderTable reloadData];
        
    } failure:^(NSError *error) {
        DLog(@"获取订单列表失败");
        [self cutCurrentPag];
    }];
}

-(void)cutCurrentPag{
    if(self.currentPage != 1){
        self.currentPage -= 1;
    }
}

- (BaseTableView *)allOrderTable {
    if (!_allOrderTable) {
        _allOrderTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _allOrderTable.delegate = self;
        _allOrderTable.dataSource = self;
        _allOrderTable.isLoadMore = YES;
        _allOrderTable.isRefresh = YES;
        _allOrderTable.delegateBase = self;
        _allOrderTable.backgroundColor = KBGCOLOR;
        [_allOrderTable registerClass:[NSMyOrderTVCell class] forCellReuseIdentifier:@"NSMyOrderTVCell"];
        
    }
    return _allOrderTable;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allOrderTable.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(10))];
    sectionView.backgroundColor = KBGCOLOR;
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    if(section == 0){
    //        return 1;
    //    }else{
    return GetScaleWidth(10);
    //    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.allOrderTable.data.count > indexPath.section){
        NSOrderListItemModel *orderItemModel = self.allOrderTable.data[indexPath.section];
        return orderItemModel.cellHeight;
    }else{
        return 0.01f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMyOrderTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSMyOrderTVCell"];
    if (self.allOrderTable.data.count > indexPath.section) {
        NSOrderListItemModel *model = self.allOrderTable.data[indexPath.section];
        cell.model = model;
        cell.nextOperationClickBlock = ^{
        };
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DLog(@"跳转到订单详情");
    if(self.allOrderTable.data.count > indexPath.section){
    NSOrderListItemModel *model = self.allOrderTable.data[indexPath.section];

    //跳转到订单详情
    NSOrderDetailVC *orderDetailVC = [NSOrderDetailVC new];
    [orderDetailVC loadDataWithType:@"0" andOrderID:model.order_id];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
}

- (void)baseTableVIew:(BaseTableView *)tableView refresh:(BOOL)flag {
    [self requestAllOrder:NO];
}

- (void)baseTableView:(BaseTableView *)tableView loadMore:(BOOL)flag {
    if(tableView.data.count >20){
        self.currentPage += 1;
        [self requestAllOrder:YES];
    }else{
        [self requestAllOrder:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

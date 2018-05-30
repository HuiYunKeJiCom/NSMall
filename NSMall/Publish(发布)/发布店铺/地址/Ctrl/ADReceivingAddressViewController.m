//
//  ADReceivingAddressViewController.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/9.
//  Copyright © 2018年 Adel. All rights reserved.
//  收货地址

#import "ADReceivingAddressViewController.h"
#import "ADOrderTopToolView.h"//自定义导航栏
#import "NSAddressItemModel.h"
#import "ADReceivingAddressCell.h"
#import "YWAddressViewController.h"//新增地址
#import "GetAreaAPI.h"
#import "GetAddressParam.h"
#import "SetDefaultAddressParam.h"
#import "DelAddressParam.h"


@interface ADReceivingAddressViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *goodsTable;
/* 顶部Nva */
@property (strong , nonatomic)ADOrderTopToolView *topToolView;

/** 当前页数 */
@property(nonatomic)NSInteger currentPage;

@end

@implementation ADReceivingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGCOLOR;
    [self.view addSubview:self.goodsTable];
    [self setUpNavTopView];
    
    [self setupCustomBottomView];
    [self makeConstraints];
//    [self requestAllOrder:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.currentPage = 1;
    [self requestAllOrder:NO];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    _topToolView.hidden = NO;
    _topToolView.backgroundColor = [UIColor whiteColor];
    [_topToolView setTopTitleWithNSString:KLocalizableStr(@"管理收货地址")];
    WEAKSELF
    _topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:_topToolView];
    
}

#pragma mark -- 自定义底部视图
- (void)setupCustomBottomView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = KMainColor;
    btn.frame = CGRectMake(0, kScreenHeight-TabBarHeight, kScreenWidth, TabBarHeight);
    [btn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    [self.goodsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
    }];
    
}

- (void)requestAllOrder:(BOOL)more {
    [self.goodsTable updateLoadState:more];
    
    //这里需要修改
    GetAddressParam *param = [GetAddressParam new];
    param.currentPage = [NSString stringWithFormat:@"%lu",self.currentPage];
    [GetAreaAPI getAddressWithParam:param success:^(NSAddressModel * _Nullable result) {
        NSLog(@"获取收货地址成功");
        [self.goodsTable.data removeAllObjects];
        self.goodsTable.data = [NSMutableArray arrayWithArray:result.addressList];
        
        [self.goodsTable updatePage:more];
        self.goodsTable.noDataView.hidden = self.goodsTable.data.count;
        [self.goodsTable reloadData];
        
    } failure:^(NSError * _Nullable error) {
        NSLog(@"获取收货地址失败");
        [self cutCurrentPag];
    }];

}

-(void)cutCurrentPag{
    if(self.currentPage != 1){
        self.currentPage -= 1;
    }
}

- (BaseTableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.isLoadMore = YES;
        _goodsTable.isRefresh = YES;
        _goodsTable.delegateBase = self;
        [_goodsTable registerClass:[ADReceivingAddressCell class] forCellReuseIdentifier:@"ADReceivingAddressCell"];
    }
    return _goodsTable;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else{
        return GetScaleWidth(10);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(10))];
    return sectionView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.goodsTable.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenWidth == 320 ? 100 : GetScaleWidth(100);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADReceivingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADReceivingAddressCell"];
    if (self.goodsTable.data.count > indexPath.section) {
        NSAddressItemModel *model = self.goodsTable.data[indexPath.section];
//        NSLog(@"model.homeLabelName = %@",model.homeLabelName);
        cell.model = model;
        cell.setDefaultBtnClickBlock = ^{
            [self setDefaultAddressWithID:model.address_id];
        };
        cell.deleteBtnClickBlock = ^{
            [self deleteAddressWithID:model.address_id];
        };
        cell.editBtnClickBlock = ^{
            [self editBtnAction:model];
        };
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

#pragma mark - action
- (void)addBtnAction{
    NSLog(@"调用addBtnAction方法");
    YWAddressViewController *addressVC = [[YWAddressViewController alloc] init];
    // 保存后的地址回调
    addressVC.addressBlock = ^(NSAddressItemModel *model) {
        NSLog(@"新增用户地址信息填写回调：");
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)editBtnAction:(NSAddressItemModel *)addressModel {
    
    // 这里传入需要编辑的地址信息，例如:
    YWAddressViewController *addressVC = [[YWAddressViewController alloc] init];
    NSAddressItemModel *model = [NSAddressItemModel alloc];
    model.user_phone = addressModel.user_phone;
    model.user_name = addressModel.user_name;
    //县区ID model.district_id,model.district_name这两个需要修改
    model.province_id = addressModel.province_id;
    model.province_name = addressModel.province_name;
    model.city_id = addressModel.city_id;
    model.city_name = addressModel.city_name;
    model.district_id = addressModel.district_id;
    model.district_name = addressModel.district_name;
    model.street_id = addressModel.street_id;
    model.street_name = addressModel.street_name;
    
    
    model.user_address = addressModel.user_address;
    model.address_id = addressModel.address_id;
    model.is_default = addressModel.is_default; // 如果是默认地址则传入YES
    addressVC.model = model;
    WEAKSELF
    // 保存后的地址回调
    addressVC.addressBlock = ^(NSAddressItemModel *model) {
        NSLog(@"编辑用户地址信息填写回调：");
        [weakSelf.goodsTable reloadData];
    };
    NSLog(@"navigationController = %@",self.navigationController);
    [self.navigationController pushViewController:addressVC animated:YES];
}

//设置默认收货地址
-(void)setDefaultAddressWithID:(NSString *)addressId{
    NSLog(@"addressId = %@",addressId);
    //这里需要修改
    SetDefaultAddressParam *param = [SetDefaultAddressParam new];
    param.addressId = addressId;
    [GetAreaAPI setDefaultAddressWithParam:param success:^{
        NSLog(@"设置默认收货地址成功");
        [self.goodsTable reloadData];
        [self requestAllOrder:NO];
    } faulre:^(NSError *error) {
        NSLog(@"设置默认收货地址失败");
    }];

}

//删除收货地址
-(void)deleteAddressWithID:(NSString *)addressId{
    //这里需要修改
    DelAddressParam *param = [DelAddressParam new];
    param.addressId = addressId;
    [GetAreaAPI delAddressWithParam:param success:^{
        NSLog(@"删除收货地址成功");
        [self.goodsTable reloadData];
        [self requestAllOrder:NO];
    } faulre:^(NSError *error) {
        NSLog(@"删除收货地址失败");
    }];

}

@end

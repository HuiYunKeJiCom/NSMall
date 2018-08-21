//
//  NSOrderDetailVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/20.
//  Copyright © 2018年 www. All rights reserved.
//  买入订单详情

#import "NSOrderDetailVC.h"
#import "ADOrderTopToolView.h"
#import "OrderDetailAPI.h"
#import "OrderDetailParam.h"
#import "NSOrderDetailModel.h"

#import "NSODTVCell.h"
#import "NSODAddressTVCell.h"
#import "NSDeliverVC.h"
#import "NSGetExpressAPI.h"
#import "NSOrderListVC.h"

@interface NSOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property(nonatomic,strong)UIScrollView *SV;/* 全局SV */
@property(nonatomic,strong)UIButton *stateBtn;/* 状态 */
@property (nonatomic, strong) BaseTableView         *goodsTable;
@property(nonatomic,strong)NSOrderDetailModel *orderDetailModel;/* 订单详情模型 */
@property(nonatomic,strong)OrderDetailParam *param;/* 参数 */
@property (nonatomic, strong) UIView           *operationView;
@property(nonatomic,strong)UIButton *deliveryBtn;/* 发货按钮 */
@end

@implementation NSOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KBGCOLOR;
    
    [self setUpNavTopView];
}

-(void)buildUI{
    
    self.SV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopBarHeight, kScreenWidth, kScreenHeight-TopBarHeight-TabBarHeight)];
    //    self.SV.scrollEnabled = NO;
    self.SV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+56);
    self.SV.backgroundColor = KBGCOLOR;
    self.SV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.SV];
    [self.SV addSubview:self.goodsTable];
    
    self.operationView = [[UIView alloc]init];
    self.operationView.x = 0;
    self.operationView.y = kScreenHeight-50;
    self.operationView.size = CGSizeMake(kScreenWidth, 50);
    self.operationView.backgroundColor = kWhiteColor;
    self.self.operationView.alpha = 0.0;
    [self.view addSubview:self.operationView];

    self.deliveryBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 120, 10, 100, 30)];
    [self.deliveryBtn setBackgroundColor:KMainColor];
    [self.deliveryBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.deliveryBtn addTarget:self action:@selector(ReceiveAndDeliver) forControlEvents:UIControlEventTouchUpInside];
    self.deliveryBtn.layer.cornerRadius = 5.0;
    [self.deliveryBtn.layer setMasksToBounds:YES];
    [self.self.operationView addSubview:self.deliveryBtn];
    
    [self makeConstraints];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:NSLocalizedString(@"order details", nil)];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    [self.SV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
    }];
    
    [self.goodsTable mas_makeConstraints:^(MASConstraintMaker *make) { make.top.equalTo(self.SV.mas_top).with.offset(33);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight - TopBarHeight);
    }];
    
}

-(void)loadDataWithType:(NSString *)type andOrderID:(NSString *)orderID{

    self.param = [OrderDetailParam new];
    self.param.type = type;
    self.param.orderId = orderID;
    [self requestAllOrder:NO];
}

- (void)requestAllOrder:(BOOL)more {
    [self.goodsTable.data removeAllObjects];
    DLog(@"param = %@",self.param.mj_keyValues);
    [OrderDetailAPI getOrderDetailWithParam:self.param success:^(NSOrderDetailModel *orderDetailModel) {
        DLog(@"获取订单详情成功");
        self.orderDetailModel = orderDetailModel;
        //        DLog(@"orderDetailModel = %@",orderDetailModel.mj_keyValues);
        [self buildUI];
        [self createStateBtn];
        self.goodsTable.data = [NSMutableArray arrayWithObjects:orderDetailModel, nil];
        self.goodsTable.noDataView.hidden = self.goodsTable.data.count;
        [self.goodsTable reloadData];
        
        
    } faulre:^(NSError *error) {
        DLog(@"获取订单详情失败");
    }];
}

-(void)createStateBtn{
    
    if(self.stateBtn){
        [self.stateBtn removeFromSuperview];
    }
    
    self.stateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
    [self.stateBtn setBackgroundColor:KMainColor];
    [self.stateBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.SV addSubview:self.stateBtn];
    //    [self.stateBtn setTitle:@"待发货" forState:UIControlStateNormal];
    
    switch (self.orderDetailModel.order_status) {
        case 1:
        {
            //待支付
            self.operationView.alpha = 0.0;
            [self.stateBtn setTitle:NSLocalizedString(@"wait pay", nil) forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            //待发货
            [self.stateBtn setTitle:NSLocalizedString(@"wait deliver", nil) forState:UIControlStateNormal];
            if([self.orderDetailModel.type isEqualToString:@"1"]){
                self.operationView.alpha = 1.0;
                [self.deliveryBtn setTitle:@"发货" forState:UIControlStateNormal];
            }else{
                self.operationView.alpha = 0.0;
            }
        }
            break;
        case 3:
        {
            //待收货
            [self.stateBtn setTitle:NSLocalizedString(@"wait receive", nil) forState:UIControlStateNormal];
            if([self.orderDetailModel.type isEqualToString:@"0"]){
                self.operationView.alpha = 1.0;
                [self.deliveryBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            }else{
                self.operationView.alpha = 0.0;
            }
        }
            break;
        case 4:
        {
            //已完成（待评价）
            self.operationView.alpha = 0.0;
            [self.stateBtn setTitle:NSLocalizedString(@"completed", nil) forState:UIControlStateNormal];
        }
            break;
        case 10:
        {
            //交易完成（交易结束，不可评价和退换货）
            self.operationView.alpha = 0.0;
            [self.stateBtn setTitle:NSLocalizedString(@"trade completed", nil) forState:UIControlStateNormal];
        }
            break;
        case 11:
        {
            //已取消（手动）
            self.operationView.alpha = 0.0;
            [self.stateBtn setTitle:NSLocalizedString(@"cancelled", nil) forState:UIControlStateNormal];
        }
            break;
        case 12:
        {
            //已取消（超时自动取消）
            self.operationView.alpha = 0.0;
            [self.stateBtn setTitle:NSLocalizedString(@"cancelled", nil) forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
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
        _goodsTable.scrollEnabled = NO;
        [_goodsTable registerClass:[NSODTVCell class] forCellReuseIdentifier:@"NSODTVCell"];
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
    if(indexPath.section == 0){
        return GetScaleWidth(65);
    }else{
//        LZShopModel *shopModel = self.goodsTable.data[indexPath.section-1];
//        //        DLog(@"cellHeight = %.2f",shopModel.cellHeight);
//        return shopModel.cellHeight;
        return GetScaleWidth(165);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0){
        NSODAddressTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSODAddressTVCell"];
        cell.orderDetailModel = self.orderDetailModel;
        return cell;
    }else{
        NSODTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSODTVCell"];
        if (self.goodsTable.data.count > indexPath.section-1) {
            NSOrderDetailModel *model = self.goodsTable.data[indexPath.section-1];
            //        NSLog(@"model = %@",model.mj_keyValues);
            cell.orderDetailModel = model;
        }

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

-(void)ReceiveAndDeliver{
    if(self.orderDetailModel.order_status == 2){
        //待发货
        NSDeliverVC *deliverVC = [NSDeliverVC new];
        deliverVC.orderId = self.orderDetailModel.order_id;
        [self.navigationController pushViewController:deliverVC  animated:YES];
    }else if(self.orderDetailModel.order_status == 3){
        //待收货
        [NSGetExpressAPI confirmOrderWithParam:self.orderDetailModel.order_id success:^{
            DLog(@"操作成功");
            [Common AppShowToast:@"操作成功"];
            [self delayPop];
        } faulre:^(NSError *error) {
            
        }];
    }
}


- (void)delayPop {
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:[NSOrderListVC class]]){
                [weakSelf.navigationController popToViewController:vc animated:YES];
            }
        }
        
    });
}


@end

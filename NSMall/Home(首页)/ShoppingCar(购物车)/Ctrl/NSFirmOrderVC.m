//
//  NSFirmOrderVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/30.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSFirmOrderVC.h"
#import "ADOrderTopToolView.h"
#import "NSFirmOrderModel.h"
#import "NSFirmOrderCell.h"
#import "NSAddressTVCell.h"
#import "CartAPI.h"
#import "NSBuildOrderParam.h"

#import "ADReceivingAddressViewController.h"//地址列表
#import "NSWalletListModel.h"
#import "NSPayView.h"
#import "WalletAPI.h"
#import "NSInputPwView.h"

@interface NSFirmOrderVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,NSInputPwViewDelegate>
@property (nonatomic, strong) BaseTableView         *goodsTable;
@property(nonatomic,strong)NSFirmOrderModel *firmOrderModel;/* 数据模型 */
@property(nonatomic,copy)NSString *cartId;/* 购物车Id */
@property(nonatomic,copy)NSString *walletID;/* 购物车Id */
@property(nonatomic,strong)NSWalletListModel *walletListModel;/* 订单模型 */
//@property(nonatomic,strong)NSMutableArray *walletNameArr;/* 钱包名称 */
@end

@implementation NSFirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.goodsTable];
    [self setUpNavTopView];
    [self makeConstraints];
//    [self requestAllOrder:NO];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"确认订单")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

-(void)setUpButtomView{
    UIView *buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-48, kScreenWidth, 48)];
    buttomView.backgroundColor = kWhiteColor;
    [self.view addSubview:buttomView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = KBGCOLOR;
    [buttomView addSubview:lineView];
    
    UIButton *submission = [UIButton buttonWithType:UIButtonTypeCustom];
    submission.backgroundColor = kRedColor;
    submission.x = kScreenWidth-19-80;
    submission.y = 10;
    submission.size = CGSizeMake(80, 28);
    [submission setTitle:@"提交并支付" forState:UIControlStateNormal];
    submission.titleLabel.font = UISystemFontSize(14);
    [submission setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [submission addTarget:self action:@selector(payView) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:submission];
    
    UILabel *sumLab = [[UILabel alloc]init];
    sumLab.textColor = kRedColor;
    sumLab.text = [NSString stringWithFormat:@"N%.2f",self.firmOrderModel.payment_price];
    CGSize sum = [self contentSizeWithTitle:sumLab.text andFont:14];
    sumLab.x = CGRectGetMinX(submission.frame)-13-sum.width;
    sumLab.y = 24-sum.height*0.5;
    sumLab.font = UISystemFontSize(14);
    [sumLab sizeToFit];
    [buttomView addSubview:sumLab];
    
    UILabel *sumTitle = [[UILabel alloc]init];
    sumTitle.font = UISystemFontSize(14);
    sumTitle.text = @"合计";
    CGSize sumTitSize = [self contentSizeWithTitle:sumTitle.text andFont:14];
    sumTitle.x = CGRectGetMinX(sumLab.frame)-7-sumTitSize.width;
    sumTitle.y = 24-sumTitSize.height*0.5;
    [sumTitle sizeToFit];
    sumTitle.textColor = kBlackColor;
    [buttomView addSubview:sumTitle];
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    [self.goodsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
    }];
    
}

-(void)loadDataWithNSString:(NSString *)string{
    self.cartId = string;
    [self requestAllOrder:NO];
}

- (void)requestAllOrder:(BOOL)more {
    [self.goodsTable updateLoadState:more];
    
    WEAKSELF
    [CartAPI checkCartDataWithParam:self.cartId success:^(NSFirmOrderModel *firmOrderModel) {
        NSLog(@"获取获取购物车结算页面数据成功");
        weakSelf.firmOrderModel = firmOrderModel;
        weakSelf.goodsTable.data = [NSMutableArray arrayWithArray:firmOrderModel.cartList];
        [self.goodsTable updatePage:more];
        self.goodsTable.noDataView.hidden = self.goodsTable.data.count;
        [self.goodsTable reloadData];
        [self setUpButtomView];
    } faulre:^(NSError *error) {
        NSLog(@"获取获取购物车结算页面数据失败");
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
        [_goodsTable registerClass:[NSFirmOrderCell class] forCellReuseIdentifier:@"NSFirmOrderCell"];
        [_goodsTable registerClass:[NSAddressTVCell class] forCellReuseIdentifier:@"NSAddressTVCell"];
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
        LZShopModel *shopModel = self.goodsTable.data[indexPath.section-1];
//        DLog(@"cellHeight = %.2f",shopModel.cellHeight);
        return shopModel.cellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        NSAddressTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSAddressTVCell"];
        cell.addressModel = self.firmOrderModel.defaultAddress;
        return cell;
    }else{
        NSFirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSFirmOrderCell"];
        if (self.goodsTable.data.count > indexPath.section-1) {
            LZShopModel *model = self.goodsTable.data[indexPath.section-1];
            //        NSLog(@"model = %@",model.mj_keyValues);
            cell.shopModel = model;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        
        ADReceivingAddressViewController *receivingAddressVC = [[ADReceivingAddressViewController alloc] init];
        receivingAddressVC.addressBlock = ^(NSAddressItemModel *model) {
            self.firmOrderModel.defaultAddress = model;
            [self.goodsTable reloadData];
        };
        [self.navigationController pushViewController:receivingAddressVC animated:YES];
    }
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

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

-(void)buildOrder{
    NSBuildOrderParam *param = [NSBuildOrderParam new];
    param.cartIds = self.cartId;
    param.addressId = self.firmOrderModel.defaultAddress.address_id;
    [CartAPI buildOrderWithParam:param success:^(NSWalletListModel *walletList) {
        DLog(@"创建订单成功");
        self.walletListModel = walletList;
    } faulre:^(NSError *error) {
        DLog(@"创建订单失败");
    }];
}

-(void)payView{
    
    [WalletAPI getWalletListWithParam:nil success:^(NSWalletModel *walletModel) {
        NSLog(@"获取钱包列表成功");
//        [self.walletNameArr removeAllObjects];
//        for (WalletItemModel* model in walletModel.walletList) {
//            [self.walletNameArr addObject:model];
//        }
        NSPayView *payView = [[NSPayView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}];
        payView.userInteractionEnabled = YES;
        payView.payString = [NSString stringWithFormat:@"N%.2f",self.firmOrderModel.payment_price];
        payView.walletNameArr = [NSMutableArray arrayWithArray:walletModel.walletList];
        __weak typeof(payView) PayView = payView;
        payView.confirmClickBlock = ^{
            [PayView removeView];
            [self buildOrder];
            [self showInputPwView:PayView.walletId];
        };
        [payView showInView:self.navigationController.view];
    } faulre:^(NSError *error) {
        NSLog(@"获取钱包列表失败");
    }];
    
}

-(void)showInputPwView:(NSString *)walletID{
    self.walletID = walletID;
    NSInputPwView *inputView = [[NSInputPwView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}];
    inputView.tbDelegate = self;
    __weak typeof(inputView) InputView = inputView;
    inputView.backClickBlock = ^{
        [InputView removeView];
        [self payView];
    };
    [inputView showInView:self.navigationController.view];
}

-(void)payOrder:(NSString *)tradePw{
    //调用支付订单接口
    NSPayOrderParam *param = [NSPayOrderParam new];
    param.walletId = self.walletID;
    param.orderId = self.walletListModel.orderId;
    DLog(@"订单id  orderId = %@",param.orderId);
    param.tradePassword = tradePw;
    DLog(@"param = %@",param.mj_keyValues);
    [CartAPI payOrderWithParam:param success:^{
        DLog(@"支付成功");
        [self.navigationController popViewControllerAnimated:YES];
    } faulre:^(NSError *error) {
        DLog(@"支付失败");
    }];
}

//-(NSMutableArray *)walletNameArr{
//    if (!_walletNameArr) {
//        _walletNameArr = [NSMutableArray array];
//    }
//    return _walletNameArr;
//}

@end

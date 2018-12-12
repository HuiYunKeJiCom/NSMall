//
//  NSMyWalletListVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMyWalletListVC.h"
#import "ADOrderTopToolView.h"
#import "WalletAPI.h"
#import "NSWalletModel.h"
#import "WalletItemModel.h"
#import "NSWalletTVCell.h"
#import "NSAddWalletVC.h"
#import "NSUnbindWalletParam.h"
#import "NSInputPwView.h"

@interface NSMyWalletListVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,NSInputPwViewDelegate>
@property (nonatomic, strong) BaseTableView         *walletTable;
@property(nonatomic,strong)UIButton *bindWallet;/* 绑定钱包 */
@property(nonatomic,strong)NSUnbindWalletParam *param;/* 解绑参数 */
@end

@implementation NSMyWalletListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.param = [NSUnbindWalletParam new];
    self.view.backgroundColor = KBGCOLOR;
    [self.view addSubview:self.walletTable];
    [self setUpNavTopView];
    
    [self setupCustomBottomView];
    [self makeConstraints];
    //    [self requestAllOrder:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self requestAllOrder:NO];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.hidden = NO;
    topToolView.backgroundColor = [UIColor whiteColor];
    [topToolView setTopTitleWithNSString:NSLocalizedString(@"my wallet", nil)];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

#pragma mark -- 自定义底部视图
- (void)setupCustomBottomView {
    
    self.bindWallet = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bindWallet.backgroundColor = KMainColor;
    self.bindWallet.frame = CGRectMake(0, kScreenHeight-TabBarHeight, kScreenWidth, TabBarHeight);
    [self.bindWallet setTitle:NSLocalizedString(@"bind wallet", nil) forState:UIControlStateNormal];
    [self.bindWallet addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bindWallet];
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    [self.walletTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
    }];
    
}

- (void)requestAllOrder:(BOOL)more {
    [self.walletTable updateLoadState:more];
    
    //这里需要修改
    [WalletAPI getWalletListWithParam:nil success:^(NSWalletModel *walletModel) {
        NSLog(@"获取钱包列表成功");
        [self.walletTable.data removeAllObjects];
        self.walletTable.data = [NSMutableArray arrayWithArray:walletModel.walletList];
        [self.walletTable updatePage:more];
        self.walletTable.noDataView.hidden = self.walletTable.data.count;
        [self showBindWalletWithNSArray:walletModel.walletList];
        [self.walletTable reloadData];
    } faulre:^(NSError *error) {
        NSLog(@"获取钱包列表失败");
    }];
    
}

-(void)showBindWalletWithNSArray:(NSArray *)array{
    if(array.count>0){
        self.bindWallet.alpha = 0.0;
    }else{
        self.bindWallet.alpha = 1.0;
    }
}

- (BaseTableView *)walletTable {
    if (!_walletTable) {
        _walletTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _walletTable.delegate = self;
        _walletTable.dataSource = self;
        _walletTable.isLoadMore = YES;
        _walletTable.isRefresh = YES;
        _walletTable.delegateBase = self;
        [_walletTable registerClass:[NSWalletTVCell class] forCellReuseIdentifier:@"NSWalletTVCell"];
    }
    return _walletTable;
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
    return self.walletTable.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  GetScaleWidth(65);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSWalletTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSWalletTVCell"];
    if (self.walletTable.data.count > indexPath.section) {
        WalletItemModel *model = self.walletTable.data[indexPath.section];
        cell.walletModel = model;
//        cell.defaultClickBlock = ^{
//            [self setDefaultWalletWithID:model.wallet_id];
//        };
    }
    
    return cell;
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

#pragma mark - action
- (void)addBtnAction{
    NSLog(@"调用addBtnAction方法");
    NSAddWalletVC *addWalletVC = [[NSAddWalletVC alloc] init];
    [self.navigationController pushViewController:addWalletVC animated:YES];
}

//设置默认收款钱包
-(void)setDefaultWalletWithID:(NSString *)walletId{
    DLog(@"walletId = %@",walletId);
    [WalletAPI setDefaultWalletWithParam:walletId success:^{
        DLog(@"设置默认钱包成功");
    } faulre:^(NSError *error) {
        DLog(@"设置默认钱包失败");
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    //第二组可以左滑删除
//    if (indexPath.section == 2) {
//        return YES;
//    }
    
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(self.walletTable.data.count > indexPath.section){
            WalletItemModel *model = self.walletTable.data[indexPath.section];
            self.param.walletId = model.wallet_id;
            [self showInputPwView:model.wallet_id];
        }
        
//        param.tradePassword =
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)showInputPwView:(NSString *)walletID{
    NSInputPwView *inputView = [[NSInputPwView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}];
    inputView.tbDelegate = self;
    __weak typeof(inputView) InputView = inputView;
    inputView.backClickBlock = ^{
        [InputView removeView];
    };
    [inputView showInView:self.navigationController.view];
}

-(void)payOrder:(NSString *)tradePw{
    
    self.param.tradePassword = tradePw;
    [WalletAPI unbindWalletWithParam:self.param success:^{
        DLog(@"删除成功");
        [Common AppShowToast:@"删除成功"];
        [self requestAllOrder:NO];
    } faulre:^(NSError *error) {
        
    }];
}


@end

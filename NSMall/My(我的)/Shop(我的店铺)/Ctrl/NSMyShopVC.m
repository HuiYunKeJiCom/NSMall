//
//  NSMyShopVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/18.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMyShopVC.h"
#import "NSShopListModel.h"
#import "NSShopListItemModel.h"

#import "NSMyShopTVCell.h"
#import "UserInfoAPI.h"
#import "ADOrderTopToolView.h"
#import "NSCommonParam.h"
#import "MyShopAPI.h"

@interface NSMyShopVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *goodsTable;
@property(nonatomic)NSInteger currentPage;/* 当前页数 */

@end

@implementation NSMyShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGCOLOR;
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
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"我的店铺")];
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
    [UserInfoAPI getMyShopList:param success:^(NSShopListModel * _Nullable result) {
        NSLog(@"获取我的店铺成功");
        weakSelf.goodsTable.data = [NSMutableArray arrayWithArray:result.storeList];
        [self.goodsTable updatePage:more];
        self.goodsTable.noDataView.hidden = self.goodsTable.data.count;
        [self.goodsTable reloadData];
    } failure:^(NSError *error) {
        NSLog(@"获取我的店铺失败");
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
        [_goodsTable registerClass:[NSMyShopTVCell class] forCellReuseIdentifier:@"NSMyShopTVCell"];
        
    }
    return _goodsTable;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return GetScaleWidth(0);
    }else{
        //设置间隔高度
        return GetScaleWidth(5);
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(5))];
    sectionView.backgroundColor = KBGCOLOR;
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.goodsTable.data.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GetScaleWidth(120);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMyShopTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSMyShopTVCell"];
    if (self.goodsTable.data.count > indexPath.row) {
        NSShopListItemModel *model = self.goodsTable.data[indexPath.row];
        //        NSLog(@"model = %@",model.mj_keyValues);
        cell.model = model;
        cell.deleteBtnClickBlock = ^{
            [self deleteShopWith:model];
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

-(void)cutCurrentPag{
    if(self.currentPage != 1){
        self.currentPage -= 1;
    }
}

-(void)deleteShopWith:(NSShopListItemModel *)model{
    [MyShopAPI delShopWithParam:model.store_id success:^{
        [Common AppShowToast:@"店铺删除成功"];
        [self requestAllOrder:NO];
    } faulre:^(NSError *error) {
        DLog(@"店铺删除失败");
    }];
}


@end

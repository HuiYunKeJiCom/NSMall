//
//  ADGoodsListViewCell.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/1.
//  Copyright © 2018年 Adel. All rights reserved.
//  下单页面-商品列表

#import "ADGoodsListViewCell.h"
#import "ADOrderGoodsView.h"

#import "LZShopModel.h"
#import "LZGoodsModel.h"
#import "ADCartGoodsListTableViewCell.h"
#import "ADCartTableHeaderView.h"

@interface ADGoodsListViewCell()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *allOrderTable;
@property (nonatomic, strong) UIView  *bgView;

@end

@implementation ADGoodsListViewCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
//        [self createGoodsViewsWithNSInteger:3];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.allOrderTable];
//    [self makeConstraints];
//    [self requestAllOrder:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeConstraints];
}

#pragma mark - 填充数据
-(void)loadDataWithArray:(NSMutableArray<LZShopModel *> *)dataArray{
    self.allOrderTable.data = dataArray;
    self.allOrderTable.noDataView.hidden = self.allOrderTable.data.count;
    for (LZShopModel *shopModel in dataArray) {
        for (LZGoodsModel *model in shopModel.goodsCarts) {
            NSLog(@"填充数据这里 立即下单model.spec_info = %@",model.spec_info);
        }
    }
    
    [self.allOrderTable reloadData];
}

//- (void)createGoodsViewsWithNSInteger:(NSInteger)temp{
//    for(int i=0;i<temp;i++){
//        ADOrderGoodsView *goodsView = [[ADOrderGoodsView alloc]initWithFrame:CGRectMake(0, 91*i, kScreenWidth, 90)];
//        [self.bgView addSubview:goodsView];
//    }
//}

#pragma mark - Constraints
- (void)makeConstraints {
    WEAKSELF
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [self.allOrderTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.bgView);
        //        make.top.equalTo(self.view.mas_bottom).with.offset(GetScaleWidth(10));
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

- (BaseTableView *)allOrderTable {
    if (!_allOrderTable) {
        _allOrderTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _allOrderTable.delegate = self;
        _allOrderTable.dataSource = self;
        _allOrderTable.isLoadMore = YES;
        _allOrderTable.isRefresh = YES;
        _allOrderTable.delegateBase = self;
        
        [_allOrderTable registerClass:[ADCartGoodsListTableViewCell class] forCellReuseIdentifier:@"ADCartGoodsListTableViewCell"];
        [_allOrderTable registerClass:[ADCartTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"ADCartTableHeaderView"];
    }
    return _allOrderTable;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    LZShopModel *model = [self.self.allOrderTable.data objectAtIndex:section];
    return model.goodsCarts.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.allOrderTable.data.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ADCartTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ADCartTableHeaderView"];
    view.contentView.backgroundColor = [UIColor whiteColor];
    LZShopModel *model = [self.allOrderTable.data objectAtIndex:section];
    view.titleString = model.store_name;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return LZTableViewHeaderHeight;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//
//    return 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenWidth == 320 ? 120 : GetScaleWidth(120);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADCartGoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADCartGoodsListTableViewCell"];
    if (cell == nil) {
        cell = [[ADCartGoodsListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ADCartGoodsListTableViewCell"];
    }
    
    LZShopModel *shopModel = self.allOrderTable.data[indexPath.section];
    LZGoodsModel *model = [shopModel.goodsCarts objectAtIndex:indexPath.row];
//    cell.model = model;
    NSLog(@"立即下单model = %@",model.mj_keyValues);
    NSLog(@"立即下单model.spec_info = %@",model.spec_info);
    [cell reloadDataWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (self.allOrderTable.data.count > indexPath.row) {
    //        WLTransferAccountModel *model = self.accountTable.data[indexPath.row];
    //        NSLog(@"查看的信息model = %@",model.mj_keyValues);
    //        WLInformDetailCtrl *ctrl = [[WLInformDetailCtrl alloc] init];
    //        ctrl.accountModel = model;
    //        ctrl.messageDetail = NO;
    //        [self.navigationController pushViewController:ctrl animated:YES];
    //    }
}

- (void)baseTableVIew:(BaseTableView *)tableView refresh:(BOOL)flag {
//    [self requestAllOrder:NO];
}

- (void)baseTableView:(BaseTableView *)tableView loadMore:(BOOL)flag {
//    [self requestAllOrder:YES];
}

@end

//
//  NSCategoryVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCategoryVC.h"
#import "NSCategoryTableViewCell.h"
#import "HomePageAPI.h"
#import "ADOrderTopToolView.h"
#import "NSSecondaryCategoryVC.h"


@interface NSCategoryVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *goodsTable;

@end

@implementation NSCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.goodsTable];
    [self setUpNavTopView];
    [self makeConstraints];
    [self requestAllOrder:NO];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.hidden = NO;
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"类目")];
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

- (void)requestAllOrder:(BOOL)more {
    [self.goodsTable updateLoadState:more];

    WEAKSELF
    [HomePageAPI getProductCategoryList:nil success:^(CategoryListModel * _Nullable result) {
        NSLog(@"获取商品分类成功");
        
        weakSelf.goodsTable.data = [NSMutableArray arrayWithArray:result.categoryList];
        [self.goodsTable updatePage:more];
        DLog(@"商品类别数量count = %lu",self.goodsTable.data.count);
        self.goodsTable.noDataView.hidden = self.goodsTable.data.count;
        [self.goodsTable reloadData];
    } failure:^(NSError *error) {
        NSLog(@"获取商品分类失败");
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
        [_goodsTable registerClass:[NSCategoryTableViewCell class] forCellReuseIdentifier:@"NSCategoryTableViewCell"];
        
    }
    return _goodsTable;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsTable.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GetScaleWidth(43);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCategoryTableViewCell"];
    if (self.goodsTable.data.count > indexPath.row) {
        CategoryModel *model = self.goodsTable.data[indexPath.row];
        NSLog(@"model = %@",model.mj_keyValues);
        cell.myInfoModel = model;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSCategoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CategoryModel *model = cell.myInfoModel;
    if(model.children.count == 0){
        if (self.stringBlock) {
            self.stringBlock(model);
        }

        [self.navigationController popViewControllerAnimated:YES];
    }else{
//        跳到下一级
        NSSecondaryCategoryVC *ctrl = [[NSSecondaryCategoryVC alloc] init];
        [ctrl getDataWithCategoryModel:model];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
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


@end

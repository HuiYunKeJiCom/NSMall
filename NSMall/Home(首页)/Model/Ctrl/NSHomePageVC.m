//
//  NSHomePageVC.m
//  NSMall
//
//  Created by apple on 2018/4/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSHomePageVC.h"
#import "LoginAPI.h"
#import "HomePageAPI.h"
#import "NSGoodsShowCell.h"
#import "ProductListItemModel.h"

@interface NSHomePageVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>

@property (nonatomic,strong)BaseTableView *tableView;//


@end

@implementation NSHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self buildUI];
    [self requestAllOrder:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self layoutUI];
    
}

- (void)buildUI{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor lightGrayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.isLoadMore = YES;
    _tableView.isRefresh = YES;
    _tableView.delegateBase = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[NSGoodsShowCell class] forCellReuseIdentifier:@"NSGoodsShowCell"];
    
}

- (void)layoutUI{
    _tableView.size = CGSizeMake(AppWidth, AppHeight - TopBarHeight - TabBarHeight);
}

- (void)requestAllOrder:(BOOL)more {
    [self.tableView updateLoadState:more];

    WEAKSELF
    [HomePageAPI getProductList:nil success:^(ProductListModel * _Nullable result) {
        NSLog(@"获取产品列表成功");
        
        weakSelf.tableView.data = [NSMutableArray arrayWithArray:result.productList];
        [self.tableView updatePage:more];
        self.tableView.noDataView.hidden = self.tableView.data.count;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"获取产品列表失败");
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GetScaleWidth(275);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableView.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //设置间隔高度
    return 5;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(5))];
    sectionView.backgroundColor = [UIColor lightGrayColor];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSGoodsShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSGoodsShowCell"];
    if (self.tableView.data.count > indexPath.row) {
        ProductListItemModel *model = self.tableView.data[indexPath.row];
        cell.productModel = model;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

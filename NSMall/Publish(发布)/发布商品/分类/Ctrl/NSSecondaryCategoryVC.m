//
//  NSSecondaryCategoryVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSSecondaryCategoryVC.h"
#import "NSGoodsPublishVC.h"

@interface NSSecondaryCategoryVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *goodsTable;
@property(nonatomic,strong)ADOrderTopToolView *topToolView;/* 自定义导航栏 */
@end

@implementation NSSecondaryCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.goodsTable];
    [self setUpNavTopView];
    [self makeConstraints];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    self.topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    self.topToolView.backgroundColor = kWhiteColor;
    WEAKSELF
    self.topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self.view addSubview:self.topToolView];
    
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    [self.goodsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
        //        make.top.equalTo(self.view.mas_bottom).with.offset(GetScaleWidth(10));
    }];
    
}

-(void)getDataWithCategoryModel:(CategoryModel *)model{
    [self.topToolView setTopTitleWithNSString:KLocalizableStr(model.name)];
    [self.goodsTable updateLoadState:NO];
    self.goodsTable.data = [NSMutableArray arrayWithArray:model.children];
    [self.goodsTable updatePage:NO];
    self.goodsTable.noDataView.hidden = self.goodsTable.data.count;
    [self.goodsTable reloadData];
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
    return GetScaleWidth(52);
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
    //进入下一级分类
    NSCategoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CategoryModel *model = cell.myInfoModel;
    if(model.children.count == 0){
        //返回页面A 得改用导航控制器
//        if (self.stringBlock) {
//            self.stringBlock(model.name);
//        }
        NSGoodsPublishVC *ctrl = [[NSGoodsPublishVC alloc] init];
        ctrl.categoryString = model.name;
        [self presentViewController:ctrl animated:YES completion:nil];
        
    }else{
        //        跳到下一级
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


@end

//
//  NSSortVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/25.
//  Copyright © 2018年 www. All rights reserved.
//  分类

#import "NSSortVC.h"
#import "ADOrderTopToolView.h"
#import "NSSortLeftTVCell.h"
#import "CategoryModel.h"
#import "HomePageAPI.h"

@interface NSSortVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *leftTV;/* 左边的tableview */
@property (nonatomic, strong) BaseTableView         *rightTV;/* 右边的tableview */
@property(nonatomic)NSInteger selectRow;/* 被选中的行数 */
@end

@implementation NSSortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.leftTV];
    [self.view addSubview:self.rightTV];
    [self setUpNavTopView];
    [self makeConstraints];
    [self requestAllOrder:NO];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.hidden = NO;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"分类")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:topToolView];
}

#pragma mark - LazyLoad
- (BaseTableView *)leftTV {
    if (!_leftTV) {
        _leftTV = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTV.backgroundColor = KBGCOLOR;
        _leftTV.delegate = self;
        _leftTV.dataSource = self;
        _leftTV.isLoadMore = YES;
        _leftTV.isRefresh = YES;
        _leftTV.delegateBase = self;
        _leftTV.showsVerticalScrollIndicator = NO;
        _leftTV.tag = 10;
        [_leftTV registerClass:[NSSortLeftTVCell class] forCellReuseIdentifier:@"NSSortLeftTVCell"];
    }
    return _leftTV;
}

- (BaseTableView *)rightTV {
    if (!_rightTV) {
        _rightTV = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTV.backgroundColor = kWhiteColor;
        _rightTV.delegate = self;
        _rightTV.dataSource = self;
        _rightTV.isLoadMore = YES;
        _rightTV.isRefresh = YES;
        _rightTV.delegateBase = self;
        _rightTV.showsVerticalScrollIndicator = NO;
        _rightTV.tag = 20;
        [_rightTV registerClass:[NSSortLeftTVCell class] forCellReuseIdentifier:@"NSSortLeftTVCell"];
    }
    return _rightTV;
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    [self.leftTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
        make.right.equalTo(self.view.mas_left).with.offset(128.0/360.0*kScreenWidth);
    }];
    
    [self.rightTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
        make.left.equalTo(self.leftTV.mas_right);
    }];
    
}

- (void)requestAllOrder:(BOOL)more {
    [self.leftTV updateLoadState:more];
    [self.rightTV updateLoadState:more];
    
    WEAKSELF
    [HomePageAPI getProductCategoryList:nil success:^(CategoryListModel * _Nullable result) {
        NSLog(@"获取商品分类成功");

        weakSelf.leftTV.data = [NSMutableArray arrayWithArray:result.categoryList];
        [weakSelf.leftTV updatePage:more];
        weakSelf.leftTV.noDataView.hidden = weakSelf.leftTV.data.count;
        [weakSelf.leftTV reloadData];
        
        CategoryModel *model = result.categoryList[0];
        if(model.children.count >0){
            weakSelf.rightTV.data = [NSMutableArray arrayWithArray:model.children];
            [weakSelf.rightTV updatePage:more];
            weakSelf.rightTV.noDataView.hidden = weakSelf.rightTV.data.count;
            [weakSelf.rightTV reloadData];
            
            //默认选择第一行（注意一定要在加载完数据之后）
            [weakSelf.leftTV selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    } failure:^(NSError *error) {
        NSLog(@"获取商品分类失败");
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == 10){
        return self.leftTV.data.count;
    }else{
        return self.rightTV.data.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GetScaleWidth(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSSortLeftTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSSortLeftTVCell"];
    if(tableView.tag == 10){
        if (self.leftTV.data.count > indexPath.row) {
            CategoryModel *model = self.leftTV.data[indexPath.row];
            cell.model = model;
        }
    }else{
        if (self.rightTV.data.count > indexPath.row) {
            CategoryModel *model = self.rightTV.data[indexPath.row];
            cell.model = model;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 10){
        CategoryModel *model = self.leftTV.data[indexPath.row];
        self.selectRow = indexPath.row;
        self.rightTV.data =  [NSMutableArray arrayWithArray:model.children];
        [self.rightTV reloadData];
    }else{
        CategoryModel *rightModel = self.rightTV.data[indexPath.row];
        if(rightModel.children.count>0){
            
        }
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

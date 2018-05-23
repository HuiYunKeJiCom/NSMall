//
//  NSSecondaryCategoryVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSSecondaryCategoryVC.h"
#import "NSGoodsPublishVC.h"
#import "NSCategoryTV.h"
#import "ADLMyInfoModel.h"

@interface NSSecondaryCategoryVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,NSCategoryTVDelegate>
@property (nonatomic, strong) BaseTableView         *goodsTable;
@property(nonatomic,strong)ADOrderTopToolView *topToolView;/* 自定义导航栏 */
@property (nonatomic,strong)NSArray<CategoryModel *> *children;//
@property(nonatomic,strong)NSMutableDictionary *dict;/* 改变高度的字典 */

@end

@implementation NSSecondaryCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dict = [NSMutableDictionary dictionary];
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
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.topToolView];
    
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    [self.goodsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
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
    if(self.dict[@"indexPath"]){
        NSInteger row = [self.dict[@"indexPath"] integerValue];
        float height = [self.dict[@"height"] floatValue];
        if(indexPath.row == row){
            return height;
        }else{
            return GetScaleWidth(43);
        }
    }else{
       return GetScaleWidth(43);
    }
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
        for (NSGoodsPublishVC *ctrl in self.navigationController.viewControllers) {
            if([ctrl isKindOfClass:[NSGoodsPublishVC class]]){
                ctrl.model = model;
                [self.navigationController popToViewController:ctrl animated:YES];
            }
        }
    }else{
        if(cell.isShow){
            [self.dict setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"indexPath"];
            float height = GetScaleWidth(43);
            [self.dict setValue:[NSNumber numberWithFloat:height] forKey:@"height"];
            cell.isShow = NO;
            for (UIView *view in cell.subviews) {
                if([view isKindOfClass:[NSCategoryTV class]]){
                    [view removeFromSuperview];
                }
            }
            [self.goodsTable reloadData];
        }else{
            CGRect frame2 = cell.frame;
            float height = GetScaleWidth(43)*model.children.count+frame2.size.height;
            [self.dict setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"indexPath"];
            [self.dict setValue:[NSNumber numberWithFloat:height] forKey:@"height"];
            //        展示所有分类
            NSCategoryTV *otherTableView = [[NSCategoryTV alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            otherTableView.backgroundColor = kClearColor;
            otherTableView.x = 0;
            otherTableView.y = GetScaleWidth(43);
            otherTableView.size = CGSizeMake(kScreenWidth, GetScaleWidth(43)*model.children.count);
            otherTableView.bounces = NO;
            otherTableView.tbDelegate = self;
            otherTableView.isRefresh = NO;
            otherTableView.isLoadMore = NO;
            if (@available(iOS 11.0, *)) {
                otherTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                self.automaticallyAdjustsScrollViewInsets = NO;
            }
            [cell addSubview:otherTableView];
            
            for(int i=0;i<model.children.count;i++){
                CategoryModel *childrenModel = model.children[i];
                [otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(childrenModel.name) imageName:nil num:nil]];
            }
            self.children = model.children;
            cell.isShow = YES;
            [self.goodsTable reloadData];
        }
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

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"有没有调这里");
    CategoryModel *model = self.children[indexPath.section];
    //返回页面A 得改用导航控制器
    for (NSGoodsPublishVC *ctrl in self.navigationController.viewControllers) {
        if([ctrl isKindOfClass:[NSGoodsPublishVC class]]){
            ctrl.model = model;
            [self.navigationController popToViewController:ctrl animated:YES];
        }
    }
}

-(NSArray *)children{
    if (!_children) {
        _children = [NSArray array];
    }
    return _children;
}

@end

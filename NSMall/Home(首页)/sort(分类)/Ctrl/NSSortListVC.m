//
//  NSSortListVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSSortListVC.h"
#import "ProductListItemModel.h"
#import "ADOrderTopToolView.h"
#import "HomePageAPI.h"
#import "NSGoodsShowCellTest.h"
#import "SearchModel.h"
#import "UIButton+Bootstrap.h"

@interface NSSortListVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *dataTV;
@property(nonatomic)NSInteger currentPage;/* 当前页数 */

@end

@implementation NSSortListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KBGCOLOR;
    [self.view addSubview:self.dataTV];
    [self setUpNavTopView];
    [self makeConstraints];
    [self requestAllOrder:NO];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(self.titleString)];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    [self.dataTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
                make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight+1);
    }];
    
}

-(SearchParam *)param{
    if (!_param) {
        DLog(@"参数赋值");
        _param = [SearchParam new];
        self.currentPage = 1;
        _param.currentPage = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.currentPage]];
    }
    return _param;
}

//-(void)setParam:(SearchParam *)param{
//    DLog(@"参数赋值");
//    _param = param;
//
//}

- (void)requestAllOrder:(BOOL)more {
    [self.dataTV updateLoadState:more];
    
    WEAKSELF
    [HomePageAPI searchProductOrShop:self.param success:^(SearchModel *result) {
        NSLog(@"获取列表成功");
        weakSelf.dataTV.data = [NSMutableArray arrayWithArray:result.productList];
        [self.dataTV updatePage:more];
        self.dataTV.noDataView.hidden = self.dataTV.data.count;
        [self.dataTV reloadData];
    } failure:^(NSError *error) {
        NSLog(@"获取列表失败");
        [self cutCurrentPage];
    }];
    
}

- (BaseTableView *)dataTV {
    if (!_dataTV) {
        _dataTV = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _dataTV.backgroundColor = KBGCOLOR;
        _dataTV.delegate = self;
        _dataTV.dataSource = self;
        _dataTV.isLoadMore = YES;
        _dataTV.isRefresh = YES;
        _dataTV.delegateBase = self;
        [_dataTV registerClass:[NSGoodsShowCellTest class] forCellReuseIdentifier:@"NSGoodsShowCellTest"];
        
    }
    return _dataTV;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return GetScaleWidth(0);
    }else{
        //设置间隔高度
        return GetScaleWidth(6);
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(10))];
    sectionView.backgroundColor = KBGCOLOR;
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataTV.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GetScaleWidth(259);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSGoodsShowCellTest *cell = [tableView dequeueReusableCellWithIdentifier:@"NSGoodsShowCellTest"];
    if (!cell) {
        cell = [[NSGoodsShowCellTest alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSGoodsShowCellTest"];
    }
    WEAKSELF
    if (self.dataTV.data.count > indexPath.section) {
        ProductListItemModel *model = self.dataTV.data[indexPath.section];
        cell.productModel = model;
        cell.likeBtnClickBlock = ^{
            [weakSelf likeClickAtIndexPath:indexPath];
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

-(void)cutCurrentPage{
    if(self.currentPage != 1){
        self.currentPage -= 1;
    }
}

-(void)likeClickAtIndexPath:(NSIndexPath *)indexPath{
    NSGoodsShowCellTest *cell = [self.dataTV cellForRowAtIndexPath:indexPath];
    [HomePageAPI changeProductLikeState:cell.productModel.product_id success:^(NSLikeModel *model) {
        DLog(@"点赞成功");
        DLog(@"model = %@",model.mj_keyValues);
        if(cell.isLike){
            [cell.likeBtn setImageWithTitle:IMAGE(@"ico_like") withTitle:@"喜欢" position:@"left" font:UISystemFontSize(14) forState:UIControlStateNormal];
            cell.isLike = NO;
        }else{
            [cell.likeBtn setImageWithTitle:IMAGE(@"home_ico_like_press") withTitle:[NSString stringWithFormat:@"喜欢(%@)",[NSNumber numberWithInteger:model.like_number]] position:@"left" font:UISystemFontSize(14) forState:UIControlStateNormal];
            cell.isLike = YES;
        }
        
    } failure:^(NSError *error) {
        DLog(@"点赞失败");
    }];
}

@end

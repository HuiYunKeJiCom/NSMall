//
//  NSGoodsVM.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGoodsVM.h"
#import "NSGoodsShowCellTest.h"

@interface NSGoodsVM()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic,strong)NSMutableArray *properties;
@end

@implementation NSGoodsVM
@synthesize goodsTV = _goodsTV;

-(BaseTableView *)goodsTV{
    if (!_goodsTV) {
        _goodsTV = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, AppHeight - TopBarHeight) style:UITableViewStyleGrouped];
        _goodsTV.backgroundColor = [UIColor lightGrayColor];
        _goodsTV.separatorColor = [UIColor clearColor];
        _goodsTV.delegate = self;
        _goodsTV.dataSource = self;
        _goodsTV.isLoadMore = YES;
        _goodsTV.isRefresh = YES;
        _goodsTV.delegateBase = self;
        _goodsTV.tableFooterView = [UIView new];
//        [self addSubview:_goodsTV];
        _goodsTV.scrollEnabled = NO;
        _goodsTV.estimatedRowHeight = GetScaleWidth(259);
        [_goodsTV registerClass:[NSGoodsShowCellTest class] forCellReuseIdentifier:@"NSGoodsShowCellTest"];
    }
    return _goodsTV;
}

- (void)layoutWithProperty:(NSArray *)propertyies{
    _properties = propertyies.mutableCopy;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.goodsTV.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        //设置间隔高度
        return GetScaleWidth(6);
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(6))];
        sectionView.backgroundColor = KBGCOLOR;
        return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;//把高度设置很小，效果可以看成footer的高度等于0
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSGoodsShowCellTest *cell = [tableView dequeueReusableCellWithIdentifier:@"NSGoodsShowCellTest"];
    if (!cell) {
        cell = [[NSGoodsShowCellTest alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSGoodsShowCellTest"];
    }
    WEAKSELF
    ProductListItemModel *model = self.goodsTV.data[indexPath.section];
    cell.productModel = model;
    cell.likeBtnClickBlock = ^{
        [weakSelf likeClickAtIndexPath:indexPath];
    };

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DLog(@"跳转到详情页");
//    NSGoodsShowCellTest *cell = [self.goodsTV cellForRowAtIndexPath:indexPath];
//    DLog(@"product_id = %@",cell.productModel.product_id);
//    NSGoodsDetailVC *detailVC = [NSGoodsDetailVC new];
//    [detailVC getDataWithProductID:cell.productModel.product_id andCollectNum:cell.productModel.favorite_number];
//    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)likeClickAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"点击喜欢");
}

-(void)reloadData{
    [self.goodsTV reloadData];
}

@end

//
//  NSShopVM.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSShopVM.h"
//#import "NSMyShopTVCell.h"
#import "NSShopTVCell.h"

@interface NSShopVM()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic,strong)NSMutableArray *properties;

@end

@implementation NSShopVM
@synthesize shopTV = _shopTV;

-(BaseTableView *)shopTV{
    if (!_shopTV) {
        _shopTV = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, AppHeight - TopBarHeight) style:UITableViewStyleGrouped];
        _shopTV.backgroundColor = KBGCOLOR;
        _shopTV.separatorColor = [UIColor clearColor];
        _shopTV.delegate = self;
        _shopTV.dataSource = self;
        _shopTV.isLoadMore = YES;
        _shopTV.isRefresh = YES;
        _shopTV.delegateBase = self;
        _shopTV.tableFooterView = [UIView new];
        //        [self addSubview:_goodsTV];
        _shopTV.scrollEnabled = NO;
        _shopTV.estimatedRowHeight = GetScaleWidth(259);
        [_shopTV registerClass:[NSShopTVCell class] forCellReuseIdentifier:@"NSShopTVCell"];
    }
    return _shopTV;
}

- (void)layoutWithProperty:(NSArray *)propertyies{
    _properties = propertyies.mutableCopy;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.shopTV.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GetScaleWidth(200);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        //设置间隔高度
        return GetScaleWidth(10);
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(10))];
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
    
    NSShopTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSShopTVCell"];
    if (!cell) {
        cell = [[NSShopTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSShopTVCell"];
    }
//    WEAKSELF
    NSShopListItemModel *model = self.shopTV.data[indexPath.section];
    cell.model = model;
    
    return cell;
    
}

//-(void)deleteShopWith:(NSShopListItemModel *)model{

//    [MyShopAPI delShopWithParam:model.store_id success:^{
//        [Common AppShowToast:@"店铺删除成功"];
//        //        sleep(1);
//        [self requestAllOrder:NO];
//        [self.goodsTable reloadData];
//    } faulre:^(NSError *error) {
//        DLog(@"店铺删除失败");
//    }];
//}


@end

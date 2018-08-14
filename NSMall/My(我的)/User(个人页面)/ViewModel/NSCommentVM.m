//
//  NSCommentVM.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCommentVM.h"
//#import "NSShopTVCell.h"
#import "NSCommentTVCell.h"

@interface NSCommentVM()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic,strong)NSMutableArray *properties;

@end

@implementation NSCommentVM

@synthesize commentTV = _commentTV;

-(BaseTableView *)commentTV{
    if (!_commentTV) {
        _commentTV = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, AppHeight - TopBarHeight) style:UITableViewStyleGrouped];
        _commentTV.backgroundColor = KBGCOLOR;
        _commentTV.separatorColor = [UIColor clearColor];
        _commentTV.delegate = self;
        _commentTV.dataSource = self;
        _commentTV.isLoadMore = YES;
        _commentTV.isRefresh = YES;
        _commentTV.delegateBase = self;
        _commentTV.tableFooterView = [UIView new];
        //        [self addSubview:_goodsTV];
        _commentTV.scrollEnabled = NO;
        _commentTV.estimatedRowHeight = GetScaleWidth(259);
        [_commentTV registerClass:[NSCommentTVCell class] forCellReuseIdentifier:@"NSCommentTVCell"];
    }
    return _commentTV;
}

- (void)layoutWithProperty:(NSArray *)propertyies{
    _properties = propertyies.mutableCopy;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentTV.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GetScaleWidth(120);
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
    
    NSCommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCommentTVCell"];
    if (!cell) {
        cell = [[NSCommentTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSCommentTVCell"];
    }
    //    WEAKSELF
    NSCommentItemModel *model = self.commentTV.data[indexPath.section];
    cell.model = model;
    cell.deleteBtnClickBlock = ^{
        [self delCommentWith:indexPath];
    };
    
    return cell;
    
}

-(void)delCommentWith:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(delCommentWith:)]) {
        [_delegate delCommentWith:indexPath];
    }
}

@end

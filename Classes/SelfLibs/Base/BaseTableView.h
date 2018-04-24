//
//  BaseTableView.h
//  Economic
//
//  Created by occ on 15/8/3.
//  Copyright (c) 2015年 occ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTableViewDelegate;


@interface BaseTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) id <BaseTableViewDelegate> delegateBase;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,assign) NSInteger      currentPage;
@property (nonatomic,assign) BOOL           isRefresh;
@property (nonatomic,assign) BOOL           isLoadMore;
@property (nonatomic, strong) UIView        *noDataView;
@property (nonatomic, strong) UILabel       *mesageLab;
@property (nonatomic, strong) UIImageView   *imgView;

/** 错误提示*/
@property (nonatomic, copy) NSString        *errorMessage;

@property (nonatomic,assign) int            waterline;   //用于删除数据后加载更多数据

//不同商品类别的区分
@property (nonatomic, strong) NSString      *produType;//商品类别

@property (nonatomic, assign) BOOL          isGifRefreshHeader;


//修改加载/刷新逻辑处理
- (void)updateLoadState:(BOOL)loadMore;

- (void)updatePage:(BOOL)loadMore;

@end

@protocol BaseTableViewDelegate <NSObject>

@optional

-(void)baseTableView:(BaseTableView *)tableView tapIndexPath:(NSIndexPath *)indexPath;
-(void)baseTableVIew:(BaseTableView *)tableView refresh:(BOOL)flag;
-(void)baseTableView:(BaseTableView *)tableView loadMore:(BOOL)flag;
@end

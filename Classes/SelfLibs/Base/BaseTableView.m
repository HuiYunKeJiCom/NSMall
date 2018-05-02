//
//  BaseTableView.m
//  Economic
//
//  Created by occ on 15/8/3.
//  Copyright (c) 2015年 occ. All rights reserved.
//

#import "BaseTableView.h"
#import "MJRefreshHeader.h"
#import "BaseRefreshGifHeader.h"

////加载数据失败 问号脸
static NSString * const kLock_IconFace                         =  @"icon_face";

@implementation BaseTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initView];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self _initView];
}

-(void)_initView {
    self.delegate = self;
    self.dataSource = self;
    
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.currentPage = 1;
    self.data = [[NSMutableArray alloc] init];

    self.noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, kScreenWidth, 120)];

    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 133) / 2.0, 0, 133, 94)];
    self.imgView.image = [UIImage imageNamed:@"group_apply_icon_empty"];
    [_noDataView addSubview:self.imgView];
    
    self.mesageLab = [[UILabel alloc] initWithFrame:CGRectMake((30)/2.0, self.imgView.frame.origin.y + 94+30, kScreenWidth-30, 30)];
    self.mesageLab.text = KLocalizableStr(@"暂时没有数据");
    
    self.mesageLab.font = [UIFont systemFontOfSize:15];
    self.mesageLab.textColor = [UIColor lightGrayColor];
    self.mesageLab.textAlignment = NSTextAlignmentCenter;

    [_noDataView addSubview:self.mesageLab];
    _noDataView.hidden = YES;
    [self addSubview:_noDataView];
}

- (void)setErrorMessage:(NSString *)errorMessage {
    _errorMessage = errorMessage;
    self.mesageLab.text = _errorMessage;
}

-(void)setIsRefresh:(BOOL)isRefresh {
    if (_isRefresh != isRefresh) {
        _isRefresh = isRefresh;
        if (_isRefresh) {
            [self isRefreshTable];
        }
    }
}

-(void)setIsLoadMore:(BOOL)isLoadMore {
    if (_isLoadMore != isLoadMore) {
        _isLoadMore = isLoadMore;
        
        if (!_isLoadMore) {
            [self.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.mj_footer resetNoMoreData];
        }
    }
}

- (void)setIsGifRefreshHeader:(BOOL)isGifRefreshHeader {
    
    _isGifRefreshHeader = isGifRefreshHeader;
    if (_isGifRefreshHeader) {
        self.mj_header = [BaseRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];

    } else {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    }
}

-(void)isRefreshTable {
    //    [self addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    [self addFooterWithTarget:self action:@selector(footerRereshing)];
    if (self.isGifRefreshHeader) {
        self.mj_header = [BaseRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    } else {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    }
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_data.count == 0) {
        return 0;
    }
    return _data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegateBase respondsToSelector:@selector(baseTableView:tapIndexPath:)]) {
        [_delegateBase baseTableView:self tapIndexPath:indexPath];
    }
}

-(void)headerRereshing {
    NSLog(@"refresh");
    if ([_delegateBase respondsToSelector:@selector(baseTableVIew:refresh:)]) {
        [_delegateBase baseTableVIew:self refresh:YES];
    }
}

-(void)footerRereshing {
    NSLog(@"loadmore");
    if (_isLoadMore) {
        if ([_delegateBase respondsToSelector:@selector(baseTableView:loadMore:)]) {
            [_delegateBase baseTableView:self loadMore:YES];
        }
    } else {
//延迟1s
        [self.mj_footer endRefreshing];
    }
}

#pragma mark - 状态

- (void)updateLoadState:(BOOL)loadMore {
    
    if (loadMore) {
        [self.mj_footer endRefreshing];
    } else {
        [self.data removeAllObjects];
        self.currentPage = 1;
        [self.mj_header endRefreshing];
    }
}

- (void)updatePage:(BOOL)loadMore {
    
    if (loadMore) {
        self.currentPage = self.currentPage + 1;
    } else {
        self.currentPage = 2;
    }
}


@end

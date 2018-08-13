//
//  NSRedpacketRecordVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSRedpacketRecordVC.h"
#import "NSRPRecordModel.h"
#import "NSRecordItemModel.h"

#import "NSRPRecordTVCell.h"
#import "NSMessageAPI.h"
#import "ADOrderTopToolView.h"
#import "NSCommonParam.h"

@interface NSRedpacketRecordVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *SV;/* 总体 */
@property(nonatomic,strong)UIView *totalView;/* 总体情况 */
@property(nonatomic,strong)UIImageView *avatarView;/* 头像 */
@property(nonatomic,strong)UILabel *nickLab;/* 昵称 */
@property(nonatomic,strong)UILabel *amount;/* 金额 */
@property(nonatomic,strong)UILabel *receiveCount;/* 收到个数 */
@property(nonatomic,strong)UILabel *receiveLab;/* 收到 */
@property(nonatomic,strong)UILabel *luckyCount;/* 收到个数 */
@property(nonatomic,strong)UILabel *luckyLab;/* 收到 */
@property (nonatomic, strong) BaseTableView         *goodsTable;
@property(nonatomic)NSInteger currentPage;/* 当前页数 */
@property(nonatomic,strong)NSRPRecordModel *recordModel;/* 红包记录模型 */


@end

@implementation NSRedpacketRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGCOLOR;
    
    [self buildUI];
    [self setUpNavTopView];
    [self makeConstraints];
    self.currentPage = 1;
    [self requestAllOrder:NO];
}

-(void)buildUI{
    [self.view addSubview:self.SV];
    [self.SV addSubview:self.totalView];
    [self.SV addSubview:self.avatarView];
    [self.SV addSubview:self.nickLab];
    [self.SV addSubview:self.amount];
    [self.SV addSubview:self.receiveCount];
    [self.SV addSubview:self.receiveLab];
    [self.SV addSubview:self.luckyLab];
    [self.SV addSubview:self.luckyCount];
    [self.SV addSubview:self.goodsTable];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:@"红包记录"
     ];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    WEAKSELF
    
    [self.SV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(TopBarHeight+1);
        make.height.mas_equalTo(kScreenHeight-TopBarHeight);
    }];
    
    [self.totalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.SV.mas_left);
        make.right.equalTo(weakSelf.SV.mas_right);
        make.top.equalTo(weakSelf.SV.mas_top);
        make.height.mas_equalTo(kScreenHeight*0.5);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.SV.mas_centerX);
        make.top.equalTo(weakSelf.SV.mas_top).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.SV.mas_centerX);
        make.top.equalTo(weakSelf.avatarView.mas_bottom).with.offset(20);
    }];
    
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.SV.mas_centerX);
        make.top.equalTo(weakSelf.nickLab.mas_bottom).with.offset(40);
    }];
    
    [self.receiveCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.SV.mas_centerX).with.offset(-kScreenWidth*0.25);
        make.top.equalTo(weakSelf.amount.mas_bottom).with.offset(60);
    }];
    
    [self.receiveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.SV.mas_centerX).with.offset(-kScreenWidth*0.25);
        make.top.equalTo(weakSelf.receiveCount.mas_bottom).with.offset(5);
    }];
    
    [self.luckyCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.SV.mas_centerX).with.offset(kScreenWidth*0.25);
        make.top.equalTo(weakSelf.amount.mas_bottom).with.offset(60);
    }];
    
    [self.luckyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.SV.mas_centerX).with.offset(kScreenWidth*0.25);
        make.top.equalTo(weakSelf.luckyCount.mas_bottom).with.offset(5);
    }];
    
    [self.goodsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(kScreenHeight*0.5+TopBarHeight);
        make.height.mas_equalTo(kScreenHeight);
    }];
    
}

- (void)requestAllOrder:(BOOL)more {
    [self.goodsTable updateLoadState:more];
    
    [self.goodsTable.data removeAllObjects];
    
    NSCommonParam *param = [NSCommonParam new];
    param.currentPage = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.currentPage]];
    
    WEAKSELF
    [NSMessageAPI getRedpacketLogs:param success:^(NSRPRecordModel * _Nullable result) {
        NSLog(@"获取红包记录成功");
        weakSelf.recordModel = result;
        
        [weakSelf.avatarView sd_setImageWithURL:[NSURL URLWithString:result.user_image]];
        weakSelf.nickLab.text = [NSString stringWithFormat:@"%@共收到",result.user_name];
        NSString *text = [NSString stringWithFormat:@"N%.2f",result.amount_total];
        
        NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
        NSRange rang = [text rangeOfString:@"N"];
        [LZString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
        [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:rang];
        [LZString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:rang];
        _amount.attributedText = LZString;
        
        weakSelf.receiveCount.text = [NSString stringWithFormat:@"%lu",result.redpacket_total];
        weakSelf.receiveLab.text = @"收到红包";
        weakSelf.luckyCount.text = [NSString stringWithFormat:@"%lu",result.lucky_total];
        weakSelf.luckyLab.text = @"手气最佳";
        
        weakSelf.goodsTable.data = [NSMutableArray arrayWithArray:result.list];
        [self.goodsTable updatePage:more];
        self.goodsTable.noDataView.hidden = self.goodsTable.data.count;
        [self.goodsTable reloadData];
        
        if(result.list.count >6){
            weakSelf.SV.contentSize = CGSizeMake(0, GetScaleWidth(50)*(result.list.count-6));
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"获取红包记录失败");
        [self cutCurrentPag];
    }];
    
}

- (BaseTableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodsTable.backgroundColor = kWhiteColor;
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.isLoadMore = YES;
        _goodsTable.userInteractionEnabled = NO;
        _goodsTable.isRefresh = YES;
        _goodsTable.delegateBase = self;
        [_goodsTable registerClass:[NSRPRecordTVCell class] forCellReuseIdentifier:@"NSRPRecordTVCell"];
        
    }
    return _goodsTable;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(section == 0){
        return GetScaleWidth(0);
//    }else{
//        //设置间隔高度
//        return GetScaleWidth(10);
//    }
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
    return self.goodsTable.data.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GetScaleWidth(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSRPRecordTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSRPRecordTVCell"];
    if (self.goodsTable.data.count > indexPath.section) {
        NSRecordItemModel *model = self.goodsTable.data[indexPath.section];
        //        NSLog(@"model = %@",model.mj_keyValues);
        cell.model = model;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)baseTableVIew:(BaseTableView *)tableView refresh:(BOOL)flag {
    [self requestAllOrder:NO];
}

- (void)baseTableView:(BaseTableView *)tableView loadMore:(BOOL)flag {
    if(tableView.data.count >20){
        self.currentPage += 1;
        [self requestAllOrder:YES];
    }else{
        [self requestAllOrder:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cutCurrentPag{
    if(self.currentPage != 1){
        self.currentPage -= 1;
    }
}

- (UIScrollView *)SV {
    if (!_SV) {
        _SV = [[UIScrollView alloc]initWithFrame:CGRectZero];
//        _SV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //        _imageViewScrollView.backgroundColor = [UIColor redColor];
        _SV.showsVerticalScrollIndicator = NO;
        _SV.showsHorizontalScrollIndicator = NO;
        _SV.delegate = self;
//        _SV.directionalLockEnabled = YES;
//        _SV.pagingEnabled = YES;
    }
    return _SV;
}

- (UIView *)totalView{
    if(!_totalView){
        _totalView = [[UIView alloc] init];
        _totalView.backgroundColor = KBGCOLOR;
    }
    return _totalView;
}

-(UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        [_avatarView setBackgroundColor:[UIColor greenColor]];
        [_avatarView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _avatarView;
}

- (UILabel *)nickLab {
    if (!_nickLab) {
        _nickLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum16 TextColor:[UIColor blackColor]];
    }
    return _nickLab;
}

- (UILabel *)amount {
    if (!_amount) {
        _amount = [[UILabel alloc] initWithFrame:CGRectZero FontSize:28 TextColor:[UIColor blackColor]];
        _amount.font = [UIFont boldSystemFontOfSize:25];
    }
    return _amount;
}

- (UILabel *)receiveCount {
    if (!_receiveCount) {
        _receiveCount = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor grayColor]];
    }
    return _receiveCount;
}

- (UILabel *)receiveLab {
    if (!_receiveLab) {
        _receiveLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor grayColor]];
    }
    return _receiveLab;
}

- (UILabel *)luckyLab {
    if (!_luckyLab) {
        _luckyLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor grayColor]];
    }
    return _luckyLab;
}

- (UILabel *)luckyCount {
    if (!_luckyCount) {
        _luckyCount = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor grayColor]];
    }
    return _luckyCount;
}


@end

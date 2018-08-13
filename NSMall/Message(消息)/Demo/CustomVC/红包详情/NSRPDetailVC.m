//
//  NSRPDetailVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSRPDetailVC.h"
#import "NSNavView.h"
#import "NSMessageAPI.h"
#import "NSRedpacketTVCell.h"
#import "NSRedpacketRecordVC.h"

@interface NSRPDetailVC ()<BaseTableViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *RPSenderV;/* 发红包人的信息View */
@property(nonatomic,strong)UIImageView *avatarView;/* 头像 */
@property(nonatomic,strong)UILabel *userLab;/* 诺商昵称 */
@property(nonatomic,strong)UILabel *messageLab;/* 红包留言 */
@property(nonatomic,strong)UILabel *amountLab;/* 金额 */
@property(nonatomic,strong)UILabel *receiveLab;/* 领取个数 */
@property(nonatomic,strong)BaseTableView *RPTV;/* 抢到红包的人 */
@property(nonatomic,strong)NSRPListModel *rpListModel;/* 红包模型 */
@end

@implementation NSRPDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kWhiteColor;
    [self buildUI];
    [self setUpNavTopView];
    [self makeConstraints];
}

-(void)buildUI{
    [self.view addSubview:self.RPSenderV];
    [self.RPSenderV  addSubview:self.avatarView];
    [self.RPSenderV addSubview:self.userLab];
    [self.RPSenderV addSubview:self.messageLab];
    [self.RPSenderV addSubview:self.amountLab];
    [self.view addSubview:self.receiveLab];
    [self.view addSubview:self.RPTV];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
//    [self.navigationController setNavigationBarHidden:YES];
    NSNavView *navView = [[NSNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    navView.backgroundColor = kWhiteColor;
    [navView setTopTitleWithNSString:@"红包详情"];
    WEAKSELF
    [navView setRightItemTitle:@"红包记录"];
    [navView updateRightButtonConstraints];
    navView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //        [self delayPop];
    };
    navView.rightItemClickBlock = ^{
        NSRedpacketRecordVC *recordVC = [NSRedpacketRecordVC new];
        [weakSelf.navigationController pushViewController:recordVC animated:YES];
    };
    [self.view addSubview:navView];
}

//-(void)setUpDataWithRadpacketID:(NSString *)redpacketID{
//    [NSMessageAPI receiveRedpacketWithParam:redpacketID success:^(NSRPListModel *redPacketModel) {
//        //抢红包/红包详情
//        DLog(@"抢红包成功");
//        self.rpListModel = redPacketModel;
//        [self setUpDataWith:self.rpListModel];
//    } faulre:^(NSError *error) {
//
//    }];
//}

-(void)setUpDataWith:(NSRPListModel *)rpListModel{
    self.rpListModel = rpListModel;
    UserModel *userModel = [UserModel modelFromUnarchive];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:rpListModel.send_user_image]];
    self.userLab.text = [NSString stringWithFormat:@"%@的红包",rpListModel.send_user_name];
    self.messageLab.text = rpListModel.remarks;
    NSString *amountText = [NSString stringWithFormat:@"%.2f N",rpListModel.redpacket_amount];
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:amountText];
    NSRange rang = [amountText rangeOfString:[NSString stringWithFormat:@"%.2f",rpListModel.redpacket_amount]];
    [LZString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:rang];
    _amountLab.attributedText = LZString;
    
    self.RPTV.data = [NSMutableArray arrayWithArray:rpListModel.receiveRedpacketList];
    
    if([rpListModel.send_hxuser_name isEqualToString:userModel.hx_user_name]){
        self.receiveLab.text = [NSString stringWithFormat:@"领取%lu/%lu个",rpListModel.receiveRedpacketList.count,rpListModel.redpacket_count];
    }else{
        [self updateConstraint];
    }
    [self.RPTV reloadData];
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.RPSenderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(TopBarHeight);
        make.height.mas_equalTo(300);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.RPSenderV.mas_centerX);
        make.top.equalTo(weakSelf.RPSenderV.mas_top).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.userLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.RPSenderV.mas_centerX);
        make.top.equalTo(weakSelf.avatarView.mas_bottom).with.offset(10);
    }];
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.RPSenderV.mas_centerX);
        make.top.equalTo(weakSelf.userLab.mas_bottom).with.offset(10);
    }];
    
    [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.RPSenderV.mas_centerX);
        make.top.equalTo(weakSelf.messageLab.mas_bottom).with.offset(30);
    }];
    
    [self.receiveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.RPSenderV.mas_bottom).with.offset(10);
    }];

    [self.RPTV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    make.top.equalTo(self.RPSenderV.mas_bottom).with.offset(30);
    }];
}

-(void)updateConstraint{
    WEAKSELF
    
    [self.RPTV mas_updateConstraints:^(MASConstraintMaker *make) {
        //        make.left.right.bottom.equalTo(self.view);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.top.equalTo(self.RPSenderV.mas_bottom);
    }];
}



- (UIView *)RPSenderV{
    if(!_RPSenderV){
        _RPSenderV = [[UIView alloc] init];
        _RPSenderV.backgroundColor = KBGCOLOR;
    }
    return _RPSenderV;
}

-(UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        [_avatarView setBackgroundColor:[UIColor greenColor]];
        [_avatarView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _avatarView;
}

- (UILabel *)userLab {
    if (!_userLab) {
        _userLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum15 TextColor:[UIColor blackColor]];
    }
    return _userLab;
}

- (UILabel *)messageLab {
    if (!_messageLab) {
        _messageLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:[UIColor blackColor]];
    }
    return _messageLab;
}

- (UILabel *)amountLab {
    if (!_amountLab) {
        _amountLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _amountLab;
}


- (UILabel *)receiveLab {
    if (!_receiveLab) {
        _receiveLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor grayColor]];
    }
    return _receiveLab;
}

- (BaseTableView *)RPTV {
    if (!_RPTV) {
        _RPTV = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _RPTV.delegate = self;
        _RPTV.dataSource = self;
        _RPTV.isLoadMore = YES;
        _RPTV.isRefresh = YES;
        _RPTV.delegateBase = self;
        [_RPTV registerClass:[NSRedpacketTVCell class] forCellReuseIdentifier:@"NSRedpacketTVCell"];
    }
    return _RPTV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.RPTV.data.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GetScaleWidth(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSRedpacketTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSRedpacketTVCell"];
    if (self.RPTV.data.count > indexPath.section) {
        NSRPItemModel *model = self.RPTV.data[indexPath.section];
        //        NSLog(@"model = %@",model.mj_keyValues);
        cell.model = model;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)baseTableVIew:(BaseTableView *)tableView refresh:(BOOL)flag {
//    [self requestAllOrder:NO];
}

- (void)baseTableView:(BaseTableView *)tableView loadMore:(BOOL)flag {
//    [self requestAllOrder:YES];
}

@end

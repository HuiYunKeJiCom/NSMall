//
//  NSGroupDetailVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGroupDetailVC.h"
#import "ADOrderTopToolView.h"
#import "EMDingMessageHelper.h"
//#import "TZTestCell.h"
#import "NSMemberCVCell.h"
#import "UIView+Layout.h"
#import "NSGroupAPI.h"
#import "NSGroupModel.h"
#import "NSHuanXinUserModel.h"
#import "NSChatSettingView.h"
#import "ADLMyInfoModel.h"
#import "NSChangeGroupNameVC.h"
#import "ContactSelectionViewController.h"
#import "GroupListViewController.h"
#import "ChatViewController.h"

@interface NSGroupDetailVC ()<NSGoodsTableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,NSChatSettingViewDelegate,EMChooseViewDelegate,EMGroupManagerDelegate>{
    NSMutableArray *_groupMembers;
    CGFloat _itemWH;
    CGFloat _margin;
}

@property(nonatomic,strong)UIScrollView *SV;/* 全局SV */
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,strong)NSChatSettingView *middleView;/* 中间View */


@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property(nonatomic,strong)NSGroupModel *groupModel;/* 群组模型 */
@property(nonatomic,strong)NSMutableArray *membersArr;/* 群成员模型数组 */
@property(nonatomic,strong)NSString *groupId;/* 群组Id */
@property(nonatomic,strong)NSString *groupName;/* 群组名称 */
@property (strong, nonatomic) EMConversation *conversation;
@property(nonatomic)BOOL isGroupOwn;/* 是否群主 */
@property(nonatomic)BOOL isShowDel;/* 是否显示删除按钮 */
@property(nonatomic)NSInteger row;/* 删除成员的下标 */
@property(nonatomic,strong)EaseMessageViewController *easeMessage;
@end

@implementation NSGroupDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self buildUI];
    //    [self setUpData];
    [self configCollectionView];
    [self setUpNavTopView];
    [self makeConstraints];

}

-(void)buildUI{
    
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    [self.view addSubview:self.SV];
    [self.SV addSubview:self.collectionView];
    [self.SV addSubview:self.middleView];
    [self.SV addSubview:self.otherTableView];
    [self.SV addSubview:self.exitBtn];
    [self.exitBtn setTitle:@"删除并退出" forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isShowDel = NO;
}

//-(void)setUpData{
//
//}

//-(void)setUpDataWithGroupId:(NSString *)groupId{
//
//}

-(void)setUpDataWithConversation:(EMConversation *)conversation{
    self.conversation = conversation;

    UserModel *userModel = [UserModel modelFromUnarchive];
    
    if(self.conversation.type == EMConversationTypeGroupChat && ([self.groupOwn isEqualToString:userModel.hx_user_name])){
        self.isGroupOwn = YES;
    }else{
        self.isGroupOwn = NO;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults objectForKey:self.conversation.conversationId]){
        NSDictionary *dict = @{@"topSwitch":@"10",@"messageSwitch":@"10"};
        [userDefaults setObject:dict forKey:self.conversation.conversationId];
        [userDefaults synchronize];
    }
//    else{
//        NSDictionary *dict = [userDefaults objectForKey:self.conversation.conversationId];
//        if([dict isKindOfClass:[NSDictionary class]]){
//            dict = @{@"topSwitch":@"10",@"messageSwitch":@"10"};
//            [userDefaults setObject:dict forKey:self.conversation.conversationId];
//            [userDefaults synchronize];
//        }
//    }
    
//    NSDictionary *tempDict = [userDefaults objectForKey:self.conversation.conversationId];
//    DLog(@"tempDict = %@",tempDict);
    
    self.membersArr = [NSMutableArray array];
    [self.membersArr removeAllObjects];
    
    if(conversation.type == EMConversationTypeGroupChat){
        self.groupId = conversation.conversationId;
        _groupMembers = [NSMutableArray array];
        [NSGroupAPI getGroupWithParam:self.groupId success:^(NSGroupModel *groupModel) {
            DLog(@"获取群组信息成功");
            self.groupModel = groupModel;
            NSDictionary *tempDict = [self dictionaryWithJsonString:groupModel.group_name_json];
            //        DLog(@"tempDict = %@",tempDict);
            _groupMembers =  [tempDict objectForKey:@"jsonArray"];
            for (NSDictionary *dict in _groupMembers) {
                NSHuanXinUserModel *model = [NSHuanXinUserModel new];
                model.user_avatar = [dict objectForKey:@"avatar"];
                model.hx_user_name = [dict objectForKey:@"hxUsername"];
                model.nick_name = [dict objectForKey:@"nick"];
                [self.membersArr addObject:model];
            }
            self.groupName = groupModel.group_name;
            [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:@"群名称" imageName:nil num:self.groupName]];
            [self.otherTableView reloadData];
            
            [self updateConstraints];
            [self.collectionView reloadData];
        } faulre:^(NSError *error) {
            
        }];
    }else if(conversation.type == EMConversationTypeChat){
        NSDictionary *dict = conversation.lastReceivedMessage.ext;
        NSHuanXinUserModel *model = [NSHuanXinUserModel new];
        model.user_avatar = [dict objectForKey:@"avatar_url"];
        model.hx_user_name = [dict objectForKey:@"hx_username"];
        model.nick_name = [dict objectForKey:@"nick"];
        [self.membersArr addObject:model];
        
        int64_t delayInSeconds = 0.3; // 延迟的时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateConstraints];
            [self.collectionView reloadData];
        });
        
        
    }

}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = kWhiteColor;
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.SV addSubview:_collectionView];
    [_collectionView registerClass:[NSMemberCVCell class] forCellWithReuseIdentifier:@"NSMemberCVCell"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 4 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH+20);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    [self.collectionView setCollectionViewLayout:_layout];
   
    
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.isShowDel){
        return self.membersArr.count;
    }else{
        if(self.isGroupOwn && self.conversation.type == EMConversationTypeGroupChat){
            return self.membersArr.count + 2;
        }else{
            return self.membersArr.count+1;
        }
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMemberCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NSMemberCVCell" forIndexPath:indexPath];
    
    if (indexPath.row == self.membersArr.count) {
        cell.avatarIV.image = [UIImage imageNamed:@"AlbumAddBtn"];
        cell.nickLab.hidden = YES;
    } else if (indexPath.row == self.membersArr.count+1) {
        cell.avatarIV.image = [UIImage imageNamed:@"smiley_minus_btn_nor"];
        cell.nickLab.hidden = YES;
    }else{
        cell.model = self.membersArr[indexPath.row];
        cell.nickLab.hidden = NO;
    }
    
    WEAKSELF
    cell.delBtnClickBlock = ^{
        [weakSelf alertTipsDeleteWithIndexPath:indexPath];
    };
    
        if(self.isShowDel){
            if(indexPath.row == 0){
                cell.delBtn.alpha = 0.0;
            }else{
                cell.delBtn.alpha = 1.0;
            }
        }else{
            cell.delBtn.alpha = 0.0;
        }
    
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.membersArr.count) {
        [self addMemberAction];
    }
    if(indexPath.row == self.membersArr.count+1){
        [self showDelBtn];
    }
}

-(void)showDelBtn{
    self.isShowDel = YES;
    [self updateConstraintsForDel];
    [self.collectionView reloadData];
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
////    return indexPath.item < self.membersArr.count;
//    return NO;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
//    return (sourceIndexPath.item < self.membersArr.count && destinationIndexPath.item < self.membersArr.count);
//}
//
//- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
//
//}


#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:@"聊天详情"];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:topToolView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeConstraints {
    WEAKSELF
    [self.SV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(TopBarHeight);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.SV.mas_left);
        make.top.equalTo(weakSelf.SV.mas_top);
        make.size.mas_equalTo(CGSizeMake(self.view.tz_width, (self.membersArr.count + 5)/4 *_itemWH+30));
    }];

    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.SV.mas_left);
        make.top.equalTo(weakSelf.collectionView.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(48)*3+2));
    }];
    
    [self.otherTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.SV.mas_left);
        make.top.equalTo(weakSelf.middleView.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(43)));
    }];
    
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.SV.mas_left).with.offset(kScreenWidth*0.15);
        make.top.equalTo(self.otherTableView.mas_bottom).with.offset(100);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.7, 50));
    }];
    
    
}

-(void)updateConstraints{
    WEAKSELF
    if(self.isShowDel){
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.SV.mas_left);
            make.top.equalTo(weakSelf.SV.mas_top);
            make.size.mas_equalTo(CGSizeMake(self.view.tz_width, (self.membersArr.count + 3)/4 *_itemWH + 30));
        }];
    }else{
        if(self.conversation.type == EMConversationTypeChat){
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.SV.mas_left);
                make.top.equalTo(weakSelf.SV.mas_top);
                make.size.mas_equalTo(CGSizeMake(self.view.tz_width, (self.membersArr.count + 4)/4 *_itemWH +30));
            }];
        }else if(self.isGroupOwn && self.conversation.type == EMConversationTypeGroupChat){
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.SV.mas_left);
                make.top.equalTo(weakSelf.SV.mas_top);
                make.size.mas_equalTo(CGSizeMake(self.view.tz_width, (self.membersArr.count + 5)/4 *_itemWH + 30));
            }];
        }else{
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.SV.mas_left);
                make.top.equalTo(weakSelf.SV.mas_top);
                make.size.mas_equalTo(CGSizeMake(self.view.tz_width, (self.membersArr.count + 4)/4 *_itemWH + 30));
            }];
        }
    }
    
    
    
    
}

-(void)updateConstraintsForDel{
    WEAKSELF
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.SV.mas_left);
        make.top.equalTo(weakSelf.SV.mas_top);
        make.size.mas_equalTo(CGSizeMake(self.view.tz_width, (self.membersArr.count+3)/4 *(_itemWH + _margin*2)));
    }];
}

-(UIScrollView *)SV{
    if (!_SV) {
        _SV = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _SV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-20-TopBarHeight);
        _SV.backgroundColor = KBGCOLOR;
        _SV.showsVerticalScrollIndicator = NO;
    }
    return _SV;
}

-(NSChatSettingView *)middleView{
    if (!_middleView) {
        _middleView = [[NSChatSettingView alloc]initWithFrame:CGRectZero];
        _middleView.backgroundColor = KBGCOLOR;
        _middleView.tbDelegate = self;
        WEAKSELF
        _middleView.clearBtnClickBlock = ^{
            [weakSelf emptyChatRecord];
        };
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dict = [userDefaults objectForKey:self.conversation.conversationId];
        if([[dict objectForKey:@"messageSwitch"] isEqualToString:@"10"]){
            _middleView.messageSch.on = NO;
        }else{
            _middleView.messageSch.on = YES;
        }
        if([[dict objectForKey:@"topSwitch"] isEqualToString:@"10"]){
            _middleView.topSch.on = NO;
        }else{
            _middleView.topSch.on = YES;
        }
//        _middleView.userInteractionEnabled = YES;
    }
    return _middleView;
}

-(NSGoodsTableView *)otherTableView{
    if (!_otherTableView) {
        _otherTableView = [[NSGoodsTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _otherTableView.showsVerticalScrollIndicator = NO;
        _otherTableView.backgroundColor = [UIColor clearColor];
        _otherTableView.bounces = NO;
        _otherTableView.scrollEnabled = NO;
        _otherTableView.tbDelegate = self;
        _otherTableView.isRefresh = NO;
        _otherTableView.isLoadMore = NO;
        if (@available(iOS 11.0, *)) {
            _otherTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _otherTableView;
}

-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _exitBtn.showsTouchWhenHighlighted = YES;
        _exitBtn.backgroundColor = kRedColor;
        [_exitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _exitBtn.titleLabel.font = UISystemFontSize(16);
        _exitBtn.layer.masksToBounds = YES;
        _exitBtn.layer.cornerRadius = 10;
        
        [_exitBtn addTarget:self action:@selector(delAndExitGroupTips) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}


//json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//增加群组人员
- (void)addMemberAction
{
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] initWithBlockSelectedUsernames:self.membersArr];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}



//清空聊天记录
-(void)emptyChatRecord{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:@"确定清空聊天记录?" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    alertView.tag = 10;
    [alertView show];
}

//修改群名称
-(void)changeGroupName{
//    GroupSubjectChangingViewController *changingController = [[GroupSubjectChangingViewController alloc] initWithGroup:self.group];
//    [self.navigationController pushViewController:changingController animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10){
        if (alertView.cancelButtonIndex != buttonIndex) {
            if(self.conversation.type == EMConversationTypeGroupChat){
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATIONNAME_DELETEALLMESSAGE object:self.groupId];
            }else if (self.conversation.type == EMConversationTypeChat){
                
                if ([self.delegate respondsToSelector:@selector(deleteAllMessages:)]) {
                    [self.delegate deleteAllMessages:self.exitBtn];
                }
            }
        }
    }else if(alertView.tag == 20){
        if (alertView.cancelButtonIndex != buttonIndex) {
            [self delAndExitGroup];
        }
    }else if(alertView.tag == 30){
        if (alertView.cancelButtonIndex != buttonIndex) {
            [self deleteWithRow];
        }
    }
    
}

#pragma mark - NSChatSettingViewDelegate

//置顶聊天
-(void)topSwitchAction:(UISwitch *)topSwitch{
    BOOL isButtonOn = [topSwitch isOn];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *topDict = [NSMutableDictionary dictionaryWithDictionary:self.conversation.ext];
    if (isButtonOn) {
        NSLog(@"开");
        dict = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:self.conversation.conversationId]];
        [dict setValue:@"20" forKey:@"topSwitch"];
        [userDefaults setObject:dict forKey:self.conversation.conversationId];
        [userDefaults synchronize];
        
        [topDict setValue:@"20" forKey:@"topSwitch"];
        NSInteger temp = [self dateTimeDifferenceWithStartTime:@"10"];
//        DLog(@"temp = %lu",temp);
        [topDict setValue:[NSNumber numberWithInteger:temp] forKey:@"setTime"];
        
        
    }else {
        dict = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:self.conversation.conversationId]];
        [dict setValue:@"10" forKey:@"topSwitch"];
        [userDefaults setObject:dict forKey:self.conversation.conversationId];
        [userDefaults synchronize];
        [topDict setValue:@"10" forKey:@"topSwitch"];
    }
    self.conversation.ext = [NSDictionary dictionaryWithDictionary:topDict];
//    DLog(@"self.conversation.ext = %@",self.conversation.ext);
}

//设置消息免打扰
-(void)messageSwitchAction:(UISwitch *)messageSwitch{
    BOOL isButtonOn = [messageSwitch isOn];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    
    if (isButtonOn) {
        NSLog(@"开");
        dict = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:self.conversation.conversationId]];
        [dict setValue:@"20" forKey:@"messageSwitch"];
        [userDefaults setObject:dict forKey:self.conversation.conversationId];
        [userDefaults synchronize];
       
        
        options.noDisturbStatus = EMPushNoDisturbStatusDay;  //全天免打扰
        options.noDisturbingStartH = 0;
        options.noDisturbingEndH = 24;
        [[EMClient sharedClient] updatePushNotificationOptionsToServerWithCompletion:^(EMError *aError) {
            if (!aError) {
                NSLog(@"开启免打扰成功");
            }else{
                NSLog(@"error:%@", aError);
            }
        }];
    }else {
        dict = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:self.conversation.conversationId]];
        [dict setValue:@"10" forKey:@"messageSwitch"];
        [userDefaults setObject:dict forKey:self.conversation.conversationId];
        [userDefaults synchronize];
        
        options.noDisturbStatus = EMPushNoDisturbStatusClose;  //关闭免打扰模式
        [[EMClient sharedClient] updatePushNotificationOptionsToServerWithCompletion:^(EMError *aError) {
            if (!aError) {
                NSLog(@"关闭免打扰成功");
            }else{
                NSLog(@"error:%@", aError);
            }
        }];
    }
}

- (void)goodsTableView:(NSGoodsTableView *)goodsTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditUserType type = [self getEditType:@"群名称"];
    
    NSChangeGroupNameVC *ctrl = [[NSChangeGroupNameVC alloc] initEditType:type];
    ctrl.editTitle = @"群名称";
    ctrl.groupModel = self.groupModel;
    ctrl.stringBlock = ^(NSString *string) {
        for (ADLMyInfoModel *model in self.otherTableView.data) {
            if([model.title isEqualToString:@"群名称"]){
                if(string){
                    model.num = [NSString stringWithFormat:@"%@",string];
                }else{
                    model.num = self.groupName;
                }
            }
        }
        [self.otherTableView reloadData];
    };
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (EditUserType)getEditType:(NSString *)title {
    EditUserType type = 0;
    
    if ([title isEqualToString:@"群名称"]) {
        type = EditUserTypeGroupName;
        
    }
//         else if ([title isEqualToString:KLocalizableStr(@"数量")]) {
//            type = EditUserTypeNumber;
//
//        }
//    else if ([title isEqualToString:KLocalizableStr(@"运费")]) {
    //        type = EditUserTypeFee;
    //
    //    }
    
    return type;
}

-(void)delAndExitGroupTips{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:@"确定退出该群聊?" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    alertView.tag = 20;
    [alertView show];
}

-(void)delAndExitGroup{
    DLog(@"删除并退出");
//    DLog(@"self.groupId = %@",self.groupId);

    UserModel *userModel = [UserModel modelFromUnarchive];
    if([self.groupOwn isEqualToString:userModel.hx_user_name]){
        [NSGroupAPI deleteGroupWithParam:self.groupId success:^{
            DLog(@"退出群组成功");
            GroupListViewController *vc = [GroupListViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
        } faulre:^(NSError *error) {
            DLog(@"退出群组失败");
        }];
    }else{
        
        EMError *error = nil;
        [[EMClient sharedClient].groupManager leaveGroup:self.groupId error:&error];
        
        for(int i=0;i<self.membersArr.count;i++){
            NSHuanXinUserModel *hxModel = self.membersArr[i];
            if([hxModel.hx_user_name isEqualToString:userModel.hx_user_name]){
                self.row = i;
            }
        }
        [self.membersArr removeObjectAtIndex:self.row];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        NSDictionary *tempDict = [self dictionaryWithJsonString:self.groupModel.group_name_json];
        NSMutableArray *groupMembers = [NSMutableArray array];
        NSString *groupName = [tempDict objectForKey:@"groupName"];
        groupMembers =  [tempDict objectForKey:@"jsonArray"];
        [groupMembers removeObjectAtIndex:self.row];
        [jsonDict setValue:groupMembers forKey:@"jsonArray"];
        [jsonDict setValue:groupName forKey:@"groupName"];
        [param setValue:[self convertToJsonData:jsonDict] forKey:@"groupNameJson"];
        [param setValue:self.groupModel.group_id forKey:@"groupId"];
        //    });
        
        [NSGroupAPI updateGroupWithParam:param success:^(NSDictionary *groupId) {
            DLog(@"群组信息更新成功");
            GroupListViewController *vc = [GroupListViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } faulre:^(NSError *error) {
            DLog(@"群组信息更新失败");
        }];
    }
    
    
}

//计算当前时间与订单生成时间的时间差，转化成分钟

-(NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime

{
    if([startTime isEqualToString:@"10"]){
        startTime = @"2000-01-01 00:00:00";
    }
    
    NSDate *now = [NSDate date];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate =[formatter dateFromString:startTime];
    
    
    
    NSString *nowstr = [formatter stringFromDate:now];
    
    NSDate *nowDate = [formatter dateFromString:nowstr];
    
    
    
    NSTimeInterval start = [startDate timeIntervalSince1970]*1;
    
    NSTimeInterval end = [nowDate timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    
    
    
    int second = (int)value %60;//秒
    
    int minute = (int)value /60%60;
    
    int house = (int)value / (24 * 3600)%3600;
    
    int day = (int)value / (24 * 3600);
    
    NSString *str;
    
    NSInteger time;//剩余时间为多少分钟
    
    if (day != 0) {
        
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
        
        time = day*24*60+house*60+minute;
        
    }else if (day==0 && house != 0) {
        
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
        
        time = house*60+minute;
        
    }else if (day== 0 && house== 0 && minute!=0) {
        
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
        
        time = minute;
        
    }else{
        
        str = [NSString stringWithFormat:@"耗时%d秒",second];
        
    }
    
    return time;
    
}

#pragma mark - EMChooseViewDelegate
- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    WEAKSELF
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    UserModel *userModel = [UserModel modelFromUnarchive];
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    NSDictionary *tempDict = [self dictionaryWithJsonString:self.groupModel.group_name_json];
    NSMutableArray *groupMembers = [NSMutableArray array];
    
    if(self.conversation.type == EMConversationTypeChat){
        //私聊建群
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //创建群组
            NSMutableArray *hxuserNames = [NSMutableArray array];
            NSMutableArray *jsonArr = [NSMutableArray array];
            NSDictionary *dict = @{@"avatar":userModel.pic_img,@"hxUsername":userModel.hx_user_name,@"nick":userModel.user_name};
            [jsonArr addObject:dict];
            
            NSHuanXinUserModel *conversationModel = self.membersArr[0];
            NSDictionary *dictionary = @{@"avatar":conversationModel.user_avatar,@"hxUsername":conversationModel.hx_user_name,@"nick":conversationModel.nick_name};
            [jsonArr addObject:dictionary];
            [hxuserNames addObject:conversationModel.hx_user_name];
            
            for(int i=0;i<selectedSources.count;i++){
                NSHuanXinUserModel *hxModel = selectedSources[i];
                NSDictionary *dict = @{@"avatar":hxModel.user_avatar,@"hxUsername":hxModel.hx_user_name,@"nick":hxModel.nick_name};
                [jsonArr addObject:dict];
                [hxuserNames addObject:hxModel.hx_user_name];
            }
            [jsonDict setValue:jsonArr forKey:@"jsonArray"];
            [jsonDict setValue:@"未命名" forKey:@"groupName"];
            [param setValue:@"未命名" forKey:@"groupName"];
            [param setValue:[self convertToJsonData:jsonDict] forKey:@"groupNameJson"];
            [param setValue:@"temp" forKey:@"description"];
        
            bool bool_true = true;
            bool bool_false = false;
            
            [param setValue:[self arrayToJSONString:hxuserNames] forKey:@"hxuserNames"];
            [param setValue:@(bool_false) forKey:@"isPublic"];
            [param setValue:@(bool_true) forKey:@"membersOnly"];
            [param setValue:@(bool_true) forKey:@"allowinvites"];
            [param setValue:@(bool_false) forKey:@"isNeedConfirm"];
            [param setValue:@"200" forKey:@"maxusers"];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSGroupAPI createGroupWithParam:param success:^(NSDictionary *groupId) {
                        //                    DLog(@"groupId = %@",groupId);
                        DLog(@"群组创建成功");
                        
                        //发送透传消息
                        EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"group"];
                        NSString *from = [[EMClient sharedClient] currentUsername];
                        
                        //                    UserModel *userModel = [UserModel modelFromUnarchive];
                        // 生成message
                        EMMessage *message = [[EMMessage alloc] initWithConversationID:groupId from:from to:(NSString *)groupId body:body ext:@{@"group":@true,@"group_id":groupId}];
                        //                    message.chatType = EMChatTypeChat;// 设置为单聊消息
                        message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
                        //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息

                        [weakSelf _sendMessage:message];
                        
                        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:(NSString *)groupId conversationType:EMConversationTypeGroupChat];
                        chatController.title = @"群聊";
                        [weakSelf.navigationController pushViewController:chatController animated:YES];
                        
                    } faulre:^(NSError *error) {
                        
                    }];
                  });
                });
        
    }else if([self.groupOwn isEqualToString:userModel.hx_user_name]){
        //群聊是群主
        NSString *groupName = [tempDict objectForKey:@"groupName"];
        groupMembers =  [tempDict objectForKey:@"jsonArray"];
//        DLog(@"groupMembers = %@",groupMembers);
        for(int i=0;i<selectedSources.count;i++){
            NSHuanXinUserModel *hxModel = selectedSources[i];

            NSDictionary *dict = @{@"avatar":hxModel.user_avatar,@"hxUsername":hxModel.hx_user_name,@"nick":hxModel.nickname};
                [groupMembers addObject:dict];
                
            EMError *error = nil;
            [[EMClient sharedClient].groupManager addOccupants:@[hxModel.hx_user_name] toGroup:self.groupModel.group_id welcomeMessage:@"欢迎加入" error:&error];
        }
        [jsonDict setValue:groupMembers forKey:@"jsonArray"];
        [jsonDict setValue:groupName forKey:@"groupName"];
        [param setValue:[self convertToJsonData:jsonDict] forKey:@"groupNameJson"];
        [param setValue:self.groupId forKey:@"groupId"];
        //    });
        
        [NSGroupAPI updateGroupWithParam:param success:^(NSDictionary *groupId) {
            DLog(@"群组信息更新成功");
            [Common AppShowToast:@"群组信息更新成功"];
            [self setUpDataWithConversation:self.conversation];
        } faulre:^(NSError *error) {
            DLog(@"群组信息更新失败");
        }];
    }else{
        //群聊不是群主
        //邀请进群需要群主同意
        [param setValue:self.groupId forKey:@"groupId"];
        [param setValue:userModel.hx_user_name forKey:@"inviter"];
        for(int i=0;i<selectedSources.count;i++){
            NSHuanXinUserModel *hxModel = selectedSources[i];
            [groupMembers addObject:hxModel.hx_user_name];
        }
        [param setValue:groupMembers forKey:@"invitee"];
        [NSGroupAPI sendInviteConfirmWithParam:[self convertToJsonData:param] success:^{
            DLog(@"发送群组邀请确认消息成功");
        } faulre:^(NSError *error) {
            DLog(@"发送群组邀请确认消息失败");
        }];
    }
    
    
    
    return YES;
}

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

-(void)alertTipsDeleteWithIndexPath:(NSIndexPath *)indexPath{
    self.row = indexPath.row;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:@"确定踢出该成员?" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:@"确定", nil];
    alertView.tag = 30;
    [alertView show];
}

-(void)deleteWithRow{
    
    NSHuanXinUserModel *delModel = self.membersArr[self.row];
    
    EMError *error = nil;
    [[EMClient sharedClient].groupManager removeOccupants:@[delModel.hx_user_name] fromGroup:self.groupModel.group_id error:&error];
    
    [self.membersArr removeObjectAtIndex:self.row];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    NSDictionary *tempDict = [self dictionaryWithJsonString:self.groupModel.group_name_json];
    NSMutableArray *groupMembers = [NSMutableArray array];
    NSString *groupName = [tempDict objectForKey:@"groupName"];
    groupMembers =  [tempDict objectForKey:@"jsonArray"];
    [groupMembers removeObjectAtIndex:self.row];
    [jsonDict setValue:groupMembers forKey:@"jsonArray"];
    [jsonDict setValue:groupName forKey:@"groupName"];
    [param setValue:[self convertToJsonData:jsonDict] forKey:@"groupNameJson"];
    [param setValue:self.groupModel.group_id forKey:@"groupId"];
    //    });
    
    [NSGroupAPI updateGroupWithParam:param success:^(NSDictionary *groupId) {
        DLog(@"群组信息更新成功");
        [Common AppShowToast:@"群组信息更新成功"];
        [self setUpDataWithConversation:self.conversation];
    } faulre:^(NSError *error) {
        DLog(@"群组信息更新失败");
    }];
    

}

- (NSString *)arrayToJSONString:(NSArray *)array
                       
{
            
    NSError *error = nil;
            
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
    return jsonString;
}

- (void)_sendMessage:(EMMessage *)message{
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
            [self.easeMessage _refreshAfterSentMessage:aMessage];
    }];
}

@end

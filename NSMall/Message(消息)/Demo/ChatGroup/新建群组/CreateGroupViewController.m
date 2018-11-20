/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */
//创建群组

#import "CreateGroupViewController.h"

#import "ContactSelectionViewController.h"
#import "EMTextView.h"
#import "NSNavView.h"
#import "NSGroupAPI.h"
#import "NSMessageAPI.h"
//#import "NSCreateGroupParam.h"
#import "ChatViewController.h"
#import "NSHuanXinUserModel.h"


@interface CreateGroupViewController ()<UITextFieldDelegate, UITextViewDelegate, EMChooseViewDelegate>

//@property (strong, nonatomic) UIView *switchView;
//@property (strong, nonatomic) UIBarButtonItem *rightItem;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) EMTextView *textView;

//@property (nonatomic) BOOL isPublic;
//@property (strong, nonatomic) UILabel *groupTypeLabel;//群组类型
//
//@property (nonatomic) BOOL isMemberOn;
//@property (strong, nonatomic) UILabel *groupMemberTitleLabel;
//@property (strong, nonatomic) UISwitch *groupMemberSwitch;
//@property (strong, nonatomic) UILabel *groupMemberLabel;

@property(nonatomic,strong)UIButton *virtualBtn;/* 虚拟按钮,无真实用处 */
@property(nonatomic,strong)NSNavView *topToolView;/* 导航栏 */
//@property(nonatomic,strong)NSCreateGroupParam *param;/* 创建群组参数 */
@property(nonatomic,strong)NSMutableDictionary *param;/* 创建群组参数 */
@property(nonatomic,strong)EaseMessageViewController *easeMessage;

@end

@implementation CreateGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _isPublic = NO;
//        _isMemberOn = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.param = [NSCreateGroupParam new];
    self.param = [NSMutableDictionary dictionary];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
//    self.title = NSLocalizedString(@"title.createGroup", @"Create a group");
    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    
//    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    addButton.accessibilityIdentifier = @"add_member";
//    addButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [addButton setTitle:NSLocalizedString(@"group.create.addOccupant", @"add members") forState:UIControlStateNormal];
//    [addButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
//    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [addButton addTarget:self action:@selector(addContacts:) forControlEvents:UIControlEventTouchUpInside];
//    _rightItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
//    [self.navigationItem setRightBarButtonItem:_rightItem];
    
    //监听textfield的输入状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.textField];
    
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    backButton.accessibilityIdentifier = @"back";
//    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.textView];
//    [self.view addSubview:self.switchView];
    
    [self setUpNavTopView];
    
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    self.topToolView = [[NSNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    self.topToolView.backgroundColor = KMainColor;
    
    [self.topToolView setTopTitleWithNSString:@"发起群聊"];
    
    WEAKSELF
    self.topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
//    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    addButton.accessibilityIdentifier = @"add_member";
//    addButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [addButton setTitle:NSLocalizedString(@"group.create.addOccupant", @"add members") forState:UIControlStateNormal];
//    [addButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
//    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [addButton addTarget:self action:@selector(addContacts:) forControlEvents:UIControlEventTouchUpInside];
//    _rightItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
//
//    topToolView.rightItemButton
    
    self.topToolView.rightItemClickBlock = ^{
        [weakSelf addContacts:weakSelf.virtualBtn];
    };
    [self.topToolView setRightItemTitle:NSLocalizedString(@"group.create.addOccupant", @"add members")];
    [self.topToolView updateRightButtonConstraints];
//    [self.topToolView.rightItemButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.topToolView.rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.topToolView.rightItemButton.enabled = YES;
    
    [self.view addSubview:self.topToolView];
}



//这里可以通过发送object消息获取注册时指定的UITextField对象
- (void)textFieldDidChangeValue:(NSNotification *)notification
{
    UITextField *sender = (UITextField *)[notification object];
    
    UIButton *addButton = self.topToolView.rightItemButton;

    //    sender.text.length != 0
//    if(sender.text.length != 0 )
//    {
//        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.topToolView.rightItemButton.enabled = YES;
//    }else
//    {
//        [addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        self.topToolView.rightItemButton.enabled = NO;
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UITextField *)textField
{
    if (_textField == nil) {
//        改动过
//        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10+TopBarHeight, kScreenWidth-20, 40)];
        _textField.accessibilityIdentifier = @"group_name";
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 0.5;
        _textField.layer.cornerRadius = 3;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = NSLocalizedString(@"group.create.inputName", @"please enter the group name");
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }
    
    return _textField;
}

- (EMTextView *)textView
{
    if (_textView == nil) {
//        改动过
//        _textView = [[EMTextView alloc] initWithFrame:CGRectMake(10, 70, 300, 80)];
        _textView = [[EMTextView alloc] initWithFrame:CGRectMake(10, 70+TopBarHeight, kScreenWidth-20, 80)];
        _textView.accessibilityIdentifier = @"group_subject";
        _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textView.layer.borderWidth = 0.5;
        _textView.layer.cornerRadius = 3;
        _textView.font = [UIFont systemFontOfSize:14.0];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeholder = NSLocalizedString(@"group.create.inputDescribe", @"please enter a group description");
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
    }
    
    return _textView;
}

//- (UIView *)switchView
//{
//    if (_switchView == nil) {
//        _switchView = [[UIView alloc] initWithFrame:CGRectMake(10, 160+TopBarHeight, 300, 90)];
//        _switchView.backgroundColor = [UIColor clearColor];
//
//        CGFloat oY = TopBarHeight;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, oY, 100, 35)];
//        label.backgroundColor = [UIColor clearColor];
//        label.font = [UIFont systemFontOfSize:14.0];
//        label.numberOfLines = 2;
//        label.text = NSLocalizedString(@"group.create.groupPermission", @"group permission");
//        [_switchView addSubview:label];
//
//        UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(100, oY, 50, _switchView.frame.size.height)];
//        switchControl.accessibilityIdentifier = @"group_type";
//        [switchControl addTarget:self action:@selector(groupTypeChange:) forControlEvents:UIControlEventValueChanged];
//        [_switchView addSubview:switchControl];
//
//        _groupTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(switchControl.frame.origin.x + switchControl.frame.size.width + 5, oY, 100, 35)];
//        _groupTypeLabel.backgroundColor = [UIColor clearColor];
//        _groupTypeLabel.font = [UIFont systemFontOfSize:12.0];
//        _groupTypeLabel.textColor = [UIColor grayColor];
//        _groupTypeLabel.text = NSLocalizedString(@"group.create.private", @"private group");
//        _groupTypeLabel.numberOfLines = 2;
//        [_switchView addSubview:_groupTypeLabel];
//
//        oY += (35 + 20);
//        _groupMemberTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, oY, 100, 35)];
//        _groupMemberTitleLabel.font = [UIFont systemFontOfSize:14.0];
//        _groupMemberTitleLabel.backgroundColor = [UIColor clearColor];
//        _groupMemberTitleLabel.text = NSLocalizedString(@"group.create.occupantPermissions", @"members invite permissions");
//        _groupMemberTitleLabel.numberOfLines = 2;
//        [_switchView addSubview:_groupMemberTitleLabel];
//
//        _groupMemberSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, oY, 50, 35)];
//        _groupMemberSwitch.accessibilityIdentifier = @"member_permission";
//        [_groupMemberSwitch addTarget:self action:@selector(groupMemberChange:) forControlEvents:UIControlEventValueChanged];
//        [_switchView addSubview:_groupMemberSwitch];
//
//        _groupMemberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_groupMemberSwitch.frame.origin.x + _groupMemberSwitch.frame.size.width + 5, oY, 150, 35)];
//        _groupMemberLabel.backgroundColor = [UIColor clearColor];
//        _groupMemberLabel.font = [UIFont systemFontOfSize:12.0];
//        _groupMemberLabel.textColor = [UIColor grayColor];
//        _groupMemberLabel.numberOfLines = 2;
//        _groupMemberLabel.text = NSLocalizedString(@"group.create.unallowedOccupantInvite", @"don't allow group members to invite others");
//        [_switchView addSubview:_groupMemberLabel];
//    }
//
//    return _switchView;
//}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - EMChooseViewDelegate

- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    NSInteger maxUsersCount = 200;
    if ([selectedSources count] > (maxUsersCount - 1)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"group.maxUserCount", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        
        return NO;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"group.create.ongoing", @"create a group...")];
    
//    NSMutableArray *source = [NSMutableArray array];
//    for (NSString *username in selectedSources) {
//        [source addObject:username];
//    }
    
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = maxUsersCount;
    
//    if (_isPublic) {
//        if(_isMemberOn)
//        {
            setting.style = EMGroupStylePublicOpenJoin;
//        }
//        else{
//            setting.style = EMGroupStylePublicJoinNeedApproval;
//        }
//    }
//    else{
//        if(_isMemberOn)
//        {
//            setting.style = EMGroupStylePrivateMemberCanInvite;
//        }
//        else{
//            setting.style = EMGroupStylePrivateOnlyOwnerInvite;
//        }
//    }
    
    __weak CreateGroupViewController *weakSelf = self;
//    NSString *username = [[EMClient sharedClient] currentUsername];
//    NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join groups \'%@\'"), username, self.textField.text];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //创建群组
        
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        NSMutableArray *jsonArr = [NSMutableArray array];
        UserModel *userModel = [UserModel modelFromUnarchive];
        NSDictionary *dict = @{@"avatar":userModel.pic_img,@"hxUsername":userModel.hx_user_name,@"nick":userModel.user_name};
        [jsonArr addObject:dict];
        
        [NSMessageAPI getFriendList:nil success:^(NSFriendListModel * _Nullable result) {
            NSMutableArray *hxuserNames = [NSMutableArray array];
            for(int i=0;i<selectedSources.count;i++){
                NSHuanXinUserModel *hxModel = selectedSources[i];
//                for (NSFriendItemModel *model in result.list) {
//                    if([model.nick_name isEqualToString:hxModel.nickname]){
                        NSDictionary *dict = @{@"avatar":hxModel.user_avatar,@"hxUsername":hxModel.hx_user_name,@"nick":hxModel.nick_name};
                        [jsonArr addObject:dict];
                        [hxuserNames addObject:hxModel.hx_user_name];
//                    }
//                }
            }
            
            
            [jsonDict setValue:jsonArr forKey:@"jsonArray"];
            if(self.textField.text.length != 0){
                [jsonDict setValue:self.textField.text forKey:@"groupName"];
                [self.param setValue:self.textField.text forKey:@"groupName"];
            }else{
                [jsonDict setValue:@"未命名" forKey:@"groupName"];
                [self.param setValue:@"未命名" forKey:@"groupName"];
            }
//            self.param.groupNameJson = [self dictionaryToJson:jsonDict];
            [self.param setValue:[self convertToJsonData:jsonDict] forKey:@"groupNameJson"];
            if(self.textView.text.length != 0){
//                self.param.groupDescription = self.textView.text;
                [self.param setValue:self.textView.text forKey:@"description"];
            }else{
//                self.param.groupDescription = @"temp";
                [self.param setValue:@"temp" forKey:@"description"];
            }
            
            bool bool_true = true;
            bool bool_false = false;
            
            [self.param setValue:[self arrayToJSONString:hxuserNames] forKey:@"hxuserNames"];
            [self.param setValue:@(bool_false) forKey:@"isPublic"];
            [self.param setValue:@(bool_true) forKey:@"membersOnly"];
            [self.param setValue:@(bool_true) forKey:@"allowinvites"];
            [self.param setValue:@(bool_false) forKey:@"isNeedConfirm"];
            [self.param setValue:@"200" forKey:@"maxusers"];
//            self.param.hxuserNames = hxuserNames;
//            self.param.isPublic = false;
//            self.param.membersOnly = false;
//            self.param.allowinvites = true;
//            self.param.isNeedConfirm = false;
//            self.param.maxusers = @"200";
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                [NSGroupAPI createGroupWithParam:self.param success:^(NSDictionary *groupId) {
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

                    UIViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:(NSString *)groupId conversationType:EMConversationTypeGroupChat];
                    chatController.title = @"群聊";
                    [weakSelf.navigationController pushViewController:chatController animated:YES];
                    
                } faulre:^(NSError *error) {
                    
                }];
                
            });
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
        
//        if(self.textField.text.length != 0){
//            self.param.groupName = self.textField.text;
//        }else{
//            self.param.groupName =
//        }

        
        
//        EMError *error = nil;
//        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:self.textField.text description:self.textView.text invitees:source message:messageStr setting:setting error:&error];
//        dispatch_async(dispatch_get_main_queue(), ^{
 //           [weakSelf hideHud];
//            if (group && !error) {
//                [weakSelf showHint:NSLocalizedString(@"group.create.success", @"create group success")];
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }
//            else{
//                [weakSelf showHint:NSLocalizedString(@"group.create.fail", @"Failed to create a group, please operate again")];
//            }
//        });
    });
    return YES;
}

#pragma mark - action

//- (void)groupTypeChange:(UISwitch *)control
//{
//    _isPublic = control.isOn;
//
//    [_groupMemberSwitch setOn:NO animated:NO];
//    [self groupMemberChange:_groupMemberSwitch];
//
//    if (control.isOn) {
//        _groupTypeLabel.text = NSLocalizedString(@"group.create.public", @"public group");
//    }
//    else{
//        _groupTypeLabel.text = NSLocalizedString(@"group.create.private", @"private group");
//    }
//}
//
//- (void)groupMemberChange:(UISwitch *)control
//{
//    if (_isPublic) {
//        _groupMemberTitleLabel.text = NSLocalizedString(@"group.create.occupantJoinPermissions", @"members join permissions");
//        if(control.isOn)
//        {
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.open", @"random join");
//        }
//        else{
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.needApply", @"you need administrator agreed to join the group");
//        }
//    }
//    else{
//        _groupMemberTitleLabel.text = NSLocalizedString(@"group.create.occupantPermissions", @"members invite permissions");
//        if(control.isOn)
//        {
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.allowedOccupantInvite", @"allows group members to invite others");
//        }
//        else{
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.unallowedOccupantInvite", @"don't allow group members to invite others");
//        }
//    }
//
//    _isMemberOn = control.isOn;
//}

- (void)addContacts:(id)sender
{
//    NSLog(@"customView = %@",self.rightItem.customView);
    
//    if (self.textField.text.length == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"group.create.inputName", @"please enter the group name") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        [alertView show];
//        return;
//    }
    
    [self.view endEditing:YES];
    
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] init];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

- (NSString *)arrayToJSONString:(NSArray *)array

{
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
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

- (void)_sendMessage:(EMMessage *)message{
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        [self.easeMessage _refreshAfterSentMessage:aMessage];
    }];
}



@end

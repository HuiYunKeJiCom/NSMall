//
//  NSMessageViewController.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMessageViewController.h"

@interface NSMessageViewController ()

@property(nonatomic,strong)UITextField *chatContent;/* 聊天内容 */
@property(nonatomic,strong)UIButton *sendBtn;/* 发送 */
@property(nonatomic,strong)EMConversation *conversation;
@end

@implementation NSMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.chatContent];
    [self.view addSubview:self.sendBtn];
    
    [self makeConstraints];
    
}

-(instancetype)initWithConversationId:(NSString *)conversationId conversationType:(EMConversationType)conversationType{
    self = [super init];
    if(self){
        _conversation = [[EMClient sharedClient].chatManager getConversation:conversationId type:conversationType createIfNotExist:YES];
    }
    return self;
}

-(void)makeConstraints {
    WEAKSELF
    [self.chatContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-40);
        make.width.mas_equalTo(kScreenWidth*0.68);
        make.height.mas_equalTo(GetScaleWidth(30));
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.chatContent.mas_bottom).with.offset(20);
make.size.mas_equalTo(CGSizeMake(GetScaleWidth(60),GetScaleWidth(30)));
    }];
}

- (UITextField *)chatContent {
    if (!_chatContent) {
        _chatContent = [[UITextField alloc] initWithFrame:CGRectZero];
        _chatContent.font = [UIFont systemFontOfSize:12];
        _chatContent.clearButtonMode = UITextFieldViewModeWhileEditing;
        _chatContent.placeholder = @"请选择";
        _chatContent.textColor = [UIColor lightGrayColor];
        _chatContent.backgroundColor = [UIColor whiteColor];
        _chatContent.layer.borderWidth = 1.0f;
        _chatContent.layer.cornerRadius = 5;
        _chatContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 25)];
        _chatContent.leftView = paddingView;
        _chatContent.leftViewMode = UITextFieldViewModeAlways;
    }
    return _chatContent;
}

-(UIButton *)sendBtn{
    if (!_sendBtn) {
        // 底部pause或者play
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _sendBtn.backgroundColor = [UIColor redColor];
//        [_sendBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sendBtn.showsTouchWhenHighlighted = YES;
        [_sendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

-(void)sendMessage:(UIButton *)button{
    NSLog(@"发送消息");
    EMTextMessageBody *body = [[EMTextMessageBody alloc]initWithText:self.chatContent.text];
    EMMessage *message = [[EMMessage alloc]initWithConversationID:_conversation.conversationId from:[EMClient sharedClient].currentUsername to:_conversation.conversationId body:body ext:nil ];
    NSLog(@"_conversation.conversationId = %@",_conversation.conversationId);
    NSLog(@"[EMClient sharedClient].currentUsername = %@",[EMClient sharedClient].currentUsername);
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"error = %@",error);
        if(!error)
            NSLog(@"发送消息成功");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

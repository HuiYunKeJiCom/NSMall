//
//  ChatViewController.m
//
//  Created by gyh on 16/1/26.
//  Copyright © 2016年 gyh. All rights reserved.
//

#import "ChatViewController.h"
#import "AddView.h"
#import "AddViewButton.h"
#import "NSString+Extension.h"

#import "MessageCell.h"
#import "MessageImageCell.h"
#import "MessageVideoCell.h"
#import "GYHTimeTool.h"

#import "ADOrderTopToolView.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EMChatManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *sound;
-(IBAction)soundvoice;

@property (weak, nonatomic) IBOutlet UIButton *btn;   //添加按钮
@property (weak, nonatomic) IBOutlet UITextField *inputView;
- (IBAction)addView;
/**
 *  聊天记录数组
 */
@property (nonatomic, strong) NSMutableArray *messageArr;
@property (weak,  nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, readwrite)UIInputView *input;

/**
 *  录音
 */
@property (nonatomic , weak) UIButton *backrecordBtn;
//@property (nonatomic , strong) LVRecordTool *lvrecordTool;
@property (nonatomic,strong) NSURL * recordURL;         //录制音频 存放地址
@property (nonatomic , strong) UIButton *addrecordBtn;  //添加录音的按钮
@property (nonatomic , copy)   NSString *recordTime;     //录制时间
@property (nonatomic , weak)   UIButton *recordbtn;      //录音完成
@property (nonatomic , weak)   UIButton *deleteB;        //删除按钮

/**
 *  会话
 */
@property (nonatomic , strong)  EMConversation *conversation;

@property(nonatomic,strong)ADOrderTopToolView *topToolView;/* 导航view */
@end

@implementation ChatViewController


- (NSMutableArray *)messageArr
{
    if (_messageArr == nil) {
        _messageArr = [[NSMutableArray alloc]init];
    }
    return _messageArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
//    self.title = self.fromname;
    
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:self.fromname type:EMConversationTypeChat createIfNotExist:YES];
    self.conversation = conversation;
    //将所有消息设置为已读
    [conversation markAllMessagesAsRead];

    //获取十条聊天记录
    NSArray *array = [conversation loadMoreMessagesFromId:nil limit:100 direction:nil];
    //[conversation loadMoreMessagesFromId:nil limit:100];
    [self.messageArr addObjectsFromArray:array];
    
    
    self.btn.tag = 0;
    [self.btn setImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateHighlighted];
//    self.tableview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    
    //监听键盘的frame改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(click:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    //设置输入框左边的间距
    self.inputView.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.inputView.leftViewMode = UITextFieldViewModeAlways;
    self.inputView.delegate = self;
    
    [self tongzhi];
    
    [self scrollToTableBottom];
    
    [self setUpNavTopView];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    self.topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    self.topToolView.backgroundColor = kWhiteColor;
    [self.topToolView setTopTitleWithNSString:KLocalizableStr(self.fromname)];
    WEAKSELF
    self.topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        //        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.topToolView];
    [self.view bringSubviewToFront:self.topToolView];
}


-(void)tongzhi
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(event:) name:@"Photo" object:nil];
}


- (void)event:(NSNotification *)notifition
{
    if ([notifition.object isEqualToString:@"图片"]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else if ([notifition.object isEqualToString:@"拍照"]){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{

    }
}


#pragma mark - 接收到消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
    NSLog(@"接收到消息了-----%@",aMessages);
    for (EMMessage *msg in aMessages) {
        [self.conversation markMessageAsReadWithId:msg.messageId];
    }
    [self.messageArr addObjectsFromArray:aMessages];
    [self.tableview reloadData];
    [self scrollToTableBottom];
}



#pragma mark 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EMMessage *message = self.messageArr[indexPath.row];
     NSString *currentname = [[EMClient sharedClient] currentUsername];

    if ([message.body isKindOfClass:[EMTextMessageBody class]]) {
       
        EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
        
            MessageCell *cell = [MessageCell cellWithTableView:tableView];
            if ([message.from isEqualToString:currentname]) {//自己发
                
                [cell setMessage:[NSString stringWithFormat:@"%@",textBody.text] andType:0 andTime:[GYHTimeTool timeStr:message.timestamp]];
                [cell.textView setTitle:[NSString stringWithFormat:@"%@",textBody.text] forState:UIControlStateNormal];
                //头像
                cell.iconView.image = [UIImage imageNamed:@"2"];
                
            }else{//别人发的
                
                [cell setMessage:[NSString stringWithFormat:@"%@",textBody.text] andType:1 andTime:[GYHTimeTool timeStr:message.timestamp]];
                [cell.textView setTitle:[NSString stringWithFormat:@"%@",textBody.text] forState:UIControlStateNormal];
                cell.iconView.image = [UIImage imageNamed:@"1"];
            }
            return cell;

        
        
    }else if ([message.body isKindOfClass:[EMVoiceMessageBody class]]){
        

    }else if([message.body isKindOfClass:[EMImageMessageBody class]]){
        

    }else{

    }

    
    
//    // 获取聊天消息对象
//    XMPPMessageArchiving_Message_CoreDataObject *msg =  _resultsContr.fetchedObjects[indexPath.row];
//
//    if([[msg.message attributeStringValueForName:@"type"] isEqualToString:@"groupchat"]){
//        
//        NSString * userName = [NSString userNameWithGroupChatFromName:msg.message.fromStr];
//        NSString *chatType = [msg.message attributeStringValueForName:@"bodyType"];
//
//
//        }else if ([chatType isEqualToString:@"image"]){
//            
//            MessageImageCell *cell = [MessageImageCell cellWithTableView:tableView];
//            if ([userName isEqualToString:[UserInfo sharedUserInfo].user]) { //自己发的
//                
//                NSLog(@"image --- %@",msg.body);
//                [cell setMessage:nil andType:0 andTime:msg.timestamp];
//                cell.iconView.image = [UIImage imageNamed:@"2"];
//                [cell.textView sd_setImageWithURL:[NSURL URLWithString:msg.body] placeholderImage:nil];
//            }else{
//                
//                [cell setMessage:nil andType:1 andTime:msg.timestamp];
//                cell.iconView.image = [UIImage imageNamed:@"1"];
//                [cell.textView sd_setImageWithURL:[NSURL URLWithString:msg.body] placeholderImage:nil];
//            }
//            return cell;
//            
//        }else if ([chatType isEqualToString:@"Video"]){
//            
//            MessageVideoCell *cell = [MessageVideoCell cellWithTableView:tableView];
//            NSString *timestr = [msg.message attributeStringValueForName:@"VideoTime"];
//            if ([userName isEqualToString:[UserInfo sharedUserInfo].user]) {
//                
//                [cell setMessage:nil andType:0 andTime:msg.timestamp];
//                //头像
//                cell.iconView.image = [UIImage imageNamed:@"2"];
//                [cell.textView setTitle:timestr forState:UIControlStateNormal];
//                
//            }else{
//                [cell setMessage:nil andType:1 andTime:msg.timestamp];
//                cell.iconView.image = [UIImage imageNamed:@"1"];
//                [cell.textView setTitle:timestr forState:UIControlStateNormal];
//            }
//            return cell;
//        }
//
//        
//        
//        
//    }else{
//        // 判断是图片还是纯文本
//        NSString *chatType = [msg.message attributeStringValueForName:@"bodyType"];
//        
//        if ([chatType isEqualToString:@"image"]) {
//            MessageImageCell *cell = [MessageImageCell cellWithTableView:tableView];
//            
//            if ([msg.outgoing boolValue]) { //自己发的
//                
//                NSLog(@"image --- %@",msg.body);
//                [cell setMessage:nil andType:0 andTime:msg.timestamp];
//                cell.iconView.image = [UIImage imageNamed:@"2"];
//                [cell.textView sd_setImageWithURL:[NSURL URLWithString:msg.body] placeholderImage:nil];
//            }else{
//                
//                [cell setMessage:nil andType:1 andTime:msg.timestamp];
//                cell.iconView.image = [UIImage imageNamed:@"1"];
//                [cell.textView sd_setImageWithURL:[NSURL URLWithString:msg.body] placeholderImage:nil];
//            }
//            return cell;
//            
//        }else if([chatType isEqualToString:@"text"]){
//            
//            
//            MessageCell *cell = [MessageCell cellWithTableView:tableView];
//            if ([msg.outgoing boolValue]) {//自己发
//                
//                [cell setMessage:[NSString stringWithFormat:@"%@",msg.body] andType:0 andTime:msg.timestamp];
//                [cell.textView setTitle:[NSString stringWithFormat:@"%@",msg.body] forState:UIControlStateNormal];
//                //头像
//                cell.iconView.image = [UIImage imageNamed:@"2"];
//                
//            }else{//别人发的
//                
//                [cell setMessage:[NSString stringWithFormat:@"%@",msg.body] andType:1 andTime:msg.timestamp];
//                [cell.textView setTitle:[NSString stringWithFormat:@"%@",msg.body] forState:UIControlStateNormal];
//                cell.iconView.image = [UIImage imageNamed:@"1"];
//            }
//            return cell;
//            
//        }else if ([chatType isEqualToString:@"Video"]){
//            
//            MessageVideoCell *cell = [MessageVideoCell cellWithTableView:tableView];
//            NSString *timestr = [msg.message attributeStringValueForName:@"VideoTime"];
//            if ([msg.outgoing boolValue]) {
//                
//                [cell setMessage:nil andType:0 andTime:msg.timestamp];
//                //头像
//                cell.iconView.image = [UIImage imageNamed:@"2"];
//                [cell.textView setTitle:timestr forState:UIControlStateNormal];
//                
//            }else{
//                [cell setMessage:nil andType:1 andTime:msg.timestamp];
//                cell.iconView.image = [UIImage imageNamed:@"1"];
//                [cell.textView setTitle:timestr forState:UIControlStateNormal];
//            }
//            return cell;
//        }
//    }
       return nil;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultsContr.fetchedObjects[indexPath.row];
//    NSString *chatType = [msg.message attributeStringValueForName:@"bodyType"];
//    
//    if ([chatType isEqualToString:@"Video"]) {
//        return 100;
//    }else if ([chatType isEqualToString:@"image"]) {
//        return 150;
//    }else{
//        NSString *str = msg.body;
//        CGSize textBtnSize;
//        CGSize textMaxSize = CGSizeMake(200, MAXFLOAT);
//        CGSize textRealSize = [str sizeWithFont:[UIFont systemFontOfSize:15] maxSize:textMaxSize];
//        // 按钮最终的真实尺寸
//        textBtnSize = CGSizeMake(textRealSize.width + 20, textRealSize.height + 20);
//        //根据文本空间计算行高
//        if (textBtnSize.height + 50.0 > 100.0) {
//            return textBtnSize.height + 70;
//        }
//        return 100;
//    }
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultsContr.fetchedObjects[indexPath.row];
//    NSString *chatType = [msg.message attributeStringValueForName:@"bodyType"];
//    if ([chatType isEqualToString:@"Video"]) {
//        NSLog(@"video---%@",msg.body);
//        
//        AVPlayer *player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:msg.body]];
//        [player play];
//        self.player = player;
//        
//    }else{
//        NSLog(@"did---%@",msg.body);
//    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    EMMessage *message = self.messageArr[indexPath.row];
    
    if ([message.body isKindOfClass:[EMTextMessageBody class]]){
        
        EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
        
        NSString *str = textBody.text;
        CGSize textBtnSize;
        CGSize textMaxSize = CGSizeMake(200, MAXFLOAT);
        CGSize textRealSize = [str sizeWithFont:[UIFont systemFontOfSize:15] maxSize:textMaxSize];
        // 按钮最终的真实尺寸
        textBtnSize = CGSizeMake(textRealSize.width + 20, textRealSize.height + 20);
        //根据文本空间计算行高
        if (textBtnSize.height + 50.0 > 100.0) {
            return textBtnSize.height + 70;
        }
        return 100;

    }else if ([message.body isKindOfClass:[EMTextMessageBody class]]) {
        return 100;
    }else{
        return 150;
    }
}


#pragma mark 文本框代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //构造文字消息
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:textField.text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.fromname from:from to:self.fromname body:body ext:nil];
    message.chatType = EMChatTypeChat;
    UserModel *userModel = [UserModel modelFromUnarchive];
    message.ext = @{@"nick":userModel.user_name,@"user_id":userModel.user_id,@"avatar_url":userModel.pic_img,@"hx_username":userModel.hx_user_name};//扩展消息部分
    
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        NSLog(@"%@",[GYHTimeTool timeStr:[message timestamp]]);
        if(error){
            NSLog(@"error----%@",error);
        }
    }];
    [self.messageArr addObject:message];
    self.inputView.text = nil;
    [self.tableview reloadData];
    [self scrollToTableBottom];
    return YES;
}


#pragma mark 发送聊天消息
- (void)sendMsgWithText:(NSString *)text bodyType:(NSString *)bodyType VideoTime:(NSString *)videotim{
    

}







#pragma mark - 右侧添加按钮
- (IBAction)addView
{
    UITextView *test = [[UITextView alloc]init];
    test.delegate = self;
    [self.btn addSubview:test];
    
    AddView *view = [[AddView alloc]initWithFrame:CGRectMake(0, kScreenHeight-218, kScreenWidth, 218)];
    test.inputAccessoryView = nil;
    test.inputView = nil;
    test.inputView = view;
    
    [test becomeFirstResponder];
    
    if (self.btn.tag == 0) {
        self.btn.tag = 1;
    }else {
        [test resignFirstResponder];
        self.btn.tag = 0;
    }
}


#pragma mark - 录音
- (IBAction)soundvoice
{
    DLog(@"开始录音");
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    UIButton *backrecordBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    backrecordBtn.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.4];
    backrecordBtn.backgroundColor = [UIColor whiteColor];
    [backrecordBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:backrecordBtn];
    
//    LVRecordView *v = [[LVRecordView alloc]initWithFrame:CGRectMake(0, Screen_height - 250, Screen_width, 200)];
//    v.delegate = self;
//    v.backgroundColor = [UIColor clearColor];
//    [backrecordBtn addSubview:v];
    self.backrecordBtn = backrecordBtn;
}

- (void)LVRecordTime:(double)time
{
    NSLog(@"%.0f",time);
    self.recordTime = [NSString stringWithFormat:@"%.0f''",time];
}

-(void)LVRecordDoneRecord:(NSURL *)recordURL
{
    self.recordURL = recordURL;
    NSLog(@"完成录制");
    [self.backrecordBtn removeFromSuperview];
    
    
}


#pragma mark - 点击背部遮盖退出录音
- (void)backBtnClick:(UIButton *)btn
{
//    if ([self.lvrecordTool.player isPlaying]) [self.lvrecordTool stopPlaying];
//    if ([self.lvrecordTool.recorder isRecording]) [self.lvrecordTool stopRecording];
//    [self.lvrecordTool destructionRecordingFile];
//    [btn removeFromSuperview];
}






/**
 *  键盘通知方法
 *
 *  @param note 键盘通知的参数
 */
-(void)click:(NSNotification *)note
{
    self.view.window.backgroundColor = self.tableview.backgroundColor;
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.topToolView.y = -transformY;
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

#pragma mark  - 滚动到底部
-(void)scrollToTableBottom{
    NSInteger lastRow = self.messageArr.count - 1;
    if (lastRow < 0) {
        //行数如果小于0，不能滚动
        return;
    }
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableview scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
}

@end

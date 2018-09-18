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

#import "ContactListSelectViewController.h"

#import "ChatViewController.h"
#import "UserProfileManager.h"
#import "NSHuanXinUserModel.h"
#import "ADOrderTopToolView.h"
#import "NSMessageAPI.h"

@interface ContactListSelectViewController () <EMUserListViewControllerDelegate,EMUserListViewControllerDataSource>
@property(nonatomic,strong)NSMutableArray *friendListArr;/* 好友列表数组 */

@end

@implementation ContactListSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    self.friendListArr = [NSMutableArray array];
    [self setUpNavTopView];
    [self loadDataSource];
    self.tableView.frame = CGRectMake(0, TopBarHeight, self.view.frame.size.width,self.view.frame.size.height -TopBarHeight);
    
//    self.title = NSLocalizedString(@"title.chooseContact", @"select the contact");
    
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    backButton.accessibilityIdentifier = @"back";
//    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:NSLocalizedString(@"title.chooseContact", @"select the contact")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

#pragma mark - EMUserListViewControllerDelegate
- (void)userListViewController:(EaseUsersListViewController *)userListViewController
            didSelectUserModel:(id<IUserModel>)userModel
{
    if (!self.messageModel) {
        return;
    }
    
    if (self.messageModel.bodyType == EMMessageBodyTypeText) {
        [self forwardTextMessageToUser:userModel];
    } else if (self.messageModel.bodyType == EMMessageBodyTypeImage) {
        [self forwardImageMessageToUser:userModel];
    } else if (self.messageModel.bodyType == EMMessageBodyTypeVideo) {
        [self forwardVideoMessageToUser:userModel];
    }
}


- (void)forwardTextMessageToUser:(id<IUserModel>)userModel {
    EMMessage *message = [EaseSDKHelper getTextMessage:self.messageModel.text to:userModel.buddy messageType:EMChatTypeChat messageExt:self.messageModel.message.ext];
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            UIViewController *chatController = [[ChatViewController alloc]
                              initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
            chatController.title = userModel.nickname.length != 0 ? [userModel.nickname copy] : [userModel.buddy copy];
            if ([array count] >= 3) {
                [array removeLastObject];
                [array removeLastObject];
            }
            [array addObject:chatController];
            [weakself.navigationController setViewControllers:array animated:YES];
        } else {
            [weakself showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
        }
    }];
}

- (void)forwardImageMessageToUser:(id<IUserModel>)userModel {
    [self showHudInView:self.view hint:NSLocalizedString(@"transponding", @"transponding...")];
    
    __weak typeof(self) weakSelf = self;
    NSString *thumbnailLocalPath = [(EMImageMessageBody *)self.messageModel.message.body thumbnailLocalPath];
    NSString *localPath = [(EMImageMessageBody *)self.messageModel.message.body localPath];
    UIImage *image = [UIImage imageWithContentsOfFile:(thumbnailLocalPath && thumbnailLocalPath.length > 0) ? thumbnailLocalPath:localPath];
    
    void (^block)() = ^(EMMessage *message){
        EMImageMessageBody *imgBody = (EMImageMessageBody *)message.body;
        NSString *from = [[EMClient sharedClient] currentUsername];
        EMImageMessageBody *newBody = [[EMImageMessageBody alloc] initWithData:nil thumbnailData:[NSData dataWithContentsOfFile:imgBody.thumbnailLocalPath]];
        newBody.thumbnailLocalPath = imgBody.thumbnailLocalPath;
        newBody.thumbnailRemotePath = imgBody.thumbnailRemotePath;
        newBody.remotePath = imgBody.remotePath;
        EMMessage *newMsg = [[EMMessage alloc] initWithConversationID:userModel.buddy from:from to:userModel.buddy body:newBody ext:message.ext];
        newMsg.chatType = EMChatTypeChat;
        
        [[EMClient sharedClient].chatManager sendMessage:newMsg progress:nil completion:^(EMMessage *message, EMError *error) {
            if (error) {
                [weakSelf showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
                [weakSelf performSelector:@selector(backAction) withObject:nil afterDelay:1];
                return ;
            }
            
            [(EMImageMessageBody *)message.body setLocalPath:imgBody.localPath];
            [[EMClient sharedClient].chatManager updateMessage:message completion:nil];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[weakSelf.navigationController viewControllers]];
            
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
            chatController.title = userModel.nickname.length != 0 ? userModel.nickname : userModel.buddy;
            if ([array count] >= 3) {
                [array removeLastObject];
                [array removeLastObject];
            }
            [array addObject:chatController];
            [weakSelf.navigationController setViewControllers:array animated:YES];
        }];
    };
    
    if (!image) {
        [[EMClient sharedClient].chatManager downloadMessageThumbnail:self.messageModel.message progress:nil completion:^(EMMessage *message, EMError *error) {
            if (error) {
                [weakSelf showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
                [weakSelf performSelector:@selector(backAction) withObject:nil afterDelay:1];
                return ;
            }
            
            block(message);
        }];
    } else {
        block(self.messageModel.message);
    }
    
}

- (void)forwardVideoMessageToUser:(id<IUserModel>)userModel {
    [self showHudInView:self.view hint:NSLocalizedString(@"transponding", @"transponding...")];
    
    __weak typeof(self) weakSelf = self;
    NSString *localPath = [(EMVideoMessageBody *)self.messageModel.message.body localPath];
    EMDownloadStatus downloadStatus = [(EMVideoMessageBody *)self.messageModel.message.body downloadStatus];
    
    void (^block)() = ^(EMMessage *message){
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)message.body;
        NSString *from = [[EMClient sharedClient] currentUsername];
        EMVideoMessageBody *newBody = [[EMVideoMessageBody alloc] initWithLocalPath:[videoBody localPath]
                                                                        displayName:@"video.mp4"];
        newBody.thumbnailLocalPath = videoBody.thumbnailLocalPath;
        EMMessage *newMsg = [[EMMessage alloc] initWithConversationID:userModel.buddy from:from to:userModel.buddy body:newBody ext:message.ext];
        newMsg.chatType = EMChatTypeChat;
        
        [[EMClient sharedClient].chatManager sendMessage:newMsg progress:nil completion:^(EMMessage *message, EMError *error) {
            if (error) {
                [weakSelf showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
                [weakSelf performSelector:@selector(backAction) withObject:nil afterDelay:1];
                return ;
            }
            
            [(EMImageMessageBody *)message.body setLocalPath:videoBody.localPath];
            [[EMClient sharedClient].chatManager updateMessage:message completion:nil];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[weakSelf.navigationController viewControllers]];
            
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
            chatController.title = userModel.nickname.length != 0 ? userModel.nickname : userModel.buddy;
            if ([array count] >= 3) {
                [array removeLastObject];
                [array removeLastObject];
            }
            [array addObject:chatController];
            [weakSelf.navigationController setViewControllers:array animated:YES];
        }];
    };
    
    if (!localPath || downloadStatus != EMDownloadStatusSuccessed) {
        [[EMClient sharedClient].chatManager downloadMessageAttachment:self.messageModel.message progress:nil completion:^(EMMessage *message, EMError *error) {
            if (error) {
                [weakSelf showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
                [weakSelf performSelector:@selector(backAction) withObject:nil afterDelay:1];
                return ;
            }
            
            block(message);
        }];
    } else {
        block(self.messageModel.message);
    }
    
}

- (void)loadDataSource
{
    
    [self.friendListArr removeAllObjects];
    [NSMessageAPI getFriendList:nil success:^(NSFriendListModel * _Nullable result) {
        DLog(@"获取好友列表成功");
        self.friendListArr = [NSMutableArray arrayWithArray:result.list];
        
        NSArray *buddyList = [[EMClient sharedClient].contactManager getContacts];
        for (NSString *username in buddyList) {
            
            NSHuanXinUserModel *model = [[NSHuanXinUserModel alloc] initWithBuddy:username];
            [model getInformationWith:self.friendListArr];
            
            if (model) {
                model.nickname = model.nick_name;
                NSString *imageUrl = model.user_avatar;
                NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                model.avatarImage =  [UIImage imageWithData:data];
            }
            if(![model.hx_user_name isEqualToString:@"hx_admin"]){
                [self.dataArray addObject:model];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        DLog(@"获取好友列表失败");
    }];
}

#pragma mark - EMUserListViewControllerDataSource
- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                           modelForBuddy:(NSString *)buddy
{
    id<IUserModel> model = nil;
//    NSHuanXinUserModel *model = nil;
    
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.buddy];
    for (NSHuanXinUserModel *hxModel in self.dataArray) {
        if([hxModel.hx_user_name isEqualToString:model.buddy]){
            if (profileEntity) {
                model.nickname= hxModel.nick_name;
                model.avatarURLPath = hxModel.user_avatar;
            }
        }
    }
    
    return model;

}

- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                   userModelForIndexPath:(NSIndexPath *)indexPath
{
//    id<IUserModel> hxModel = nil;
    
    NSHuanXinUserModel *hxModel = [self.dataArray objectAtIndex:indexPath.row];
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:hxModel.hx_user_name];
    if (profileEntity) {
        hxModel.nickname= hxModel.nick_name;
        hxModel.avatarURLPath = hxModel.user_avatar;
    }
    return hxModel;
}

#pragma mark - action
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

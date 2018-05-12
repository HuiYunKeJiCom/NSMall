//
//  FriendsViewController.m
//  testhuanxin
//
//  Created by gyh on 16/5/4.
//  Copyright © 2016年 apple. All rights reserved.
//  联系人

#import "FriendsViewController.h"
#import "UIBarButtonItem+gyh.h"
#import "AddFriendViewController.h"
#import "ChatViewController.h"
#import "NSNavView.h"


@interface FriendsViewController ()<EMClientDelegate,EMContactManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
}

@property (nonatomic , strong) NSArray *friendArr;
@end

@implementation FriendsViewController

- (NSArray *)friendArr
{
    if (!_friendArr) {
        _friendArr = [NSArray array];
    }
    return _friendArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableview = [[UITableView alloc]init];
    tableview.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    
    
//    UIBarButtonItem *barbutton = [UIBarButtonItem ItemTitle:@"添加好友" target:self action:@selector(addFriend)];
//    self.navigationItem.rightBarButtonItem = barbutton;

    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    [self setUpNavTopView];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    NSNavView *topToolView = [[NSNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    topToolView.backgroundColor = k_UIColorFromRGB(0xffffff);
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"联系人")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [self.navigationController popViewControllerAnimated:YES];
    };
    topToolView.rightItemClickBlock = ^{
        [weakSelf addFriend];
    };
    
    [self.view addSubview:topToolView];
    [self.view bringSubviewToFront:topToolView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        if (!error) {
            NSLog(@"获取成功 -- %@",userlist);
            self.friendArr = userlist;
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableview reloadData];
            });
        }else{
            NSLog(@"获取失败 -- %@",error);
        }
    });
}


#pragma mark - 监听自动登录的状态
- (void)didAutoLoginWithError:(EMError *)aError
{
    if (!aError) {
        NSLog(@"自动登录成功");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
            NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
            if (!error) {
                NSLog(@"自动登录成功以后获取用户列表 -- %@",userlist);
                self.friendArr = userlist;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableview reloadData];
                });
            }else{
                NSLog(@"自动登录成功以后获取用户列表失败 -- %@",error);
            }
        });
        
    }else{
        NSLog(@"自动登录失败");
    }
}

#pragma mark - 有新的好友
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        if (!error) {
            NSLog(@"有新的好友获取用户列表 -- %@",userlist);
            self.friendArr = userlist;
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableview reloadData];
            });
        }else{
            NSLog(@"有新的好友获取用户列表失败 -- %@",error);
        }
    });
}


#pragma mark - 被好友删除之后回调
- (void)didReceiveDeletedFromUsername:(NSString *)aUsername
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        if (!error) {
            NSLog(@"被人删除获取用户列表 -- %@",userlist);
            self.friendArr = userlist;
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableview reloadData];
            });
        }else{
            NSLog(@"被人删除获取用户列表失败 -- %@",error);
        }
    });
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    cell.imageView.image = [UIImage imageNamed:@"1"];
    cell.textLabel.text = self.friendArr[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    chatVC = [story instantiateViewControllerWithIdentifier:@"ChatViewControl"];
    chatVC.fromname = self.friendArr[indexPath.row];
    [self.navigationController pushViewController:chatVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除好友
        [[EMClient sharedClient].contactManager deleteContact:self.friendArr[indexPath.row]];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}



- (void)addFriend
{
    AddFriendViewController *addVC = [[AddFriendViewController alloc]init];
    addVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:addVC animated:YES];
}


@end

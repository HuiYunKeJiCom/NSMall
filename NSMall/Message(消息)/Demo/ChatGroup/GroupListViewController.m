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

#import "GroupListViewController.h"

#import "BaseTableViewCell.h"
#import "ChatViewController.h"
#import "CreateGroupViewController.h"
#import "PublicGroupListViewController.h"
#import "RealtimeSearchUtil.h"
#import "ADOrderTopToolView.h"

#import "UIViewController+SearchController.h"

@interface GroupListViewController ()<EMSearchControllerDelegate, EMGroupManagerDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation GroupListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableArray array];
        self.page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.title = NSLocalizedString(@"title.group", @"Group");
    self.showRefreshHeader = YES;
    
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    backButton.accessibilityIdentifier = @"back";
//    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self setupSearchController];
    
    // Registered as SDK delegate
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataSource) name:@"reloadGroupList" object:nil];
    
    [self setUpNavTopView];
    
    [self reloadDataSource];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = KMainColor;
    [topToolView setTopTitleWithNSString:NSLocalizedString(@"title.group", @"Group")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:topToolView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self cancelSearch];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    }
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedString(@"group.create.group",@"Create a group");
                cell.imageView.image = [UIImage imageNamed:@"group_creategroup"];
                break;
            case 1:
                cell.textLabel.text = NSLocalizedString(@"group.create.join",@"Join public group");
                cell.imageView.image = [UIImage imageNamed:@"group_joinpublicgroup"];
                break;
            default:
                break;
        }
    } else {
        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
        NSString *imageName = @"group_header";
//        NSString *imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
        cell.imageView.image = [UIImage imageNamed:imageName];
        
        if (group.subject && group.subject.length > 0) {
//            cell.textLabel.text = group.subject;
            
            if([group.subject rangeOfString:@"groupName"].location !=NSNotFound){
                NSDictionary *dict = [self dictionaryWithJsonString:group.subject];
                if(dict[@"groupName"] && [[dict[@"groupName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isEqualToString:@"未命名"]){
                    NSLog(@"群组未命名");
                    
                    NSArray *memberArr = dict[@"jsonArray"];
                    NSString *titleStr = @"";
                    if(memberArr.count >3){
                        for(int i=0;i<3;i++){
                            NSDictionary *dictionary = memberArr[i];
                            if(i==0){
                                titleStr = [titleStr stringByAppendingFormat:@"%@", [dictionary[@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            }else{
                                titleStr = [titleStr stringByAppendingFormat:@"、%@", [dictionary[@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            }
                        }
                    }else{
                        for(int i=0;i<memberArr.count;i++){
                            NSDictionary *dictionary = memberArr[i];
                            if(i==0){
                                titleStr = [titleStr stringByAppendingFormat:@"%@", [dictionary[@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            }else{
                                titleStr = [titleStr stringByAppendingFormat:@"、%@", [dictionary[@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            }
                        }
                    }
                    cell.textLabel.text = titleStr;
                    NSLog(@"titleStr = %@",titleStr);
                    
                }else if(dict[@"groupName"]){
                    cell.textLabel.text = dict[@"groupName"];
                }
        }
        }
        else {
            cell.textLabel.text = group.groupId;
        }
        DLog(@"subject = %@",group.subject);
        DLog(@"groupId = %@",group.groupId);
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self createGroup];
                break;
            case 1:
                [self showPublicGroupList];
                break;
            default:
                break;
        }
    } else {
        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
        
        UIViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
        
        NSString *titleStr = @"";
        if (group.subject && group.subject.length > 0) {
            if([group.subject rangeOfString:@"groupName"].location !=NSNotFound){
                NSDictionary *dict = [self dictionaryWithJsonString:group.subject];
                if(dict[@"groupName"] && [[dict[@"groupName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isEqualToString:@"未命名"]){
                    NSLog(@"群组未命名");
                    
                    NSArray *memberArr = dict[@"jsonArray"];
                    
                    if(memberArr.count >3){
                        for(int i=0;i<3;i++){
                            NSDictionary *dictionary = memberArr[i];
                            if(i==0){
                                titleStr = [titleStr stringByAppendingFormat:@"%@", [dictionary[@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            }else{
                                titleStr = [titleStr stringByAppendingFormat:@"、%@", [dictionary[@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            }
                        }
                    }else{
                        for(int i=0;i<memberArr.count;i++){
                            NSDictionary *dictionary = memberArr[i];
                            if(i==0){
                                titleStr = [titleStr stringByAppendingFormat:@"%@", [dictionary[@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            }else{
                                titleStr = [titleStr stringByAppendingFormat:@"、%@", [dictionary[@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            }
                        }
                    }
                }else if(dict[@"groupName"]){
                    titleStr = dict[@"groupName"];
                }
            }
        }
        chatController.title = titleStr;
        
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    return contentView;
}

#pragma mark - EMGroupManagerDelegate

- (void)didUpdateGroupList:(NSArray *)groupList
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:groupList];
    [self.tableView reloadData];
}
                                                       
#pragma mark - EMSearchControllerDelegate
                                                       
- (void)willSearchBegin
{
    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}
                                                       
- (void)cancelButtonClicked
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
}
                                               
- (void)searchTextChangeWithString:(NSString *)aString
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:aString collationStringSelector:@selector(subject) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.resultController.displaySource removeAllObjects];
                [weakSelf.resultController.displaySource addObjectsFromArray:results];
                [weakSelf.resultController.tableView reloadData];
            });
        }
    }];
}

#pragma mark - private

- (void)setupSearchController
{
//    改动过
//    [self enableSearchController];
    [self disableSearchController];
    
    __weak GroupListViewController *weakSelf = self;
    [self.resultController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *CellIdentifier = @"ContactListCell";
        BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        // Configure the cell...
        if (cell == nil) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        EMGroup *group = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        NSString *imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
        cell.imageView.image = [UIImage imageNamed:imageName];
        cell.textLabel.text = group.subject;

        return cell;
    }];

    [self.resultController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        return 50;
    }];

    [self.resultController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        EMGroup *group = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        UIViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
        chatVC.title = group.subject;
        [weakSelf.navigationController pushViewController:chatVC animated:YES];
                                               
        [weakSelf cancelSearch];
    }];
    
    UISearchBar *searchBar = self.searchController.searchBar;
    CGRect frame = searchBar.frame;
    if (frame.size.width == 0) {
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        frame.size.height = 45;
        searchBar.frame = frame;
    }
//    self.tableView.tableHeaderView = searchBar;
    self.tableView.frame = CGRectMake(0, TopBarHeight, self.view.frame.size.width,self.view.frame.size.height-TopBarHeight);
}
                                                       
#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    self.page = 1;
    [self fetchGroupsWithPage:self.page isHeader:YES];
}

- (void)tableViewDidTriggerFooterRefresh
{
    self.page += 1;
    [self fetchGroupsWithPage:self.page isHeader:NO];
}

- (void)fetchGroupsWithPage:(NSInteger)aPage
                   isHeader:(BOOL)aIsHeader
{
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *groupList = [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:aPage pageSize:50 error:&error];
        [weakSelf tableViewDidFinishTriggerHeader:aIsHeader reload:NO];
        
        if (weakSelf)
        {
            GroupListViewController *strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf hideHud];
                
                if (!error)
                {
                    if (aIsHeader) {
                        NSMutableArray *oldChatrooms = [weakSelf.dataSource mutableCopy];
                        [weakSelf.dataSource removeAllObjects];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [oldChatrooms removeAllObjects];
                        });
                    }
                    
                    [strongSelf.dataSource addObjectsFromArray:groupList];
                    [strongSelf.tableView reloadData];
                    if (groupList.count == 50) {
                        strongSelf.showRefreshFooter = YES;
                    } else {
                        strongSelf.showRefreshFooter = NO;
                    }
                }
            });
        }
    });
}

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    NSArray *rooms = [[EMClient sharedClient].groupManager getJoinedGroups];
    [self.dataSource addObjectsFromArray:rooms];
    
    [self.tableView reloadData];
}

#pragma mark - action

- (void)showPublicGroupList
{
    PublicGroupListViewController *publicController = [[PublicGroupListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:publicController animated:YES];
}

- (void)createGroup
{
    CreateGroupViewController *createChatroom = [[CreateGroupViewController alloc] init];
    [self.navigationController pushViewController:createChatroom animated:YES];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSLog(@"jsonData = %@",jsonData);
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

@end

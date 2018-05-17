//
//  TDCountryCtrl.m
//  Trade
//
//  Created by FeiFan on 2017/9/8.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDCountryCtrl.h"
#import "TDCountryDataSource.h"
#import "UIImage+SizeAndTintColor.h"

@interface TDCountryCtrl () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) TDCountryDataSource* dataSource;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, copy) NSIndexPath* selectedIndexPath;
@end

@implementation TDCountryCtrl

# pragma mark - IBActions

- (IBAction) clickedCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) clickedSure:(id)sender {
    if (self.didSelectedCountryModel) {
        self.didSelectedCountryModel([self.dataSource countryModelAtIndexPath:self.selectedIndexPath]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) reloadDatas {
    //这里需要修改
//    WEAK_SELF
//    [MBProgressHUD mb_showWaitingWithText:nil detailText:nil inView:self.view];
//    [self.dataSource getCountryDatasOnSuccess:^(id data) {
//        [MBProgressHUD hideHUDForView:weak_self.view animated:YES];
//        [weak_self.tableView reloadData];
//    } fail:^(NSString *msg) {
//        [MBProgressHUD hideHUDForView:weak_self.view animated:YES];
//        [MBProgressHUD mb_showOnlyText:KLocalizableStr(@"获取国家码失败!") detail:msg delay:1.5 inView:weak_self.view];
//    }];
}

# pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //这里需要修改
//    WEAK_SELF
//    [self.dataSource filterringWithText:searchText onFinished:^{
//        [weak_self.tableView reloadData];
//    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    [searchBar endEditing:YES];
}


# pragma mark - UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    self.title = [self.dataSource countryNameAtIndexPath:indexPath];
    [tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GetScaleWidth(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return GetScaleWidth(34);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TDCountryTBHeader"];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"TDCountryTBHeader"];
        header.contentView.backgroundColor = KColorSubBackground;
        header.textLabel.textColor = KColorTextTitle;
        header.textLabel.font = UIBoldFontSize(15);
    }
    header.textLabel.text = [@"  " stringByAppendingString:[self.dataSource sectionNameInSection:section]];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = KColorMainBackground;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.textLabel.textColor = KColorTextContent;
        cell.textLabel.font = UIBoldFontSize(15);
        cell.tintColor = KColorMainOrange;
    }
    cell.textLabel.text = [self.dataSource countryNameAtIndexPath:indexPath];
    cell.accessoryType = indexPath == self.selectedIndexPath ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.dataSource sectionIndexs];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}


# pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDatas];
    [self setupViews];
}

- (void)setupDatas {
    self.title = KLocalizableStr(@"地区");
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = KColorMainBackground;
}

- (void)setupViews {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:KLocalizableStr(@"取消") style:UIBarButtonItemStylePlain target:self action:@selector(clickedCancel:)];
    self.navigationItem.leftBarButtonItem.tintColor = KColorMainOrange;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:KLocalizableStr(@"完成") style:UIBarButtonItemStylePlain target:self action:@selector(clickedSure:)];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(GetScaleWidth(50));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.searchBar.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadDatas];
}

# pragma mark - getter

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.barStyle = UIBarStyleBlack;
        _searchBar.tintColor = KColorMainOrange;
        _searchBar.backgroundImage = [UIImage imageWithCustomColor:KBGCOLOR];
        _searchBar.delegate = self;
        _searchBar.placeholder = KLocalizableStr(@"搜索");
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = KColorMainBackground;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionIndexColor = KColorTextTitle;
        _tableView.sectionIndexBackgroundColor = KColorMainBackground;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (TDCountryDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [TDCountryDataSource new];
    }
    return _dataSource;
}

@end

//
//  TDUserCertifySubVCBasic.m
//  Trade
//
//  Created by FeiFan on 2017/8/30.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifySubVCBasic.h"
#import "TDUserCertifyDataBasic.h"
#import "TDUserCertifyCellTxtInput.h"
#import "TDUserCertifyCellPicker.h"
#import "TDCountryCtrl.h"
#import "TDCountryCodesModel.h"
#import "JFPickerController.h"
#import "JFDatePickerController.h"

@interface TDUserCertifySubVCBasic () <UITableViewDelegate, UITableViewDataSource, JFPickerControllerDelegate, JFDatePickerControllerDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* commitBtn;
@property (nonatomic, strong) TDUserCertifyDataBasic* dataSource;
@property (nonatomic, strong) JFPickerController* pickerCtrl;
@property (nonatomic, strong) JFDatePickerController* datePicker;
@end

@implementation TDUserCertifySubVCBasic

# pragma mark - datasource

// 重载数据源
- (void) reloadDatas {
    // 刷新数据源
    [self.dataSource reloadDatas];
    // 刷新表格
    [self.tableView reloadData];
}


# pragma mark - IBActions 
- (IBAction) clickedCommitBtn:(id)sender {
    [self.dataSource commitDatas];
    if (self.touchEvent) {
        self.touchEvent();
    }
}


# pragma mark - JFDatePickerControllerDelegate

- (void)datePickerCtrl:(JFDatePickerController *)datePickerCtrl hiddenWithSelectedDate:(NSDate *)date {
    [self.dataSource updateBirthDayWithValue:date];
    [self.tableView reloadData];
}

# pragma mark - JFPickerControllerDelegate
// section 个数
- (NSInteger) numberOfSections {
    return 1;
}

// 指定section的rows个数
- (NSInteger) pickerController:(JFPickerController*)pickerController numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// 指定索引的title
- (NSString*) pickerController:(JFPickerController*)pickerController titleForRowAtIdexPath:(NSIndexPath*)indexPath {
    return indexPath.row == 0 ? TDUserCertifySexMan : TDUserCertifySexWoman;
}

// 返回选定的索引
- (void) pickerController:(JFPickerController*)pickerController hiddenWithPickedIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == 0) {
        [self.dataSource updateSexWithValue:@(1)];
    } else {
        [self.dataSource updateSexWithValue:@(0)];
    }
    [self.tableView reloadData];
}

# pragma mark - UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TDUserCertifyDataBasicNode* certifierNode = [self.dataSource dataNodeAtRow:indexPath.row];
    // 点击了"国家"cell
//    if ([certifierNode.title isEqualToString:KLocalizableStr(TDUserCertifyTitleCountry)]) {
//        TDCountryCtrl* countryVC = [TDCountryCtrl new];
//        countryVC.didSelectedCountryModel = ^(TDCountryCodesModel *model) {
//            if (model) {
//                certifierNode.value = model.nameCn;
//                [tableView reloadData];
//            }
//        };
//        [self.navigationController pushViewController:countryVC animated:YES];
//    }
    // 点击了"性别"cell
//    else
        if ([certifierNode.title isEqualToString:KLocalizableStr(TDUserCertifyTitleSex)]) {
        [self.pickerCtrl showPicker];
    }
    // 点击了"出生日期"cell
    else if ([certifierNode.title isEqualToString:KLocalizableStr(TDUserCertifyTitleBirth)]) {
        [self.datePicker showPicker];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfRows];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource heightForCellAtRow:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDUserCertifyDataBasicNode* certifierNode = [self.dataSource dataNodeAtRow:indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:certifierNode.cellIdentifier];
    if (!cell) {
        if ([certifierNode.cellIdentifier isEqualToString:TDUserCertifyCellTypeTxtInputed]) {
            cell = [[TDUserCertifyCellTxtInput alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:certifierNode.cellIdentifier];
        } else {
            cell = [[TDUserCertifyCellPicker alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:certifierNode.cellIdentifier];
        }
    }
    // 输入类型的
    [self setupCell:cell atIndexPath:indexPath];
    return cell;
}

- (void) setupCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    TDUserCertifyDataBasicNode* certifierNode = [self.dataSource dataNodeAtRow:indexPath.row];
    // 输入型
    if ([certifierNode.cellIdentifier isEqualToString:TDUserCertifyCellTypeTxtInputed]) {
        TDUserCertifyCellTxtInput* inputCell = (TDUserCertifyCellTxtInput*)cell;
        inputCell.titleLabel.text = certifierNode.title;
        inputCell.textField.placeholder = certifierNode.placeHolder;
        inputCell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:inputCell.textField.placeholder attributes:@{NSForegroundColorAttributeName: kGreyColor}];
        inputCell.textField.tag = indexPath.row;
        @weakify(self);
        [[[inputCell.textField.rac_textSignal takeUntil:inputCell.rac_prepareForReuseSignal] skip:1] subscribeNext:^(NSString* value) {
            @strongify(self);
            TDUserCertifyDataBasicNode* node = [self.dataSource dataNodeAtRow:inputCell.textField.tag];
            node.value = value;
        }];
        inputCell.textField.text = certifierNode.value;
    }
    // 选择型
    else {
        TDUserCertifyCellPicker* pickerCell = (TDUserCertifyCellPicker*)cell;
        pickerCell.titleLabel.text = certifierNode.title;
        // 国家
        if ([certifierNode.title isEqualToString:KLocalizableStr(TDUserCertifyTitleCountry)]) {
            pickerCell.valueLabel.text = certifierNode.value;
        }
        // 性别
        else if ([certifierNode.title isEqualToString:KLocalizableStr(TDUserCertifyTitleSex)]) {
            pickerCell.valueLabel.text = [certifierNode.value integerValue] == 1 ? KLocalizableStr(TDUserCertifySexMan) : KLocalizableStr(TDUserCertifySexWoman);
        }
        // 生日
        else if ([certifierNode.title isEqualToString:KLocalizableStr(TDUserCertifyTitleBirth)]) {
            NSDateFormatter* dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            NSDate* date = certifierNode.value;
            if (date) {
                pickerCell.valueLabel.text = [dateFormatter stringFromDate:date];
            }
        }
        // 证件类型
        else if ([certifierNode.title isEqualToString:KLocalizableStr(TDUserCertifyTitleIdType)]) {
            pickerCell.valueLabel.text = [certifierNode.value integerValue] == 1 ? KLocalizableStr(@"身份证") : KLocalizableStr(@"未知");
        }
    }
}

# pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDatas];
    [self initializeViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initializeDatas {
    self.view.backgroundColor = KColorMainBackground;
    RAC(self.commitBtn, enabled) = RACObserve(self.dataSource, dataAllInputed);
}

- (void) initializeViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitBtn];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetScaleWidth(25));
        make.right.mas_equalTo(GetScaleWidth(-25));
        make.bottom.mas_equalTo(GetScaleWidth(-20));
        make.height.mas_equalTo(44);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.commitBtn.mas_top).offset(GetScaleWidth(-20));
    }];
}

# pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = KColorMainBackground;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (TDUserCertifyDataBasic *)dataSource {
    if (!_dataSource) {
        _dataSource = [TDUserCertifyDataBasic new];
    }
    return _dataSource;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [UIButton new];
        _commitBtn.backgroundColor = KMainColor;
        _commitBtn.layer.cornerRadius = 5;
        [_commitBtn setTitle:KLocalizableStr(@"提交") forState:UIControlStateNormal];
        [_commitBtn setTitleColor:KBGCOLOR forState:UIControlStateNormal];
        [_commitBtn setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        [_commitBtn setTitleColor:kWhiteColor forState:UIControlStateDisabled];
        [_commitBtn addTarget:self action:@selector(clickedCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (JFPickerController *)pickerCtrl {
    if (!_pickerCtrl) {
        _pickerCtrl = [[JFPickerController alloc] init];
        _pickerCtrl.delegate = self;
        _pickerCtrl.normalTextColor = kWhiteColor;
        _pickerCtrl.pickerViewBackgroundColor = KColorSubBackground;
    }
    return _pickerCtrl;
}

- (JFDatePickerController *)datePicker {
    if (!_datePicker) {
        _datePicker = [JFDatePickerController new];
        _datePicker.delegate = self;
    }
    return _datePicker;
}

@end

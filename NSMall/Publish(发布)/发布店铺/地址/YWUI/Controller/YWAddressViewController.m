//
//  YWAddressViewController.m
//  YWChooseAddress
//
//  Created by Candy on 2018/2/8.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import "YWAddressViewController.h"

#import "YWChooseAddressView.h"

#import <ContactsUI/ContactsUI.h>
#import "YWTool.h"

#import "YWAddressTableViewCell1.h"
#import "YWAddressTableViewCell2.h"
#import "YWAddressTableViewCell3.h"
#import "ADAddressLabelTableViewCell.h"

#define CELL_IDENTIFIER1     @"YWAddressTableViewCell1"
#define CELL_IDENTIFIER2     @"YWAddressTableViewCell2"
#define CELL_IDENTIFIER3     @"YWAddressTableViewCell3"

#import "ADAddressTopView.h"//自定义导航栏

@interface YWAddressViewController ()<UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate,UIGestureRecognizerDelegate, CNContactViewControllerDelegate, CNContactPickerDelegate>

/* 顶部Nva */
@property (strong , nonatomic)ADAddressTopView *topToolView;

@property (nonatomic, strong) UITableView         * tableView;
@property (nonatomic, strong) NSArray             * dataSource;
@property (nonatomic, strong) UITextView          * detailTextViw;

@property (nonatomic,strong) YWChooseAddressView  * chooseAddressView;
@property (nonatomic,strong) UIView               * coverView;

@property (nonatomic, strong) UILabel             * promptLable;



- (void)initUserInterface;  /**< 初始化用户界面 */
- (void)initUserDataSource;  /**< 初始化数据源 */

@end

@implementation YWAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBACKGROUNDCOLOR;
    [self initUserDataSource];
    [self initUserInterface];
    [self setUpNavTopView];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[ADAddressTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _topToolView.hidden = NO;
    _topToolView.backgroundColor = [UIColor whiteColor];
    [_topToolView setTopTitleWithNSString:KLocalizableStr(@"添加新地址")];
    if (_model) {
        [_topToolView setTopTitleWithNSString:KLocalizableStr(@"编辑地址")];
    } else {
        _model = [[YWAddressInfoModel alloc] init];
        _model.addressId = @"请选择";
    }
    WEAKSELF
    _topToolView.leftItemClickBlock = ^{
//        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _topToolView.rightItemClickBlock = ^{
        [weakSelf navRightItem];
    };
    
    [self.view addSubview:_topToolView];
    
}


- (void)initUserInterface {
    
    //监听所有的textView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewPlaceholder) name:UITextViewTextDidChangeNotification object:nil];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(navRightItem)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.coverView];
    
}


- (void)initUserDataSource {
    
    _dataSource = @[@[@"收货人", @"联系电话", @"所在地区"],
                    @[@"设为默认"]];
}

#pragma mark -- action

//*** 导航栏右上角 - 保存按钮 ***
- (void)navRightItem {
    
    NSLog(@"点击了保存按钮");
    
    YWAddressTableViewCell1 *nameCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    YWAddressTableViewCell1 *phoneCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    YWAddressTableViewCell3 *defaultCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    ADAddressLabelTableViewCell *labelCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    _model.trueName = nameCell.textField.text;
    _model.mobile = phoneCell.textField.text;
    _model.detailAddress = _detailTextViw.text;
    _model.isDefault = [NSString stringWithFormat:@"%d",defaultCell.rightSwitch.isOn];
    _model.label = labelCell.labelStr;
    
    if(_chooseAddressView.areaId){
        _model.areaId = _chooseAddressView.areaId;
    }
    NSRange range = [_model.areaId rangeOfString:@","];
    if (range.location!=NSNotFound) {
//        NSLog(@"Yes");
        NSArray *tempArr = [_model.areaId componentsSeparatedByString:@","];
        NSString *tempStr = [tempArr lastObject];
        _model.areaId = tempStr;
    }else {
//        NSLog(@"NO");
    }
//    NSLog(@"看看这是啥areaId = %@",_model.areaId);
    
    if (_model.trueName.length == 0) {
        [YWTool showAlterWithViewController:self Message:@"请填写收货人姓名！"];
        return;
    } else if (_model.mobile.length == 0) {
        [YWTool showAlterWithViewController:self Message:@"请填写收货人电话！"];
        return;
    } else if (_model.mobile.length != 11) {
        [YWTool showAlterWithViewController:self Message:@"手机号为11位，如果为座机请加上区号"];
        return;
    } else if ([_model.areaId isEqualToString:@"请选择"]) {
        [YWTool showAlterWithViewController:self Message:@"请选择所在地区"];
        return;
    } else if (_model.detailAddress.length == 0 || _model.detailAddress.length < 5) {
        [YWTool showAlterWithViewController:self Message:@"请填写详细地址，不少于5字"];
        return;
    }else{
        NSLog(@"提交地址");
        if([_model.addressId isEqualToString:@"请选择"]){
            NSLog(@"新增收货地址");
            
            NSDictionary *addressDict = [NSDictionary dictionary];
            if(self.model.label){
                addressDict = @{@"trueName":_model.trueName,@"isDefault":_model.isDefault,@"label":_model.label,@"areaId":_model.areaId,@"detailAddress":_model.detailAddress,@"mobile":_model.mobile};
            }else{
                addressDict = @{@"trueName":_model.trueName,@"isDefault":_model.isDefault,@"areaId":_model.areaId,@"detailAddress":_model.detailAddress,@"mobile":_model.mobile};
            }
            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////            ,@"label":_model.label
//            [RequestTool saveAddress:addressDict withSuccessBlock:^(NSDictionary *result) {
//                NSLog(@"新增收货地址result = %@",result);
//                if([result[@"code"] integerValue] == 1){
//                    NSLog(@"新增收货地址成功");
//                }else if([result[@"code"] integerValue] == -2){
//                    hud.detailsLabelText = @"登录失效";
//                    hud.mode = MBProgressHUDModeText;
//                    [hud hide:YES afterDelay:1.0];
//                }else if([result[@"code"] integerValue] == -1){
//                    hud.detailsLabelText = @"未登录";
//                    hud.mode = MBProgressHUDModeText;
//                    [hud hide:YES afterDelay:1.0];
//                }else if([result[@"code"] integerValue] == 0){
//                    hud.detailsLabelText = @"失败";
//                    hud.mode = MBProgressHUDModeText;
//                    [hud hide:YES afterDelay:1.0];
//                }
//            } withFailBlock:^(NSString *msg) {
//                hud.detailsLabelText = msg;
//                hud.mode = MBProgressHUDModeText;
//                [hud hide:YES afterDelay:1.0];
//            }];
        }else{
            NSLog(@"编辑收货地址");
            
//            _model.areaId = _chooseAddressView.areaId;
            NSDictionary *addressDict = [NSDictionary dictionary];
            if(self.model.label){
                addressDict = @{@"trueName":_model.trueName,@"isDefault":_model.isDefault,@"addressId":_model.addressId,@"label":_model.label,@"areaId":_model.areaId,@"detailAddress":_model.detailAddress,@"mobile":_model.mobile};
            }else{
                addressDict = @{@"trueName":_model.trueName,@"isDefault":_model.isDefault,@"addressId":_model.addressId,@"areaId":_model.areaId,@"detailAddress":_model.detailAddress,@"mobile":_model.mobile};
            }
            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            [RequestTool saveAddress:addressDict withSuccessBlock:^(NSDictionary *result) {
//                NSLog(@"编辑收货地址result = %@",result);
//                if([result[@"code"] integerValue] == 1){
//                    NSLog(@"编辑收货地址成功");
//                }else if([result[@"code"] integerValue] == -2){
//                    hud.detailsLabelText = @"登录失效";
//                    hud.mode = MBProgressHUDModeText;
//                    [hud hide:YES afterDelay:1.0];
//                }else if([result[@"code"] integerValue] == -1){
//                    hud.detailsLabelText = @"未登录";
//                    hud.mode = MBProgressHUDModeText;
//                    [hud hide:YES afterDelay:1.0];
//                }else if([result[@"code"] integerValue] == 0){
//                    hud.detailsLabelText = @"失败";
//                    hud.mode = MBProgressHUDModeText;
//                    [hud hide:YES afterDelay:1.0];
//                }
//            } withFailBlock:^(NSString *msg) {
//                hud.detailsLabelText = msg;
//                hud.mode = MBProgressHUDModeText;
//                [hud hide:YES afterDelay:1.0];
//            }];
        }
    }
    
    // 回调所填写的地址信息（姓名、电话、地址等等）
    if (self.addressBlock) {
        self.addressBlock(_model);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

// textView 水印字体
- (void)textViewPlaceholder {
    self.promptLable.hidden = self.detailTextViw.text.length > 0 ? 1 : 0;
}

#pragma mark *** 弹出选择地区视图 ***
- (void)chooseAddress {
    WeakSelf;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakSelf.coverView.frame = CGRectMake(0, 0, YWScreenW, YWScreenH);
        weakSelf.chooseAddressView.hidden = NO;
    } completion:^(BOOL finished) {
        // 动画结束之后添加阴影
        weakSelf.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseAddressView.frame, point)){
        return NO;
    }
    return YES;
}


- (void)tapCover:(UITapGestureRecognizer *)tap {
    if (_chooseAddressView.chooseFinish) {
        _chooseAddressView.chooseFinish();
    }
}

#pragma mark *** 从通讯录选择联系人 电话 & 姓名 ***
//用户点击 加号按钮 - 选择联系人
- (void)selectContactAction {
    // 弹出联系人列表 - 此方法只使用于 iOS 9.0以后
    CNContactPickerViewController * pickerVC = [[CNContactPickerViewController alloc]init];
    pickerVC.navigationItem.title = @"选择联系人";
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:nil];
}

//这个方法在用户取消选择时调用
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker; {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CNContactPickerDelegate
// 这个方法在用户选择一个联系人后调用
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    // 1.获取姓名
    NSString *firstname = contact.givenName;
    NSString *lastname = contact.familyName;
    NSLog(@"%@%@", lastname, firstname);
    
    //通过姓名寻找联系人
    NSMutableString *fullName = [[NSMutableString alloc] init];
    if ( lastname != nil || lastname.length > 0 ) {
        [fullName appendString:lastname];
    }
    if ( firstname != nil || firstname.length > 0 ) {
        [fullName appendString:firstname];
    }
    
    // 2.获取电话号码
    NSArray *phones = contact.phoneNumbers;
    NSMutableArray *phoneNumbers = [NSMutableArray array];
    // 3.遍历电话号码
    for (CNLabeledValue *labelValue in phones) {
        CNPhoneNumber *phoneNumber = labelValue.value;
        //把 -、+86、空格 这些过滤掉
        NSString *phoneStr = [phoneNumber.stringValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        [phoneNumbers addObject:phoneStr];
    }
    
    NSLog(@"选择的姓名：%@， 电话号码：%@", fullName, phoneNumbers.firstObject);
    _model.trueName = fullName;
    // 这里直接取第一个电话号码，如果有多个请自行添加选择器
    _model.mobile = phoneNumbers.firstObject;
    [_tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark *** UITableViewDataSource & UITableViewDelegate ***
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([_model.isDefault integerValue] ==1) {
        // 如果该地址已经是默认地址，则无需再显示 "设为默认" 这个按钮，即隐藏
        return 2;
    }
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if (indexPath.section == 0) {
        if (indexPath.row < 2) {
            YWAddressTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER1 forIndexPath:indexPath];
            cell.rightBtn.hidden = YES;
            cell.placehodlerStr = @"填写收货人姓名";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.leftStr = _dataSource[indexPath.section][indexPath.row];
            if (_model.trueName.length > 0) {
                cell.textFieldStr = _model.trueName;
            }
            if (indexPath.row == 1) {
                cell.rightBtn.hidden = NO;
                cell.placehodlerStr = @"填写收货人电话";
                cell.textField.keyboardType = UIKeyboardTypePhonePad;
                if (_model.mobile.length > 0) {
                    cell.textFieldStr = _model.mobile;
                }
                cell.contactBlock = ^{
                    [weakSelf selectContactAction];
                };
            }
            return cell;
        }else{
            YWAddressTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER2 forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.leftStr = _dataSource[indexPath.section][indexPath.row];

            NSString *strUrl;
            NSRange range = [_model.areaName rangeOfString:@","];
            if (range.location!=NSNotFound) {
                strUrl = [_model.areaName stringByReplacingOccurrencesOfString:@"," withString:@""];
            }else{
                strUrl = _model.areaName;
            }
            cell.rightStr = strUrl;
            if (![_model.areaId isEqualToString:@""] && ![_model.areaId isEqualToString:@"请选择"]) {
                
                cell.rightLabel.textColor = [UIColor blackColor];
            } else {
                cell.rightLabel.textColor = [UIColor lightGrayColor];
            }
            return cell;
        }
    } else if (indexPath.section == 1){
        ADAddressLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADAddressLabelTableViewCell" forIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.leftStr = @"地址标签";
        return cell;
    }else {
        YWAddressTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER3 forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.leftStr = _dataSource[1][indexPath.row];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = YWCOLOR(240, 240, 240, 1);
        [footerView addSubview:self.detailTextViw];
        return footerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 90;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消cell选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 2) {
        // 选择地区
        [self chooseAddress];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, YWScreenW, YWScreenH-65) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kBACKGROUNDCOLOR;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [UIView new];
        // 设置分割线
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        // 注册cell
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER1 bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER1];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER2 bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER2];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDENTIFIER3 bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER3];
        
        [_tableView registerClass:[ADAddressLabelTableViewCell class] forCellReuseIdentifier:@"ADAddressLabelTableViewCell"];

    }
    return _tableView;
}

- (UITextView *)detailTextViw {
    if (!_detailTextViw) {
        _detailTextViw = [[UITextView alloc] initWithFrame:CGRectMake(0, 1, YWScreenW, 80)];
        _detailTextViw.textContainerInset = UIEdgeInsetsMake(5, 15, 5, 15);
        _detailTextViw.font = [UIFont systemFontOfSize:14];
        [_detailTextViw addSubview:self.promptLable];
        
        if (_model.detailAddress.length > 0) {
            _detailTextViw.text = _model.detailAddress;
            self.promptLable.hidden = YES;
        }
    }
    return _detailTextViw;
}

- (UILabel *)promptLable {
    if (!_promptLable) {
        _promptLable = [[UILabel alloc] initWithFrame:CGRectMake(20 , 2, YWScreenW, 24)];
        _promptLable.text = @"请填写详细地址（尽量精确到单元楼或门牌号)";
        _promptLable.numberOfLines = 0;
        _promptLable.textColor = YWCOLOR(200, 200, 200, 1);
        _promptLable.textAlignment = NSTextAlignmentJustified;
        [_promptLable setFont:[UIFont systemFontOfSize:14]];
    }
    return _promptLable;
}

- (YWChooseAddressView *)chooseAddressView {
    if (!_chooseAddressView) {
        WeakSelf;
        _chooseAddressView = [[YWChooseAddressView alloc]initWithFrame:CGRectMake(0, YWScreenH - 350, YWScreenW, 350)];
        if ([_model.areaId isKindOfClass:[NSNull class]] || [_model.areaId isEqualToString:@""]) {
            _model.areaId = @"请选择";
        }
        
        _chooseAddressView.address = _model.areaId;
        
        _chooseAddressView.chooseFinish = ^{
            weakSelf.coverView.backgroundColor = [UIColor clearColor];
            NSLog(@"选择的地区为：%@", weakSelf.chooseAddressView.address);
            weakSelf.model.areaName = weakSelf.chooseAddressView.address;
//            weakSelf.model.areaId = weakSelf.chooseAddressView.address;
            if (weakSelf.model.areaId.length == 0) {
                weakSelf.model.areaId = @"请选择";
            }
            [weakSelf.tableView reloadData];
            // 隐藏视图 - 动画
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                weakSelf.coverView.frame = CGRectMake(0, YWScreenH, YWScreenW, YWScreenH);
                weakSelf.chooseAddressView.hidden = NO;
            } completion:nil];
        };
    }
    return _chooseAddressView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, YWScreenH, YWScreenW, YWScreenH)];
        [_coverView addSubview:self.chooseAddressView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_coverView addGestureRecognizer:tap];
        tap.delegate = self;
    }
    return _coverView;
}



@end


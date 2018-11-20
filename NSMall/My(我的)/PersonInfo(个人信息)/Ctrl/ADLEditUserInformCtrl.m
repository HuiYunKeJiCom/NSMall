//
//  ADLEditUserInformCtrl.m
//  Lock
//
//  Created by occ on 2017/5/22.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ADLEditUserInformCtrl.h"
#import "UIView+animation.h"
#import "UpdateUserParam.h"
#import "UserInfoAPI.h"

@interface ADLEditUserInformCtrl ()<ADLSexSelectViewDelegate>

@property (nonatomic, strong) UITextField         *contentField;

@property (nonatomic, strong) UIButton            *commitButton;
@property (nonatomic, strong) UILabel             *errorLabel;

@property (nonatomic, strong) ADLSexSelectView     *selectView;
@property (nonatomic, copy)   NSString            *gender;

@property (nonatomic, assign) EditUserType        type;

@end

@implementation ADLEditUserInformCtrl

- (instancetype)initEditType:(EditUserType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = KColorTextFFFFFF;
    
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.contentField];
    [self.view addSubview:self.commitButton];
    [self.view addSubview:self.errorLabel];
    
    //这里已修改
    UserModel *userModel = [UserModel modelFromUnarchive];
    self.gender = [NSString limitStringNotEmpty:userModel.sex == 0 ? NSLocalizedString(@"secrecy", nil) : userModel.sex == 1 ? NSLocalizedString(@"male", nil) : NSLocalizedString(@"female", nil)];

    if (self.type == EditUserTypeGender) {
        self.selectView.hidden = NO;
        self.contentField.hidden = YES;

        if (userModel.sex == 1) {
            [self.selectView refreshIndex:0];
        } else if (userModel.sex == 2){
            [self.selectView refreshIndex:1];
        }

    } else {
        self.selectView.hidden = YES;
        self.contentField.hidden = NO;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.view addGestureRecognizer:tap];
    }
    [self makeConstraints];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma mark - setter / getter

- (void)setEditTitle:(NSString *)editTitle {
    _editTitle = editTitle;
    
    self.title = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"modify", nil),_editTitle];
    
    self.contentField.placeholder = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"enter", nil),_editTitle];
}


- (ADLSexSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[ADLSexSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(40))];
        _selectView.delegate = self;
    }
    return _selectView;
}

- (UITextField *)contentField {
    if (!_contentField) {
        _contentField = [[UITextField alloc] initWithFrame:CGRectZero];
        _contentField.font = UISystemFontSize(13);
        _contentField.textAlignment = NSTextAlignmentCenter;
        
        UILabel * placeholderLabel = [_contentField valueForKey:@"_placeholderLabel"];
        placeholderLabel.textAlignment = NSTextAlignmentCenter;
        
        _contentField.layer.borderColor = KMainColor.CGColor;
        _contentField.layer.borderWidth = 1;
        _contentField.layer.cornerRadius = GetScaleWidth(20);
        _contentField.layer.masksToBounds = YES;
    }
    return _contentField;
}

- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
        [_commitButton setTitleColor:KColorTextFFFFFF forState:UIControlStateNormal];
        _commitButton.titleLabel.font = UISystemFontSize(15);
        _commitButton.backgroundColor = KMainColor;
        _commitButton.layer.cornerRadius = GetScaleWidth(20);
        _commitButton.layer.masksToBounds = YES;
        [_commitButton addTarget:self action:@selector(actionCommit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:KColorText0XFC3A06];
    }
    return _errorLabel;
}



#pragma mark - makeConstraints

- (void)makeConstraints {
    
    WEAKSELF
    
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(GetScaleWidth(16));
        make.right.equalTo(weakSelf.view.mas_right).with.offset(GetScaleWidth(-16));
        make.top.equalTo(weakSelf.view).with.offset(GetScaleWidth(60+TopBarHeight));
        make.height.mas_equalTo(GetScaleWidth(40));
    }];
    
    [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(GetScaleWidth(16));
        make.right.equalTo(weakSelf.view.mas_right).with.offset(GetScaleWidth(-16));
        make.top.equalTo(weakSelf.view).with.offset(GetScaleWidth(60+TopBarHeight));
        make.height.mas_equalTo(GetScaleWidth(40));
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.width.height.mas_equalTo(weakSelf.contentField);
        make.top.mas_equalTo(weakSelf.contentField.mas_bottom).offset(GetScaleWidth(30));
    }];
    
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.contentField.mas_top).offset(GetScaleWidth(-10));
        make.centerX.mas_equalTo(weakSelf.view);
    }];
    
}

#pragma mark - ADLSexSelectViewDelegate

- (void)sexSelectView:(ADLSexSelectView *)sexSelectView index:(NSInteger)index {
    
    switch (index) {
        case 0:
            self.gender = @"1";
            break;
        case 1:
            self.gender = @"2";
            break;
        default:
            self.gender = @"0";
            break;
    }
//    self.gender = index == 0 ? @"1" : @"2";
    [self.view endEditing:YES];
}
#pragma mark - action

- (void)actionCommit:(UIButton *)button {
    
    if (self.type != EditUserTypeGender) {
        
        NSString *errorMsg = [self validateInput];
        
        if (errorMsg.length > 0) {
            
            _errorLabel.text = errorMsg;
            return;
        }
    }
    
    [self.view endEditing:YES];
    WEAKSELF
    //这里已修改
    UserModel *userModel = [UserModel modelFromUnarchive];
    
    
    NSString *gender = @"";
    NSString *nickName = @"";
    if (self.type != EditUserTypeGender) {
        nickName = [_contentField.text trim];
//        nickName = [[_contentField.text trim] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gender = [NSString limitStringNotEmpty:[NSString stringWithFormat:@"%lu",userModel.sex]];
    }else{
        if([self.gender isEqualToString:@"2"] || [self.gender isEqualToString:NSLocalizedString(@"female", nil)]){
            self.gender = @"2";
        }
        if([self.gender isEqualToString:@"1"] || [self.gender isEqualToString:NSLocalizedString(@"male", nil)]){
            self.gender = @"1";
        }
        if([self.gender isEqualToString:@"0"] || [self.gender isEqualToString:NSLocalizedString(@"secrecy", nil)]){
            self.gender = @"0";
        }
        
        nickName = [NSString limitStringNotEmpty:userModel.user_name];
        gender = [self.gender stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    UpdateUserParam *param = [UpdateUserParam new];
    param.userName = nickName;
    param.sex = gender;
    
    [UserInfoAPI updateUserWithParam:param success:^{
        DLog(@"修改信息成功");
        userModel.user_name = nickName;
        userModel.sex = [gender integerValue];
        
        [userModel archive];
        [weakSelf back];
    } faulre:^(NSError *error) {
        DLog(@"修改信息失败");
    }];
}

-(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString * string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return string;
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getChangeKey:(EditUserType)type {
    
    NSString *key = @"";
    switch (self.type) {
        case EditUserTypeNickName:{
            key = @"nickName";
        }
            break;
        case EditUserTypeGender:{
            key = @"gender";
        }
            break;
        case EditUserTypePhone:{
            key = @"phone";
        }
            break;
        default:
            key = @"";
            break;
    }
    return key;
}


- (NSString *)validateInput
{
    NSString *errorMsg = @"";
    NSString *changeString = [_contentField.text trim];
    //这里已修改
    if ([changeString isEmptyOrNull]) {
        _contentField.text = @"";
        [_contentField animateShake];
        errorMsg = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"enter", nil),NSLocalizedString(@"nickname", nil)];
        return errorMsg;
    }
    
    return errorMsg;
}

@end




// ------------------------------------  //

@implementation ADLSexSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    NSArray *titles = @[NSLocalizedString(@"male", nil),NSLocalizedString(@"female", nil)];
    
    float w = GetScaleWidth(80);
    float space = GetScaleWidth(30);
    
    for(int i=0; i<titles.count; i++) {
        
        NSString *imagName = i ? @"ico_my_unselect" : @"ico_my_select";
        float x = i == 0 ? (kScreenWidth / 2.0 - w - 2 * space) : (kScreenWidth / 2.0 + space);
        ADLFilterSelectItem *item = [[ADLFilterSelectItem alloc] initWithFrame:CGRectMake(x, (GetScaleWidth(44) - GetScaleWidth(30)) / 2.0, w, GetScaleWidth(30)) img:imagName title:titles[i]];
        item.tag = 10000 + i;
        [item addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
}

- (void)refreshIndex:(NSInteger)index {
    
    NSArray *subViews = self.subviews;
    for (ADLFilterSelectItem *item in subViews) {
        item.selectImgView.image = IMAGE(@"ico_my_unselect");
        
        if (item.tag == (10000 + index)) {
            item.selectImgView.image = IMAGE(@"ico_my_select");
        }
    }
}


- (void)action:(ADLFilterSelectItem *)item {
    
    NSArray *subs = self.subviews;
    for (ADLFilterSelectItem *subItem in subs) {
        subItem.selectImgView.image = IMAGE(@"ico_my_unselect");
    }
    item.selectImgView.image = IMAGE(@"ico_my_select");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sexSelectView:index:)]) {
        [self.delegate sexSelectView:self index:(item.tag - 10000)];
    }
}
@end


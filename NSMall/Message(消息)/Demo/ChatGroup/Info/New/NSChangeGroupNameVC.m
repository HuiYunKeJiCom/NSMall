//
//  NSChangeGroupNameVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/9/17.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSChangeGroupNameVC.h"
#import "UIView+animation.h"
#import "UpdateUserParam.h"
#import "UserInfoAPI.h"
#import "ADOrderTopToolView.h"
#import "NSGroupAPI.h"


@interface NSChangeGroupNameVC ()

@property (nonatomic, strong) UITextField         *contentField;

@property (nonatomic, strong) UIButton            *commitButton;
@property (nonatomic, strong) UILabel             *errorLabel;

@property (nonatomic, assign) EditUserType        type;

@end

@implementation NSChangeGroupNameVC

- (instancetype)initEditType:(EditUserType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"NSChangeParam");
    [self setUpNavTopView];
    self.view.backgroundColor = KColorTextFFFFFF;
    
    [self.view addSubview:self.contentField];
    [self.view addSubview:self.commitButton];
    [self.view addSubview:self.errorLabel];
    
    //这里已修改
    //    UserModel *userModel = [UserModel modelFromUnarchive];
    
    self.contentField.hidden = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    [self makeConstraints];
    
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"modify", nil),_editTitle]];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        //        [weakSelf.navigationController popViewControllerAnimated:YES];
        if (weakSelf.stringBlock) {
            weakSelf.stringBlock(_contentField.text);
        }
        [weakSelf back];
    };
    
    [self.view addSubview:topToolView];
    
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
    
    //    self.title = [NSString stringWithFormat:@"%@ %@",KLocalizableStr(@"修改"),_editTitle];
    
    self.contentField.placeholder = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"enter", nil),_editTitle];
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
        [_commitButton setTitle:NSLocalizedString(@"confirm", nil) forState:UIControlStateNormal];
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

#pragma mark - action

- (void)actionCommit:(UIButton *)button {
    NSString *errorMsg = [self validateInput];
    
    if (errorMsg.length > 0) {
        
        _errorLabel.text = errorMsg;
        return;
    }
    
    [self.view endEditing:YES];
    if (self.stringBlock) {
        self.stringBlock(_contentField.text);
    }
    WEAKSELF
    //提交编辑后的群组信息
//    bool bool_true = true;
//    bool bool_false = false;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.groupModel.group_id forKey:@"groupId"];
    [param setValue:self.contentField.text forKey:@"groupName"];
//    [param setValue:self.groupModel.group_name_json forKey:@"groupNameJson"];

    
    [NSGroupAPI updateGroupWithParam:param success:^(NSDictionary *groupId) {
        DLog(@"群组信息更新成功");
        [Common AppShowToast:@"群组信息更新成功"];
        [weakSelf back];
    } faulre:^(NSError *error) {
        DLog(@"群组信息更新失败");
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

- (NSString *)validateInput
{
    NSString *errorMsg = @"";
    NSString *changeString = [_contentField.text trim];
    //这里已修改
    if ([changeString isEmptyOrNull]) {
        _contentField.text = @"";
        [_contentField animateShake];
        errorMsg = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"enter", nil),_editTitle];
        return errorMsg;
    }
    
    return errorMsg;
}



@end

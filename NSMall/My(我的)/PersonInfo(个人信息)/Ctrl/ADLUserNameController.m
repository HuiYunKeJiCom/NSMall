
//
//  ADLUserNameController.m
//  Lock
//
//  Created by apple on 2017/10/28.
//  Copyright © 2017年 朱鹏. All rights reserved.
//  实名认证

#import "ADLUserNameController.h"

@interface ADLUserNameController ()

@property (nonatomic, strong) UITextField         *contentField;
@property (nonatomic, strong) UIButton            *commitButton;

@end

@implementation ADLUserNameController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KColorTextFFFFFF;
    
    
    [self.view addSubview:self.contentField];
    [self.view addSubview:self.commitButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    [self makeConstraints];
    
}



- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma mark - setter / getter

- (void)setEditTitle:(NSString *)editTitle {
    _editTitle = editTitle;
    
    self.title = [NSString stringWithFormat:@"%@ %@",KLocalizableStr(@"修改"),_editTitle];
    
    self.contentField.placeholder = [NSString stringWithFormat:@"%@ %@",KLocalizableStr(@"请输入"),_editTitle];
}




- (UITextField *)contentField {
    if (!_contentField) {
        _contentField = [[UITextField alloc] initWithFrame:CGRectZero];
        _contentField.font = kFontSize13;
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
        [_commitButton setTitle:KLocalizableStr(@"保存") forState:UIControlStateNormal];
        [_commitButton setTitleColor:KColorTextFFFFFF forState:UIControlStateNormal];
        _commitButton.titleLabel.font = kFontSize15;
        _commitButton.backgroundColor = KMainColor;
        _commitButton.layer.cornerRadius = GetScaleWidth(20);
        _commitButton.layer.masksToBounds = YES;
        [_commitButton addTarget:self action:@selector(actionCommit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}


#pragma mark - makeConstraints

- (void)makeConstraints {
    
    WEAKSELF
    
    [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(GetScaleWidth(16));
        make.right.equalTo(weakSelf.view.mas_right).with.offset(GetScaleWidth(-16));
        make.top.equalTo(weakSelf.view).with.offset(GetScaleWidth(60+64));
        make.height.mas_equalTo(GetScaleWidth(40));
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.width.height.mas_equalTo(weakSelf.contentField);
        make.top.mas_equalTo(weakSelf.contentField.mas_bottom).offset(GetScaleWidth(30));
    }];
    
}

-(void)actionCommit {
    
    if (self.contentField.text.length ==0) {
        
        [MBProgressHUD showSuccess:@"请输入用户名"];
        
    } else {
        
        //这里需要修改
//        NSMutableDictionary * param = [NSMutableDictionary dictionary];
//
//        ADLUserModel *userModel = [[ADLGlobalHandleModel sharedInstance] readCurrentUser];
//        NSString *memberId = [NSString limitStringNotEmpty:userModel.idx];
//        NSLog(@"memberId = %@",memberId);
//        if (memberId.length>0) {
//
//            param[@"memberId"] = memberId;
//
//        } else {
//
//            param[@"memberId"] = @"";
//        }
//
//        NSString * olduserName = [ADLGlobalHandleModel sharedInstance].CurrentUser.userName;
//        NSLog(@"olduserName = %@",olduserName);
//        if (olduserName.length>0) {
//
//            param[@"olduserName"] = olduserName;
//
//        } else {
//
//            param[@"olduserName"] = @"";
//        }
//
//        param[@"newuserName"] = self.contentField.text;
//        NSLog(@"newuserName = %@",param[@"newuserName"]);
//        WEAKSELF
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//        [NetWork modifyUserName:[NSDictionary dictionaryWithObject:[self dictionaryToJson:param] forKey:@"params"] success:^(NSDictionary *result) {
//            NSLog(@"修改用户名返回结果 = %@",result);
//            [hud hide:YES afterDelay:1];
//
//            if ([result[@"status"] integerValue] == 10000 ) {
//
//
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//                /*保存当前用户*/
//                ADLUserModel *userModel = [ADLGlobalHandleModel sharedInstance].CurrentUser;
//                userModel.userName = self.contentField.text;
//                [ADLGlobalHandleModel sharedInstance].CurrentUser = userModel;
//            }
//
//        } failure:^(NSError *error) {
//
//            [hud hide:YES afterDelay:1];
//            [MBProgressHUD showError:@"提交失败"];
//        }];
        
    }
    
}

-(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString * string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return string;
    
}

@end

//
//  ADLUpdateUserInformCtrl.m
//  Lock
//
//  Created by occ on 2017/5/19.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ADLUpdateUserInformCtrl.h"
#import "ADLUpdateUserTableCell.h"
#import "ADLUpdateUserPhotoCell.h"
#import "ADLEditUserInformCtrl.h"

//#import "ADLFixUserNameController.h"
//#import "ADLUserNameController.h"
#import "ADOrderTopToolView.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+wrapper.h"
#import "ADLChangePhoneViewController.h"
#import "UserInfoAPI.h"

#import "TDUserCertifyViewCtrl.h"
#import "ADReceivingAddressViewController.h"


@interface ADLUpdateUserInformCtrl ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) BaseTableView            *userTable;
@property (nonatomic, strong) NSArray                  *dataSources;
@property (nonatomic, strong) NSIndexPath              *selectIndexPath;
@property (nonatomic, strong) UserModel              *userModel;
@property(nonatomic,strong)UIButton *outBtn;/* 登出按钮 */
@end

@implementation ADLUpdateUserInformCtrl

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.userModel = [UserModel modelFromUnarchive];
    [self.userTable reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = KLocalizableStr(@"修改个人信息");
    self.view.backgroundColor = UIColorFromRGB(0xf4f5f9);
    self.dataSources = @[@[KLocalizableStr(@"头像"),
                           KLocalizableStr(@"收货地址"),
                           KLocalizableStr(@"昵称"),
                           KLocalizableStr(@"性别"),
                           KLocalizableStr(@"手机号"),
                           KLocalizableStr(@"实名认证")]];
    
    [self.view addSubview:self.userTable];
    [self.view addSubview:self.outBtn];
    
    [self setUpNavTopView];
    [self makeConstraints];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,  TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"个人信息")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        //        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    [self.view bringSubviewToFront:topToolView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setter / getter

- (BaseTableView *)userTable {
    if (!_userTable) {
        _userTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _userTable.delegate = self;
        _userTable.dataSource = self;
    }
    return _userTable;
}

-(UIButton *)outBtn{
    if (!_outBtn) {
        _outBtn = [[UIButton alloc]init];
        [_outBtn setTitleColor:kWhiteColor forState:0];
        _outBtn.titleLabel.font = UISystemFontSize(14);
        _outBtn.backgroundColor = KMainColor;
        [_outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_outBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
        
        _outBtn.layer.cornerRadius = 10.0;//2.0是圆角的弧度，根据需求自己更改
        [_outBtn.layer setMasksToBounds:YES];
//        _outBtn.layer.borderColor = KMainColor;//设置边框颜色
//        _outBtn.layer.borderWidth = 1.0f;//设置边框颜色
    }
    return _outBtn;
}

#pragma mark - makeConstraints

- (void)makeConstraints {
    
    WEAKSELF
    [self.userTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
        
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-200);
    }];
    
    [self.outBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(kScreenWidth*0.15);
        make.top.equalTo(self.userTable.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.7, 50));
    }];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *subArr = self.dataSources[section];
    return subArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return GetScaleWidth(89);
    }
    return GetScaleWidth(48);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if(section == 1 || section == 2){
//        return GetScaleWidth(10);
//    }else{
        return GetScaleWidth(1);
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(10))];
    headV.backgroundColor = VCBackgroundColor;
    return headV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        ADLUpdateUserPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADLUpdateUserPhotoCell"];
        if (!cell) {
            cell = [[ADLUpdateUserPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ADLUpdateUserPhotoCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(self.dataSources.count > indexPath.section) {
            NSArray *subArr = self.dataSources[indexPath.section];
            cell.titleLb.text = subArr[indexPath.row];
            
            NSString *pictureUrl = @"";
            if ([self.userModel.pic_img hasPrefix:@"http"]) {
                pictureUrl = self.userModel.pic_img;
            } else {
                pictureUrl = Image_Url(self.userModel.pic_img);
            }

            NSURL *imageurl = [NSURL URLWithString:pictureUrl];
            [cell.photoImgView sd_setImageWithURL:imageurl placeholderImage:IMAGE(@"my_ico_head")];
        }
        return cell;
    }
    
    
    ADLUpdateUserTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADLUpdateUserTableCell"];
    if (!cell) {
        cell = [[ADLUpdateUserTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ADLUpdateUserTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(self.dataSources.count > indexPath.section) {
        NSArray *subArr = self.dataSources[indexPath.section];
        [self handleUserCell:cell title:subArr[indexPath.row]];
        
        cell.arrowImgView.hidden = NO;
//        if (indexPath.row == 0) {
//            cell.arrowImgView.hidden = YES;
//        }
        
        if (subArr.count == (indexPath.row + 1)) {
            cell.lineView.hidden = YES;
        } else {
            cell.lineView.hidden = NO;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectIndexPath = indexPath;
    
    if (self.dataSources.count > indexPath.section) {
        NSArray *subArr = self.dataSources[indexPath.section];
        if (subArr.count > indexPath.row) {
            NSString *title = subArr[indexPath.row];
            
            if ([title isEqualToString:KLocalizableStr(@"头像")]) {
                [self takePhoto];
                
            } else {
                EditUserType type = [self getEditType:title];
                if (type == EditUserTypePhone) {
                    
                    ADLChangePhoneViewController *ctrl = [[ADLChangePhoneViewController alloc] init];
                    ctrl.editTitle = title;
                    [self.navigationController pushViewController:ctrl animated:YES];
                    
                } else if (type == EditUserTypeAddress) {
                    //收货地址
                    ADReceivingAddressViewController *addressCtrl = [[ADReceivingAddressViewController alloc] init];
                    [self.navigationController pushViewController:addressCtrl animated:YES];
                }else if (type == EditUserTypeCertification) {
//                    [self.navigationController setNavigationBarHidden:NO];
                    TDUserCertifyViewCtrl *ctrl = [[TDUserCertifyViewCtrl alloc] init];
//                    ctrl.editTitle = title;
                    [self.navigationController pushViewController:ctrl animated:YES];
                } else {
                    
                    ADLEditUserInformCtrl *ctrl = [[ADLEditUserInformCtrl alloc] initEditType:type];
                    ctrl.editTitle = title;
                    [self.navigationController pushViewController:ctrl animated:YES];
                }
            }
        }
    }
}

- (EditUserType)getEditType:(NSString *)title {
    EditUserType type = 0;
    
    if ([title isEqualToString:KLocalizableStr(@"昵称")]) {
        type = EditUserTypeNickName;
        
    } else if ([title isEqualToString:KLocalizableStr(@"收货地址")]) {
        type = EditUserTypeAddress;
        
    } else if ([title isEqualToString:KLocalizableStr(@"性别")]) {
        type = EditUserTypeGender;
        
    } else if ([title isEqualToString:KLocalizableStr(@"手机号")]) {
        type = EditUserTypePhone;
        
    } else if ([title isEqualToString:KLocalizableStr(@"实名认证")]) {
        type = EditUserTypeCertification;
    }
    
    return type;
}


- (void)handleUserCell:(ADLUpdateUserTableCell *)cell title:(NSString *)title {
//    ADReceivingAddressViewController
    cell.titleLb.text = title;
    //这里已修改
    if ([title isEqualToString:KLocalizableStr(@"昵称")]) {
        cell.descLabel.text = [NSString limitStringNotEmpty:[self.userModel.user_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    }  else if ([title isEqualToString:KLocalizableStr(@"性别")]) {
        cell.descLabel.text = self.userModel.sex == 0 ? KLocalizableStr(@"保密") : self.userModel.sex == 1 ? KLocalizableStr(@"男") : KLocalizableStr(@"女");

    } else if ([title isEqualToString:KLocalizableStr(@"手机号")]) {
        cell.descLabel.text = [NSString limitStringNotEmpty:self.userModel.telephone];

    } else if ([title isEqualToString:KLocalizableStr(@"实名认证")]) {
        //这里需要修改 已认证的需要修改
//        cell.descLabel.text = [NSString limitStringNotEmpty:self.userModel.mobile];
        cell.descLabel.text = [NSString limitStringNotEmpty:KLocalizableStr(@"未认证")];
    }
}



- (void)takePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusAuthorized) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:KLocalizableStr(@"取消") destructiveButtonTitle:nil otherButtonTitles:KLocalizableStr(@"拍照"), KLocalizableStr(@"从手机相册选择"), nil];
        [actionSheet showInView:self.view];
    } else if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KLocalizableStr(@"提示")
                                                        message:KLocalizableStr(@"请在设备的 设置-隐私-相机 中允许访问相机")
                                                       delegate:nil
                                              cancelButtonTitle:KLocalizableStr(@"确定")
                                              otherButtonTitles:nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:KLocalizableStr(@"取消") destructiveButtonTitle:nil otherButtonTitles:KLocalizableStr(@"拍照"), KLocalizableStr(@"从手机相册选择"), nil];
                [actionSheet showInView:self.view];
            } else {
            }
        }];
    }
}

#pragma mark -
#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:KMainColor];

    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16]} forState:UIControlStateNormal];
    
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 1:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark - image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *smallImage = [UIImage thumbnailWithImageWithoutScale:img withSize:CGSizeMake(100,100)];
        [self performSelector:@selector(saveImage:) withObject:smallImage afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image
{
    WEAKSELF
    ADLUpdateUserPhotoCell *cell = [self.userTable cellForRowAtIndexPath:self.selectIndexPath];
    cell.photoImgView.image = image;
    
    //这里已修改
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:image forKey:@"pic"];
    [param setObject:@"header" forKey:@"imageName"];
    
    [UserInfoAPI uploadHeaderWithParam:param success:^(NSString *path) {
        NSLog(@"头像上传成功");
        UserModel *userModel = [UserModel modelFromUnarchive];
        userModel.pic_img = path;
        [userModel archive];
        [weakSelf.userTable reloadData];
    } faulre:^(NSError *error) {
        NSLog(@"头像上传失败");
    }];
}

-(void)loginOut{
    [UserInfoAPI loginOut:nil success:^(NSDictionary * _Nullable result) {
        [Common AppShowToast:@"登出成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"appToken"];
            [kAppDelegate comeBackToRootVC];
            [kAppDelegate goToLoginPage];
        });
        
    } failure:^(NSError *error) {
        
    }];
}

@end


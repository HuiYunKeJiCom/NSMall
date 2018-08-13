//
//  NSUserCertifyVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSUserCertifyVC.h"
#import "ADOrderTopToolView.h"
#import "NSUploadImageView.h"
#import "UserInfoAPI.h"
#import "UIView+Layout.h"

@interface NSUserCertifyVC ()<UIScrollViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@property(nonatomic,strong)UIScrollView *SV;/* 全局SV */
@property(nonatomic,strong)UITextField *nameTF;/* 姓名TF */
@property(nonatomic,strong)UIView *nameL;/* 下划线 */
@property(nonatomic,strong)UITextField *identityTF;/* 身份证TF */
@property(nonatomic,strong)UIView *identityL;/* 下划线 */
@property(nonatomic,strong)UIView *buttonV;/* 按钮View */
@property(nonatomic,strong)UIButton *confirmBtn;/* 确认按钮 */
@property(nonatomic,strong)NSMutableDictionary *imageDict;/* 图片字典 */
@property(nonatomic,strong)NSMutableDictionary *imageStringDict;/* 图片路径字典 */
@property(nonatomic,strong)NSUploadImageView *frontV;/* 正面 */
@property(nonatomic,strong)NSUploadImageView *backV;/* 反面 */
@property(nonatomic,strong)NSUploadImageView *holdV;/* 手持 */
@end

@implementation NSUserCertifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kWhiteColor;
    [self buildUI];
    [self setUpNavTopView];
    [self makeConstraints];
}

-(void)buildUI{
    self.imageDict = [NSMutableDictionary dictionary];
    self.imageStringDict = [NSMutableDictionary dictionary];
    [self.view addSubview:self.SV];
    [self.SV addSubview:self.nameTF];
    [self.SV addSubview:self.nameL];
    [self.SV addSubview:self.identityTF];
    [self.SV addSubview:self.identityL];
    [self.SV addSubview:self.frontV];
    [self.SV addSubview:self.backV];
    [self.SV addSubview:self.holdV];
    [self.view addSubview:self.buttonV];
    [self.view addSubview:self.confirmBtn];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    //    [self.navigationController setNavigationBarHidden:YES];
    ADOrderTopToolView *navView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    navView.backgroundColor = kWhiteColor;
    [navView setTopTitleWithNSString:@"实名认证"];
    WEAKSELF
    navView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //        [self delayPop];
    };
    [self.view addSubview:navView];
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.SV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(TopBarHeight+1);
        make.height.mas_equalTo(kScreenHeight-TopBarHeight);
    }];
    
//    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.SV.mas_left).with.offset(20);
//        make.right.equalTo(weakSelf.SV.mas_right);
//        make.top.equalTo(weakSelf.SV.mas_top).with.offset(20);
//        make.height.mas_equalTo(30);
//    }];
//
//    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.nameTF.mas_left);
//        make.top.equalTo(weakSelf.nameTF.mas_bottom);
//        make.width.mas_equalTo(kScreenWidth-40);
//        make.height.mas_equalTo(1);
//    }];
//
//    [self.identityTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.SV.mas_left).with.offset(20);
//        make.right.equalTo(weakSelf.SV.mas_right);
//        make.top.equalTo(weakSelf.nameTF.mas_bottom).with.offset(20);
//        make.height.mas_equalTo(30);
//    }];
//
//    [self.identityL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.identityTF.mas_left);
//        make.top.equalTo(weakSelf.identityTF.mas_bottom);
//        make.width.mas_equalTo(kScreenWidth-40);
//        make.height.mas_equalTo(1);
//    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.SV.mas_left).with.offset(20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-15);
        make.width.mas_equalTo(kScreenWidth-40);
        make.height.mas_equalTo(40);
    }];
    
    [self.frontV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.SV.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.identityTF.mas_bottom).with.offset(20);
        make.width.mas_equalTo(kScreenWidth-40);
        make.height.mas_equalTo(200);
    }];
    
    [self.backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.SV.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.frontV.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kScreenWidth-40);
        make.height.mas_equalTo(200);
    }];
    
    [self.holdV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.SV.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.backV.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kScreenWidth-40);
        make.height.mas_equalTo(200);
    }];
    
}


- (UIScrollView *)SV {
    if (!_SV) {
        _SV = [[UIScrollView alloc]initWithFrame:CGRectZero];
        //        _SV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //        _imageViewScrollView.backgroundColor = [UIColor redColor];
        _SV.showsVerticalScrollIndicator = NO;
        _SV.showsHorizontalScrollIndicator = NO;
        _SV.delegate = self;
        _SV.contentSize = CGSizeMake(0, kScreenHeight+70);
        //        _SV.directionalLockEnabled = YES;
        //        _SV.pagingEnabled = YES;
    }
    return _SV;
}

- (UITextField *)nameTF {
    if (!_nameTF) {
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 30)];
        _nameTF.font = [UIFont systemFontOfSize:14];
        _nameTF.delegate = self;
//        _nameTF.backgroundColor = kRedColor;
//        _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _nameTF.placeholder = @"姓名";
        _nameTF.textColor = [UIColor blackColor];
//        _nameTF.backgroundColor = [UIColor whiteColor];
        
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30) FontSize:14];
        nameLab.text = @"姓名";
        nameLab.textColor = [UIColor grayColor];
        [paddingView addSubview:nameLab];
        _nameTF.leftView = paddingView;
        _nameTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _nameTF;
}

- (UIView *)nameL {
    if (!_nameL) {
        _nameL = [[UIView alloc] initWithFrame:CGRectMake(20, 49, kScreenWidth-40, 1)];
        _nameL.backgroundColor = KMainColor;
    }
    return _nameL;
}

- (UITextField *)identityTF {
    if (!_identityTF) {
        _identityTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 70, kScreenWidth-40, 30)];
        _identityTF.font = [UIFont systemFontOfSize:14];
        _identityTF.delegate = self;
//        _identityTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        _nameTF.placeholder = @"姓名";
        _identityTF.textColor = [UIColor blackColor];
        //        _nameTF.backgroundColor = [UIColor whiteColor];
        
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30) FontSize:14];
        nameLab.text = @"身份证";
        nameLab.textColor = [UIColor grayColor];
        [paddingView addSubview:nameLab];
        _identityTF.leftView = paddingView;
        _identityTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _identityTF;
}

- (UIView *)identityL {
    if (!_identityL) {
        _identityL = [[UIView alloc] initWithFrame:CGRectMake(20, 99, kScreenWidth-40, 1)];
        _identityL.backgroundColor = KMainColor;
    }
    return _identityL;
}

- (UIView *)buttonV {
    if (!_buttonV) {
        _buttonV = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-70, kScreenWidth, 70)];
        _buttonV.backgroundColor = kWhiteColor;
    }
    return _buttonV;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:kFontNum14];
        [_confirmBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = KMainColor;
        [_confirmBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 5;
        _confirmBtn.layer.masksToBounds = YES;
        [_confirmBtn addTarget:self action:@selector(confirmSubmit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

-(NSUploadImageView *)frontV{
    if (!_frontV) {
        _frontV = [[NSUploadImageView alloc]initWithFrame:CGRectZero];
        [_frontV setUpWith:@"身份证正面" andImageName:@"certify_icon_demo2"];
        WEAKSELF
        _frontV.addBtnClickBlock = ^{
            [weakSelf uploadImageWith:@"frontImage"];
        };
    }
    return _frontV;
}

-(NSUploadImageView *)backV{
    if (!_backV) {
        _backV = [[NSUploadImageView alloc]initWithFrame:CGRectZero];
        [_backV setUpWith:@"身份证反面" andImageName:@"certify_icon_demo1"];
        WEAKSELF
        _backV.addBtnClickBlock = ^{
            [weakSelf uploadImageWith:@"backImage"];
        };
    }
    return _backV;
}

-(NSUploadImageView *)holdV{
    if (!_holdV) {
        _holdV = [[NSUploadImageView alloc]initWithFrame:CGRectZero];
        [_holdV setUpWith:@"手持身份证" andImageName:@"certify_icon_demo"];
        WEAKSELF
        _holdV.addBtnClickBlock = ^{
            [weakSelf uploadImageWith:@"handheldImage"];
        };
    }
    return _holdV;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];// 使当前文本框失去第一响应者的特权，就会回收键盘了
    return YES;
}

-(void)uploadImageWith:(NSString *)string{
    
    [self pushTZImagePickerController:string];
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"take photo", nil),NSLocalizedString(@"photo album selection", nil), nil];
//    [sheet showInView:self.view];
    
//    NSMutableDictionary *holdParam = [NSMutableDictionary dictionary];
//    [holdParam setObject:self.realNameModel.imageHold forKey:@"pic"];
//    [holdParam setObject:@"hold" forKey:@"imageName"];
//    [UserInfoAPI uploadIDCardWithParam:holdParam success:^(NSString *path) {
//
//    } faulre:^(NSError *error) {
//
//    }];
}

#pragma mark - UIActionSheetDelegate

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) { // take photo / 去拍照
//        [self takePhoto];
//    } else if (buttonIndex == 1) {
//        [self pushTZImagePickerController];
//    }
//}

#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController:(NSString *)string {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    
    // 2. 在这里设置imagePickerVc的外观
    if (iOS7Later) {
        imagePickerVc.navigationBar.barTintColor = KMainColor;
    }
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    imagePickerVc.oKButtonTitleColorNormal = KMainColor;
    imagePickerVc.navigationBar.translucent = NO;
    
    imagePickerVc.autoDismiss = YES;
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    //    DLog(@"widthHeight = %d",widthHeight);
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 设置横屏下的裁剪尺寸
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [self.imageDict setObject:photos[0] forKey:string];

        NSMutableDictionary *holdParam = [NSMutableDictionary dictionary];
        [holdParam setObject:photos[0] forKey:@"pic"];
        [holdParam setObject:@"hold" forKey:@"imageName"];

        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        
        [UserInfoAPI uploadIDCardWithParam:holdParam success:^(NSString *path) {
            DLog(@"上传成功");
            [self.imageStringDict setObject:path forKey:string];
            dispatch_group_leave(group);
        } faulre:^(NSError *error) {
        }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if([string isEqualToString:@"frontImage"]){
            self.frontV.uploadImage.image = photos[0];
            self.frontV.addIV.alpha = 0.0;
            self.frontV.tipLab.alpha = 0.0;
        }else if([string isEqualToString:@"backImage"]){
            self.backV.uploadImage.image = photos[0];
            self.backV.addIV.alpha = 0.0;
            self.backV.tipLab.alpha = 0.0;
        }else if([string isEqualToString:@"handheldImage"]){
            self.holdV.uploadImage.image = photos[0];
            self.holdV.addIV.alpha = 0.0;
            self.holdV.tipLab.alpha = 0.0;
        }
    });
    }];

    [self presentViewController:imagePickerVc animated:YES completion:nil];
        
}


#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"unable use camera", nil) message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"setting", nil), nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"unable use camera", nil) message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"unable access album", nil) message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"setting", nil), nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"unable access album", nil) message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        //                        if ( 1) { // 允许裁剪,去裁剪
                        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                            [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                        }];
                        imagePicker.needCircleCrop = NO;
                        imagePicker.circleCropRadius = 100;
                        [self presentViewController:imagePicker animated:YES completion:nil];
                        //                        } else {
                        //                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        //                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
}

//选择完成
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [_selectedPhotos addObject:photos[0]];
    [_selectedAssets addObject:assets[0]];
}

// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    return YES;
}

// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    return YES;
}

-(void)confirmSubmit{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.nameTF.text forKey:@"realName"];
    [param setObject:self.identityTF.text forKey:@"idcard"];
    if([self.imageStringDict allKeys].count == 3){
        [param setObject:[self.imageStringDict objectForKey:@"frontImage"] forKey:@"frontImage"];
        [param setObject:[self.imageStringDict objectForKey:@"backImage"]  forKey:@"backImage"];
        [param setObject:[self.imageStringDict objectForKey:@"handheldImage"]  forKey:@"handheldImage"];
        WEAKSELF
        [UserInfoAPI certificationWithParam:param success:^(NSString *message){
            NSLog(@"认证信息上传成功");
            [weakSelf delayPop];
        } faulre:^(NSError *error) {
            NSLog(@"认证信息上传失败");
        }];
    }
    
    
}

- (void)delayPop {
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}

@end

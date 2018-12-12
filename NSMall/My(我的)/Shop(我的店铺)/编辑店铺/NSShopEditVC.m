//
//  NSShopEditVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/16.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSShopEditVC.h"
#import "ADOrderTopToolView.h"
#import "NSShopTableView.h"
#import "ADLMyInfoModel.h"
#import "TZTestCell.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UITextView+ZWPlaceHolder.h"
//#import "NSChangePhoneVC.h"
#import "NSAddressVC.h"
#import "NSAddLabelVC.h"//添加标签
#import "CLTagsModel.h"
#import "NSInfoCustomCell.h"
#import "GetLabelsAPI.h"
#import "GetLabelsParam.h"
#import "LabelItemModel.h"
#import "ShopPublishParam.h"
#import "NSShopPublishAPI.h"//需要修改
#import "NSChangeParamVC.h"
#import "BRPickerView.h"
#import "ShopAddressParam.h"

@interface NSShopEditVC ()<NSShopTableViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,NSAddLabelVCDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    
    NSMutableArray *_tagArrayM;
    NSMutableArray<LabelItemModel *> *_recentTagsM;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) NSShopTableView   *otherTableView;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property(nonatomic,strong)UIView *addView;/* 添加照片的按钮 */
@property(nonatomic,strong)UITextField *shopNameTF;/* 店铺名称 */
@property(nonatomic,strong)UITextView *detailTV;/* 描述内容 */
@property(nonatomic,strong)UIView *middleView;/* 中间的view */

@property(nonatomic,strong)UIScrollView *SV;/* 全局SV */
@property(nonatomic,strong)NSInfoCustomCell *infoCell;/* 标签Cell */

@property(nonatomic,strong)ShopPublishParam *param;/* 店铺发布参数 */
@property(nonatomic,strong)NSString *tagString;/* 店铺标签 */

@end

@implementation NSShopEditVC

-(void)viewWillAppear:(BOOL)animated{
    if(_selectedPhotos.count >0){
        if(_selectedPhotos.count>7){
            self.SV.scrollEnabled = YES;
        }else{
            self.SV.scrollEnabled = NO;
        }
        self.addView.alpha = 0.0;
        self.collectionView.alpha = 1.0;
        self.collectionView.height = (_selectedPhotos.count + 4)/4 *(_itemWH + _margin*2);
        self.middleView.dc_y = CGRectGetMaxY(self.collectionView.frame)+GetScaleWidth(9);
        self.otherTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
    }else{
        self.SV.scrollEnabled = NO;
        self.addView.alpha = 1.0;
        self.collectionView.alpha = 0.0;
        self.middleView.dc_y = GetScaleWidth(109);
        self.otherTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
    }
    
    if (!_tagArrayM) {
        _tagArrayM = [NSMutableArray array];
    }
    
    if (!_recentTagsM) {
        _recentTagsM = [NSMutableArray array];
    }
    [self getTag];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)createUI{
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    self.param = [ShopPublishParam new];
    
    self.SV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopBarHeight, kScreenWidth, kScreenHeight-TopBarHeight-TabBarHeight)];
    self.SV.scrollEnabled = NO;
    self.SV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    self.SV.backgroundColor = KBGCOLOR;
    [self.view addSubview:self.SV];
    
    self.otherTableView = [[NSShopTableView alloc] initWithFrame:CGRectMake(0, GetScaleWidth(150+5+130), kScreenWidth, GetScaleWidth(215)) style:UITableViewStyleGrouped];
    self.otherTableView.backgroundColor = [UIColor clearColor];
    self.otherTableView.bounces = NO;
    self.otherTableView.tbDelegate = self;
    self.otherTableView.isRefresh = NO;
    self.otherTableView.isLoadMore = NO;
    if (@available(iOS 11.0, *)) {
        self.otherTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.SV addSubview:self.otherTableView];
    [self setUpBase];
//    [self setUpData];
    [self configCollectionView];
    
    self.middleView = [[UIView alloc]initWithFrame:CGRectMake(0, GetScaleWidth(109), kScreenWidth, GetScaleWidth(30+10+110))];
    self.middleView.backgroundColor = [UIColor whiteColor];
    [self.SV addSubview:self.middleView];
    
    self.shopNameTF = [[UITextField alloc] initWithFrame:CGRectZero];
    self.shopNameTF.frame = CGRectMake(0, 0, kScreenWidth, GetScaleWidth(30));
    self.shopNameTF.font = [UIFont systemFontOfSize:14];
    self.shopNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.shopNameTF.textColor = [UIColor lightGrayColor];
    self.shopNameTF.backgroundColor = kWhiteColor;
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, GetScaleWidth(30))];
    self.shopNameTF.leftView = paddingView;
    self.shopNameTF.leftViewMode = UITextFieldViewModeAlways;
    [self.middleView addSubview:self.shopNameTF];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, GetScaleWidth(30), kScreenWidth, GetScaleWidth(10))];
    view.backgroundColor = kWhiteColor;
    [self.middleView addSubview:view];
    
    self.detailTV = [[UITextView alloc] initWithFrame:CGRectMake(0, GetScaleWidth(40), kScreenWidth, GetScaleWidth(110))];
    self.detailTV.textColor = [UIColor lightGrayColor];
    self.detailTV.backgroundColor = kWhiteColor;
    self.detailTV.font = [UIFont systemFontOfSize:14];
    self.detailTV.delegate = self;
    self.detailTV.zw_placeHolderColor = [UIColor lightGrayColor];
    
    self.detailTV.textContainerInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.middleView addSubview:self.detailTV];
    
    [self setUpAddView];
    [self setUpNavTopView];
    [self setUpBottomBtn];
    
}

-(void)getTag{
    
    for (ADLMyInfoModel *model in self.otherTableView.data) {
        if([model.title isEqualToString:@"标签"]){
            if(self.tagString){
                model.num = self.tagString;
            }
        }
    }
    
    [_recentTagsM removeAllObjects];
    GetLabelsParam *param = [GetLabelsParam new];
    param.type = @"1";
    [GetLabelsAPI getLabels:param success:^(LabelListModel * _Nullable result) {
        DLog(@"获取标签成功");
        [_recentTagsM addObjectsFromArray:result.labelList];
    } failure:^(NSError *error) {
        DLog(@"获取标签失败");
    }];
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = kWhiteColor;
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.SV addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 4 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    [self.collectionView setCollectionViewLayout:_layout];
    CGFloat collectionViewY = GetScaleWidth(0);
    self.collectionView.frame = CGRectMake(0, collectionViewY, self.view.tz_width, GetScaleWidth(100));
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        if(_selectedPhotos.count > indexPath.row){
            cell.imageView.image = _selectedPhotos[indexPath.row];
        }
        if(_selectedAssets.count > indexPath.row){
            cell.asset = _selectedAssets[indexPath.row];
        }
            cell.deleteBtn.hidden = NO;
    }
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        [self pushTZImagePickerController];
    } else {
        // preview photos or video / 预览照片或者视频
        if(_selectedAssets.count > indexPath.row){
            id asset = _selectedAssets[indexPath.row];
            BOOL isVideo = NO;
            if ([asset isKindOfClass:[PHAsset class]]) {
                PHAsset *phAsset = asset;
                isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
            } else if ([asset isKindOfClass:[ALAsset class]]) {
                ALAsset *alAsset = asset;
                isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
            }
        }
        
        // preview photos / 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.maxImagesCount = 9;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingMultipleVideo = NO;
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
            self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
            self->_isSelectOriginalPhoto = isSelectOriginalPhoto;
            [self->_collectionView reloadData];
            self->_collectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if(_selectedPhotos.count > sourceIndexPath.item){
        UIImage *image = _selectedPhotos[sourceIndexPath.item];
        [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
        [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    }
    
    if(_selectedAssets.count > sourceIndexPath.item){
        id asset = _selectedAssets[sourceIndexPath.item];
        [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
        [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    }
    
    [_collectionView reloadData];
}

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

- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
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
    imagePickerVc.allowCrop = YES;
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
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    [_collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
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

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    if(_selectedPhotos.count >0){
        if(_selectedPhotos.count>7){
            self.SV.scrollEnabled = YES;
        }else{
            self.SV.scrollEnabled = NO;
        }
        self.addView.alpha = 0.0;
        self.collectionView.alpha = 1.0;
        self.collectionView.height = (_selectedPhotos.count + 4)/4 *(_itemWH + _margin*2);
        self.middleView.dc_y = CGRectGetMaxY(self.collectionView.frame)+
        (9);
        self.otherTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
    }else{
        self.SV.scrollEnabled = NO;
        self.addView.alpha = 1.0;
        self.collectionView.alpha = 0.0;
        self.middleView.dc_y = GetScaleWidth(109);
        self.otherTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
    }
    // NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    //    cell.imageView.image = _selectedPhotos[indexPath.row];
    //    cell.asset = _selectedAssets[indexPath.row];
    
    
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    DLog(@"_selectedPhotos = %@",_selectedPhotos);
    DLog(@"_selectedAssets = %@",_selectedAssets);
    
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    
    [_collectionView reloadData];
    
    if(photos.count >0){
        if(_selectedPhotos.count>7){
            self.SV.scrollEnabled = YES;
        }else{
            self.SV.scrollEnabled = NO;
        }
        self.addView.alpha = 0.0;
        self.collectionView.alpha = 1.0;
        self.collectionView.height = (_selectedPhotos.count + 4)/4 *(_itemWH + _margin*2);
        self.middleView.dc_y = CGRectGetMaxY(self.collectionView.frame)+GetScaleWidth(9);
        self.otherTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
        
    }else{
        self.SV.scrollEnabled = NO;
        self.addView.alpha = 1.0;
        self.collectionView.alpha = 0.0;
        self.collectionView.height = GetScaleWidth(100);
        self.middleView.dc_y = GetScaleWidth(109);
        self.otherTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
    }
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}

// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    return YES;
}

// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    return YES;
}

// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        // NSLog(@"图片名字:%@",fileName);
    }
}

#pragma mark - 获取数据
- (void)getDataWithShopModel:(NSShopListItemModel *)shopModel
{
    _shopModel = shopModel;
    
    [self createUI];
    
    if (!_tagArrayM) {
        _tagArrayM = [NSMutableArray array];
    }
    
    NSString *labelID = @"";
    NSString *labelStr = @"";
    if(shopModel.labelList.count>0){
        for (LabelItemModel *tag in shopModel.labelList) {
            if (![_recentTagsM containsObject:tag]) {
                [_recentTagsM addObject:tag];
            }
            
            [_tagArrayM addObject:tag];

            labelStr = [[labelStr stringByAppendingString:tag.label_name] stringByAppendingString:@"、"];
            labelID = [[labelID stringByAppendingString:tag.label_id] stringByAppendingString:@","];
        }
        NSString *tagString = [self removeLastOneChar:labelStr];
        NSString *tagID = [self removeLastOneChar:labelID];
        
        self.tagString = tagString;
        self.param.labelId = tagID;
        self.infoCell.numLb.text = self.tagString;
    }else{
        self.infoCell.numLb.text = @"请选择标签";
    }
    
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"标签") imageName:nil num:self.tagString]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"地址") imageName:nil num:shopModel.address]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"电话") imageName:nil num:shopModel.user_phone]];
    
    NSArray *startArray = [shopModel.business_hours_start componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
    NSString *startString = [NSString stringWithFormat:@"%@:%@",startArray[0],startArray[1]];
    
    NSArray *endArray = [shopModel.business_hours_end componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
    NSString *endString = [NSString stringWithFormat:@"%@:%@",endArray[0],endArray[1]];
    
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"营业开始时间") imageName:nil num:startString]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"营业结束时间") imageName:nil num:endString]];
    
    self.param.businessHoursStart = startString;
    self.param.businessHoursEnd= endString;
    
    self.shopNameTF.text = shopModel.name;
    self.detailTV.text = shopModel.introduce;
    
    
    //    _selectedPhotos;
    //    _selectedAssets
    
 
    for (NSString *imageUrl in shopModel.storeImageList) {
        
            NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *image =  [UIImage imageWithData:data];
            [_selectedPhotos addObject:image];

        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
        }];
        
            PHFetchOptions*options = [[PHFetchOptions alloc]init];
            options.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"ascending:NO]];
            PHFetchResult*assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
            PHAsset *asset = [assetsFetchResults firstObject];
            DLog(@"asset = %@",asset);
            [_selectedAssets addObject:asset];
        
    }
    
        _margin = 4;
        _itemWH = (self.view.tz_width - 2 * _margin - 4) / 4 - _margin;
        
        [self.otherTableView reloadData];
        [self.collectionView reloadData];
        
        if(_selectedPhotos.count >0){
            if(_selectedPhotos.count>7){
                self.SV.scrollEnabled = YES;
            }else{
                self.SV.scrollEnabled = NO;
            }
            self.addView.alpha = 0.0;
            self.collectionView.alpha = 1.0;
            self.collectionView.height = (_selectedPhotos.count + 4)/4 *(_itemWH + _margin*2);
            self.middleView.dc_y = CGRectGetMaxY(self.collectionView.frame)+GetScaleWidth(9);
            self.otherTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
        }else{
            self.SV.scrollEnabled = NO;
            self.addView.alpha = 1.0;
            self.collectionView.alpha = 0.0;
            self.middleView.dc_y = GetScaleWidth(109);
            self.otherTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
        }
    
    
    
}

- (void)loadImageFinished:(UIImage *)image
{
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"success = %d, error = %@", success, error);
        
        if (success)
        {
            //成功后取相册中的图片对象
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                imageAsset = obj;
                *stop = YES;
                [_selectedAssets addObject:imageAsset];
            }];
            
            if (imageAsset)
            {
                //加载图片数据
                [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
                                                                  options:nil
                                                            resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                                
                                                                NSLog(@"imageData = %@", imageData);
                                                                
                                                            }];
            }
        }
        
    }];
}


#pragma mark - initialize
- (void)setUpBase {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.otherTableView.tableFooterView = [UIView new]; //去除多余分割线
}

#pragma mark - NSShopTableViewDelegate

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.section;
    
    switch (index) {
        case 0:{
            NSLog(@"点击了标签");
            
            self.infoCell = [self.otherTableView cellForRowAtIndexPath:indexPath];
            
            CLTagsModel *model = [[CLTagsModel alloc] init];
            model.title = @"所有标签";
            model.tagsArray = _recentTagsM.copy;
            
            NSAddLabelVC *tagVC = [[NSAddLabelVC alloc] init];
            tagVC.tagsDelegate = self;
            tagVC.tagsModelArray = @[model];  // 传入多个模型，显示多个标签组
            tagVC.tagsDisplayArray = _tagArrayM;
            tagVC.highlightTag = YES;
            [self.navigationController pushViewController:tagVC animated:YES];
            self.infoCell.numLb.text = @"";
        }
            break;
        case 1:{
            NSLog(@"点击了地址");
            NSAddressVC *ctrl = [[NSAddressVC alloc] init];
            ctrl.paramBlock = ^(ShopAddressParam *param) {
                for (ADLMyInfoModel *model in self.otherTableView.data) {
                    if([model.title isEqualToString:@"地址"]){
                        if(param){
                            model.num = [NSString stringWithFormat:@"%@",param.address];
                            self.param.address = param.address;
                            self.param.longitude = [NSString stringWithFormat:@"%f",param.location.longitude];
                            self.param.latitude = [NSString stringWithFormat:@"%f",param.location.latitude];
                        }else{
                            model.num = @"请输入地址";
                        }
                    }
                }
                [self.otherTableView reloadData];
            };
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
        case 2:{
            NSLog(@"点击了电话");
            //            NSChangePhoneVC *ctrl = [[NSChangePhoneVC alloc] init];
            //            ctrl.editTitle = KLocalizableStr(@"电话");
            //            [self.navigationController pushViewController:ctrl animated:YES];
            
            EditUserType type = [self getEditType:KLocalizableStr(@"电话")];
            
            NSChangeParamVC *ctrl = [[NSChangeParamVC alloc] initEditType:type];
            ctrl.editTitle = KLocalizableStr(@"电话");
            
            ctrl.stringBlock = ^(NSString *string) {
                for (ADLMyInfoModel *model in self.otherTableView.data) {
                    if([model.title isEqualToString:@"电话"]){
                        if(string){
                            model.num = [NSString stringWithFormat:@"%@",string];
                            self.param.mobile = string;
                        }else{
                            model.num = @"请输入电话";
                        }
                    }
                }
                [self.otherTableView reloadData];
            };
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
        case 3:{
            NSLog(@"点击了开始营业时间");
            
            NSDate *minDate = [NSDate br_setHour:1 minute:0];
            NSDate *maxDate = [NSDate br_setHour:23 minute:59];
            for (ADLMyInfoModel *model in self.otherTableView.data) {
                if([model.title isEqualToString:@"营业开始时间"]){
                    
                    [BRDatePickerView showDatePickerWithTitle:@"营业开始时间" dateType:BRDatePickerModeTime defaultSelValue:@"9:00" minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:KMainColor resultBlock:^(NSString *selectValue) {
                        model.num = selectValue;
                        self.param.businessHoursStart = selectValue;
                        [self.otherTableView reloadData];
                    }];
                }
            }
        }
            break;
        case 4:{
            
            NSLog(@"点击了结束营业时间");
            NSDate *minDate = [NSDate br_setHour:1 minute:0];
            NSDate *maxDate = [NSDate br_setHour:23 minute:59];
            for (ADLMyInfoModel *model in self.otherTableView.data) {
                if([model.title isEqualToString:@"营业结束时间"]){
                    [BRDatePickerView showDatePickerWithTitle:@"营业结束时间" dateType:BRDatePickerModeTime defaultSelValue:@"18:00" minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:KMainColor resultBlock:^(NSString *selectValue) {
                        model.num = selectValue;
                        self.param.businessHoursEnd = selectValue;
                        [self.otherTableView reloadData];
                    }];
                }
            }
        }
            break;
        default:
            break;
    }
    
}

-(void)setUpAddView{
    self.addView = [[UIView alloc] initWithFrame:CGRectMake(0, GetScaleWidth(1), kScreenWidth, GetScaleWidth(100))];
    self.addView.backgroundColor = kWhiteColor;
    [self.SV addSubview:self.addView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.addView.centerX- GetScaleWidth(16), GetScaleWidth(28), GetScaleWidth(33), GetScaleWidth(27));
    
    [btn setImage:[UIImage imageNamed:@"publish_ico_goods_picture"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.addView addSubview:btn];
    
    CGSize contentSize = [self contentSizeWithTitle:@"添加照片" andFont:14];
    
    UILabel *addPhotoLab=[[UILabel alloc] initWithFrame:CGRectMake(self.addView.centerX- contentSize.width*0.5, CGRectGetMaxY(btn.frame)+3, contentSize.width, contentSize.height)];
    [addPhotoLab setText:@"添加照片"];
    addPhotoLab.font = UISystemFontSize(14);
    addPhotoLab.textColor= [UIColor blackColor];
    [self.addView addSubview:addPhotoLab];
}

-(void)addPhoto:(UIButton *)button{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    [sheet showInView:self.view];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.hidden = NO;
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"编辑店铺")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf dismissModalStack];
    };
    
    [self.view addSubview:topToolView];
    
}

-(void)dismissModalStack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpBottomBtn{
    //发布按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = KMainColor;
    btn.frame = CGRectMake(0, kScreenHeight-TabBarHeight, kScreenWidth, TabBarHeight);
    [btn setTitle:@"保存编辑" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)publish:(UIButton *)btn{
    NSMutableArray *pathArr = [NSMutableArray array];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    for(int i=0;i<_selectedPhotos.count;i++){
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:_selectedPhotos[i] forKey:@"pic"];
        [param setObject:[NSString stringWithFormat:@"pic%d",i] forKey:@"imageName"];
        [NSShopPublishAPI uploadStorePicWithParam:param success:^(NSString *path) {
            [pathArr addObject:path];
            if(i==_selectedPhotos.count-1){
                self.param.imagePath = [pathArr componentsJoinedByString:@","];
                DLog(@"商品图片上传 = %lu",pathArr.count);
                
                dispatch_group_leave(group);
            }
        } faulre:^(NSError *error) {
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //请求完成后的处理、
        self.param.storeName = self.shopNameTF.text;
        self.param.introduce = self.detailTV.text;
        DLog(@"self.param = %@",self.param.mj_keyValues);
        [NSShopPublishAPI createShopWithParam:self.param success:^{
            DLog(@"店铺发布成功");
            [Common AppShowToast:@"店铺发布成功"];
            [self dismissModalStack];
        } faulre:^(NSError *error) {
            DLog(@"店铺发布失败");
        }];
    });
    
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
        if(_selectedPhotos.count >0){
            if(_selectedPhotos.count>7){
                self.SV.scrollEnabled = YES;
            }else{
                self.SV.scrollEnabled = NO;
            }
            self.addView.alpha = 0.0;
            self.collectionView.alpha = 1.0;
            self.collectionView.height = (_selectedPhotos.count + 4)/4 *(_itemWH + _margin*2);
            self.middleView.dc_y = CGRectGetMaxY(self.collectionView.frame)+GetScaleWidth(9);
            self.otherTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
        }else{
            self.SV.scrollEnabled = NO;
            self.addView.alpha = 1.0;
            self.collectionView.alpha = 0.0;
            self.middleView.dc_y = GetScaleWidth(109);
            self.otherTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

#pragma mark - CLTagViewControllerDelegate 返回贴上的标签，并做相关处理
- (void)tagViewController:(NSAddLabelVC *)tagController tags:(NSArray<LabelItemModel *> *)tags {
    
    _tagArrayM = [NSMutableArray array];
    [tagController.navigationController popViewControllerAnimated:YES];
    
    NSString *labelID = @"";
    
    if(tags.count>0){
        for (LabelItemModel *tag in tags) {
            if (![_recentTagsM containsObject:tag]) {
                [_recentTagsM addObject:tag];
            }
            
            [_tagArrayM addObject:tag];
            
            self.infoCell.numLb.text = [[self.infoCell.numLb.text stringByAppendingString:tag.label_name] stringByAppendingString:@"、"];
            labelID = [[labelID stringByAppendingString:tag.label_id] stringByAppendingString:@","];
        }
        NSString *tagString = [self removeLastOneChar:self.infoCell.numLb.text];
        NSString *tagID = [self removeLastOneChar:labelID];
        
        self.infoCell.numLb.text = tagString;
        self.tagString = tagString;
        self.param.labelId = tagID;
    }else{
        self.infoCell.numLb.text = @"请选择标签";
    }
    
    
    
}

-(NSString*) removeLastOneChar:(NSString*)origin
{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];// 去掉最后一个","
    }else{
        cutted = origin;
    }
    return cutted;
}

- (EditUserType)getEditType:(NSString *)title {
    EditUserType type = 0;
    
    if ([title isEqualToString:KLocalizableStr(@"电话")]) {
        type = EditUserTypePhone;
        
    }
    //     else if ([title isEqualToString:KLocalizableStr(@"数量")]) {
    //        type = EditUserTypeNumber;
    //
    //    } else if ([title isEqualToString:KLocalizableStr(@"运费")]) {
    //        type = EditUserTypeFee;
    //
    //    }
    
    return type;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];// 使当前文本框失去第一响应者的特权，就会回收键盘了
    return YES;
}

@end

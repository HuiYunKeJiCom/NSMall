//
//  NSGoodsPublishVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGoodsPublishVC.h"
#import "ADOrderTopToolView.h"
//#import "NSShopTableView.h"
#import "NSGoodsTableView.h"
#import "ADLMyInfoModel.h"
#import "TZTestCell.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UITextView+ZWPlaceHolder.h"
#import "NSChangeParamVC.h"
#import "NSCategoryVC.h"
#import "GoodsPublishAPI.h"
#import "GoodsPublishParam.h"
#import "NSSpecView.h"
#import "NSInfoCustomCell.h"
#import "ClipViewController.h"


@interface NSGoodsPublishVC ()<NSGoodsTableViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,ClipPhotoDelegate,UITextFieldDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) NSGoodsTableView   *upTableView;//分类
@property (strong, nonatomic) NSGoodsTableView   *midTableView;//库存和价格
@property (strong, nonatomic) NSGoodsTableView   *addSpecTableView;//添加商品规格
@property(nonatomic)BOOL hasSpec;//是否含规格
@property(nonatomic,strong)UIView *specTotalView;/* 规格页面 */
@property (strong, nonatomic) NSGoodsTableView   *otherTableView;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property(nonatomic,strong)UIView *addView;/* 添加照片的按钮 */
@property(nonatomic,strong)UITextField *goodsNameTF;/* 商品名称 */
@property(nonatomic,strong)UITextView *detailTV;/* 描述内容 */
@property(nonatomic,strong)UIView *middleView;/* 中间的view */

@property(nonatomic,strong)UIScrollView *SV;/* 全局SV */
@property(nonatomic,strong)GoodsPublishParam *param;/* 商品发布参数 */
@property(nonatomic,strong)NSMutableDictionary *dict;/* 改变高度的字典 */
@property(nonatomic,strong)NSMutableArray *specViewArr;/* 存放规格View */
@property(nonatomic)CGFloat specHeight;/* 规格View的高度 */
@end

@implementation NSGoodsPublishVC

-(void)viewWillAppear:(BOOL)animated{
    if(_selectedPhotos.count >0){
        self.addView.alpha = 0.0;
        self.collectionView.alpha = 1.0;
        self.collectionView.height = (_selectedPhotos.count + 4)/4 *(_itemWH + _margin*2);
        self.middleView.dc_y = CGRectGetMaxY(self.collectionView.frame)+GetScaleWidth(9);
        self.upTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
        [self tableViewFrameChange];

    }else{
        self.addView.alpha = 1.0;
        self.collectionView.alpha = 0.0;
        self.middleView.dc_y = GetScaleWidth(109);
        self.upTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
        [self tableViewFrameChange];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = KBGCOLOR;
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    self.param = [GoodsPublishParam new];
    self.hasSpec = NO;
    self.specHeight = 0;
    
    self.SV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopBarHeight, kScreenWidth, kScreenHeight-TopBarHeight-TabBarHeight)];
    self.SV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-20-TopBarHeight);
    self.SV.backgroundColor = KBGCOLOR;
    self.SV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.SV];
    
    self.middleView = [[UIView alloc]initWithFrame:CGRectMake(0, GetScaleWidth(109), kScreenWidth, GetScaleWidth(30+10+110))];
    self.middleView.backgroundColor = [UIColor whiteColor];
    [self.SV addSubview:self.middleView];
    
    self.goodsNameTF = [[UITextField alloc] initWithFrame:CGRectZero];
    self.goodsNameTF.frame = CGRectMake(0, 0, kScreenWidth, GetScaleWidth(30));
    self.goodsNameTF.font = [UIFont systemFontOfSize:14];
    self.goodsNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.goodsNameTF.delegate = self;
    self.goodsNameTF.placeholder = NSLocalizedString(@"goods relevant", nil);
    self.goodsNameTF.textColor = [UIColor lightGrayColor];
    self.goodsNameTF.backgroundColor = kWhiteColor;
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, GetScaleWidth(30))];
    self.goodsNameTF.leftView = paddingView;
    self.goodsNameTF.leftViewMode = UITextFieldViewModeAlways;
    [self.middleView addSubview:self.goodsNameTF];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, GetScaleWidth(30), kScreenWidth, GetScaleWidth(10))];
    view.backgroundColor = kWhiteColor;
    [self.middleView addSubview:view];
    
    self.detailTV = [[UITextView alloc] initWithFrame:CGRectMake(0, GetScaleWidth(40), kScreenWidth, GetScaleWidth(110))];
    self.detailTV.textColor = [UIColor lightGrayColor];
    self.detailTV.backgroundColor = kWhiteColor;
    self.detailTV.font = [UIFont systemFontOfSize:14];
    self.detailTV.delegate = self;
    self.detailTV.zw_placeHolder = NSLocalizedString(@"goods description", nil);
    self.detailTV.zw_placeHolderColor = [UIColor lightGrayColor];
    
    self.detailTV.textContainerInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.middleView addSubview:self.detailTV];
    
//    self.upTableView = [[NSGoodsTableView alloc] initWithFrame:CGRectMake(0, GetScaleWidth(319), kScreenWidth, GetScaleWidth(43)) style:UITableViewStyleGrouped];
    self.upTableView = [[NSGoodsTableView alloc] initWithFrame:CGRectMake(0, GetScaleWidth(10)+CGRectGetMaxY(self.middleView.frame), kScreenWidth, GetScaleWidth(43)) style:UITableViewStylePlain];
    self.upTableView.tag = 10;
    self.upTableView.backgroundColor = [UIColor clearColor];
    self.upTableView.bounces = NO;
    self.upTableView.tbDelegate = self;
    self.upTableView.isRefresh = NO;
    self.upTableView.isLoadMore = NO;
//    self.upTableView.scrollEnabled = NO;
//    self.upTableView.isShow = YES;
    if (@available(iOS 11.0, *)) {
        self.upTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.SV addSubview:self.upTableView];
    
    self.midTableView = [[NSGoodsTableView alloc] initWithFrame:CGRectMake(0, GetScaleWidth(319), kScreenWidth, GetScaleWidth(86)) style:UITableViewStylePlain];
    self.midTableView.tag = 20;
    self.midTableView.backgroundColor = [UIColor clearColor];
    self.midTableView.bounces = NO;
    self.midTableView.tbDelegate = self;
    self.midTableView.isRefresh = NO;
    self.midTableView.isLoadMore = NO;
//    self.midTableView.isShow = YES;
    if (@available(iOS 11.0, *)) {
        self.midTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.SV addSubview:self.midTableView];
    
    self.addSpecTableView = [[NSGoodsTableView alloc] initWithFrame:CGRectMake(0, GetScaleWidth(319+GetScaleWidth(86)), kScreenWidth, GetScaleWidth(43)) style:UITableViewStylePlain];
    self.addSpecTableView.tag = 30;
    self.addSpecTableView.backgroundColor = [UIColor clearColor];
    self.addSpecTableView.bounces = NO;
    self.addSpecTableView.tbDelegate = self;
    self.addSpecTableView.isRefresh = NO;
    self.addSpecTableView.isLoadMore = NO;
    //    self.midTableView.isShow = YES;
    if (@available(iOS 11.0, *)) {
        self.addSpecTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.SV addSubview:self.addSpecTableView];
    
    self.specTotalView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.SV addSubview:self.specTotalView];
    self.specTotalView.x = 0;
    self.specTotalView.y = CGRectGetMaxY(self.addSpecTableView.frame);
    self.specTotalView.size = CGSizeMake(kScreenWidth, 0);
    
    self.otherTableView = [[NSGoodsTableView alloc] initWithFrame:CGRectMake(0, GetScaleWidth(319), kScreenWidth, GetScaleWidth(106)) style:UITableViewStyleGrouped];
    self.otherTableView.showsVerticalScrollIndicator = NO;
    self.otherTableView.tag = 40;
    self.otherTableView.y = CGRectGetMaxY(self.specTotalView.frame)+GetScaleWidth(10);
    self.otherTableView.backgroundColor = [UIColor clearColor];
    self.otherTableView.bounces = NO;
    self.otherTableView.scrollEnabled = NO;
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
    [self setUpData];
    [self configCollectionView];
    
    
    
    [self setUpAddView];
    [self setUpNavTopView];
    [self setUpBottomBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didClickKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didKboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
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

-(void)setModel:(CategoryModel *)model{
    _model = model;
    for (ADLMyInfoModel *infoModel in self.upTableView.data) {
        if([infoModel.title isEqualToString:NSLocalizedString(@"sort", nil)]){
            infoModel.num = model.name;
            self.param.categoryId = model.ID;
        }
    }
    [self.upTableView reloadData];
    
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
        if(_selectedPhotos.count > indexPath.row ){
            cell.imageView.image = _selectedPhotos[indexPath.row];
        }
        if(_selectedAssets.count > indexPath.row ){
            cell.asset = _selectedAssets[indexPath.row];
        }
            cell.deleteBtn.hidden = NO;
        
    }
    //    if (!self.allowPickingGifSwitch.isOn) {
    //        cell.gifLable.hidden = YES;
    //    }
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
        //    imagePickerVc.naviBgColor = [UIColor redColor];
        imagePickerVc.maxImagesCount = 1;
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
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
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
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"setting", nil), nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil];
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
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"setting", nil), nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil];
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
                        if (1) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            imagePicker.needCircleCrop = NO;
                            imagePicker.circleCropRadius = 100;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
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
    
    //    if ([asset isKindOfClass:[PHAsset class]]) {
    //        PHAsset *phAsset = asset;
    //        NSLog(@"location:%@",phAsset.location);
    //    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(actionSheet.tag == 10){
        if (buttonIndex == 0) { // take photo / 去拍照
            [self takePhoto];
        } else if (buttonIndex == 1) {
            [self pushTZImagePickerController];
        }
    }else{
        NSString *updateStr = @"";
        if (buttonIndex == 0) { // 是
            NSLog(@"上架");
            updateStr = NSLocalizedString(@"yes", nil);
            self.param.isShelve = @"1";
        } else if (buttonIndex == 1) {
            NSLog(@"不上架");
            updateStr = NSLocalizedString(@"no", nil);
            self.param.isShelve = @"-1";
        }
        
        for (ADLMyInfoModel *model in self.otherTableView.data) {
            if([model.title isEqualToString:NSLocalizedString(@"on shelf", nil)]){
                model.num = updateStr;
            }
        }
        [self.otherTableView reloadData];
        
        
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
//    [picker dismissViewControllerAnimated:YES completion:nil];
    if(_selectedPhotos.count >0){
//        self.SV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-20-TopBarHeight+_selectedPhotos.count/4*(_itemWH + _margin*2));
        
        self.addView.alpha = 0.0;
        self.collectionView.alpha = 1.0;
        self.collectionView.height = (_selectedPhotos.count + 4)/4 *(_itemWH + _margin*2);
        self.middleView.dc_y = CGRectGetMaxY(self.collectionView.frame)+GetScaleWidth(9);
        self.upTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
        [self tableViewFrameChange];
    }else{
        self.addView.alpha = 1.0;
        self.collectionView.alpha = 0.0;
        self.middleView.dc_y = GetScaleWidth(109);
        self.upTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
        [self tableViewFrameChange];
    }
    // NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
//    [picker dismissViewControllerAnimated:YES completion:nil];
    [_selectedPhotos addObject:photos[0]];
    [_selectedAssets addObject:assets[0]];
    [_collectionView reloadData];
    
    if(_selectedPhotos.count >0){
        self.addView.alpha = 0.0;
        self.collectionView.alpha = 1.0;
        self.collectionView.height = (_selectedPhotos.count + 4)/4 *(_itemWH + _margin*2);
        self.middleView.dc_y = CGRectGetMaxY(self.collectionView.frame)+GetScaleWidth(9);
        self.upTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
        [self tableViewFrameChange];
    }else{
        self.addView.alpha = 1.0;
        self.collectionView.alpha = 0.0;
        self.collectionView.height = GetScaleWidth(100);
        self.middleView.dc_y = GetScaleWidth(109);
        self.upTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
        [self tableViewFrameChange];
    }
    
//    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
//
//    ClipViewController *viewController = [[ClipViewController alloc] init];
//    //    viewController.image = image;
//    viewController.picker = (UIImagePickerController *)picker;
//    viewController.controller = self;
//    viewController.delegate = self;
//    viewController.imageArr = _selectedPhotos;
//    viewController.image = _selectedPhotos[0];
//    viewController.isTakePhoto = NO;
//    [picker presentViewController:viewController animated:NO completion:nil];

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
- (void)setUpData
{
    [self.upTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:NSLocalizedString(@"sort", nil) imageName:nil num:NSLocalizedString(@"selection sort", nil)]];
    
    [self.midTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:NSLocalizedString(@"price(N)", nil) imageName:nil num:@"开个价"]];
    [self.midTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:NSLocalizedString(@"stock(g)", nil) imageName:nil num:NSLocalizedString(@"stock", nil)]];

    
    [self.addSpecTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:NSLocalizedString(@"add goods specifications", nil) imageName:@"publish_ico_goods_add" num:nil]];

    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:NSLocalizedString(@"fee(N)", nil) imageName:nil num:NSLocalizedString(@"fee", nil)]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:NSLocalizedString(@"on shelf", nil) imageName:nil num:NSLocalizedString(@"no", nil)]];
}

#pragma mark - initialize
- (void)setUpBase {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.upTableView.tableFooterView = [UIView new]; //去除多余分割线
    self.midTableView.tableFooterView = [UIView new]; //去除多余分割线
    self.addSpecTableView.tableFooterView = [UIView new]; //去除多余分割线
    self.otherTableView.tableFooterView = [UIView new]; //去除多余分割线
}

#pragma mark - NSShopTableViewDelegate

- (void)goodsTableView:(NSGoodsTableView *)goodsTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.section;
    
    if(goodsTableView.tag == 10){
        //upTableView
        NSLog(@"点击了分类");
        NSCategoryVC *ctrl = [[NSCategoryVC alloc] init];
        ctrl.stringBlock = ^(CategoryModel *model) {
            for (ADLMyInfoModel *infoModel in self.upTableView.data) {
                if([infoModel.title isEqualToString:NSLocalizedString(@"sort", nil)]){
                    infoModel.num = model.name;
                    self.param.categoryId = model.ID;
                }
            }
            [self.upTableView reloadData];
        };
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (goodsTableView.tag == 20){
        //midTableView
        switch (index) {
            case 0:{
                NSLog(@"点击了价格");
                EditUserType type = [self getEditType:NSLocalizedString(@"price(N)", nil)];
                
                NSChangeParamVC *ctrl = [[NSChangeParamVC alloc] initEditType:type];
                ctrl.editTitle = NSLocalizedString(@"price", nil);
                
                ctrl.stringBlock = ^(NSString *string) {
                    for (ADLMyInfoModel *model in self.midTableView.data) {
                        if([model.title isEqualToString:NSLocalizedString(@"price(N)", nil)]){
                            self.param.price = string;
                            model.num = [NSString stringWithFormat:@"%.2f",[string floatValue]];
                        }
                    }
                    [self.midTableView reloadData];
                };
                [self.navigationController pushViewController:ctrl animated:YES];
            }
                break;
            case 1:{
                NSLog(@"点击了数量");
                EditUserType type = [self getEditType:NSLocalizedString(@"stock(g)", nil)];
                
                NSChangeParamVC *ctrl = [[NSChangeParamVC alloc] initEditType:type];
                ctrl.editTitle = NSLocalizedString(@"stock", nil);
                ctrl.stringBlock = ^(NSString *string) {
                    for (ADLMyInfoModel *model in self.midTableView.data) {
                        if([model.title isEqualToString:NSLocalizedString(@"stock(g)", nil)]){
                            self.param.stock = string;
                            model.num = string;
                        }
                    }
                    [self.midTableView reloadData];
                };
                [self.navigationController pushViewController:ctrl animated:YES];
            }
                break;
            default:
                break;
        }
    }else if (goodsTableView.tag == 30){
        NSLog(@"点击了添加商品规格");
        [self addSpecViewWithIndexPath:indexPath];
    }else if (goodsTableView.tag == 40){
        switch (index) {
            case 0:{
                NSLog(@"点击了运费");
                EditUserType type = [self getEditType:NSLocalizedString(@"fee(N)", nil)];
                
                NSChangeParamVC *ctrl = [[NSChangeParamVC alloc] initEditType:type];
                ctrl.editTitle = NSLocalizedString(@"fee", nil);
                ctrl.stringBlock = ^(NSString *string) {
                    for (ADLMyInfoModel *model in self.otherTableView.data) {
                        if([model.title isEqualToString:NSLocalizedString(@"fee(N)", nil)]){
                            self.param.shipPrice = string;
                            model.num = [NSString stringWithFormat:@"%.2f",[string floatValue]];
                        }
                    }
                    [self.otherTableView reloadData];
                };
                [self.navigationController pushViewController:ctrl animated:YES];
            }
                break;
            case 1:{
                NSLog(@"点击了上架");
                [self updateGoods];
                
            }
                break;
            default:
                break;
        }
    }
}

-(void)addSpecViewWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"VC里面");
    self.hasSpec = YES;

    NSSpecView *specView = [NSSpecView new];
    specView.backgroundColor = KBGCOLOR;
    __weak typeof(specView) specview = specView;
    specView.deleteClickBlock = ^{
        self.specHeight -= (GetScaleWidth(49)*3+10);
        for (NSSpecView *view in self.specViewArr) {
            if(view.y > specView.y){
                view.y -= (GetScaleWidth(49)*3+10);
            }
        }
        [self.specViewArr removeObject:specview];
        
        if(self.specViewArr.count==0){
            self.hasSpec = NO;
        }
        [self specTotalViewReloadData];
        [self tableViewFrameChange];
    };

    specView.x = 0;
    specView.y = self.specHeight;
    specView.size = CGSizeMake(kScreenWidth, GetScaleWidth(49)*3+10);
    [self.specTotalView addSubview:specView];
    [self.specViewArr addObject:specView];
    self.specHeight += (GetScaleWidth(49)*3+10);
    [self specTotalViewReloadData];
    [self tableViewFrameChange];
}

-(void)updateGoods{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"yes", nil),NSLocalizedString(@"no", nil), nil];
    sheet.tag = 100;
    [sheet showInView:self.view];
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
    
    CGSize contentSize = [self contentSizeWithTitle:NSLocalizedString(@"add photo", nil)];
    
    UILabel *addPhotoLab=[[UILabel alloc] initWithFrame:CGRectMake(self.addView.centerX- contentSize.width*0.5, CGRectGetMaxY(btn.frame)+6, contentSize.width, contentSize.height)];
    [addPhotoLab setText:NSLocalizedString(@"add photo", nil)];
    addPhotoLab.font = UISystemFontSize(14);
    addPhotoLab.textColor= [UIColor blackColor];
    [self.addView addSubview:addPhotoLab];
}

-(void)addPhoto:(UIButton *)button{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"take photo", nil),NSLocalizedString(@"photo album selection", nil), nil];
    sheet.tag = 10;
    [sheet showInView:self.view];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.hidden = NO;
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:NSLocalizedString(@"goods publish", nil)];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
//        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    [weakSelf dismissModalStack];
    };
    
    [self.view addSubview:topToolView];
    
}

-(void)dismissModalStack {
    
    UIViewController *vc = self.presentingViewController;
    
    while (vc.presentingViewController) {
        
        vc = vc.presentingViewController;
        
    }
    
    [vc dismissViewControllerAnimated:NO completion:NULL];
    
}

-(void)setUpBottomBtn{
    //发布按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = KMainColor;
    btn.frame = CGRectMake(0, kScreenHeight-TabBarHeight, kScreenWidth, TabBarHeight);
    [btn setTitle:NSLocalizedString(@"publish", nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)publish:(UIButton *)btn{
    DLog(@"图片数量 = %lu",_selectedPhotos.count);
    NSMutableArray *pathArr = [NSMutableArray array];
    NSMutableArray *jsonArr = [NSMutableArray array];
    
    dispatch_group_t group = dispatch_group_create();
    for(int i=0;i<_selectedPhotos.count;i++){
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:_selectedPhotos[i] forKey:@"pic"];
        [param setObject:[NSString stringWithFormat:@"pic%d",i] forKey:@"imageName"];

        dispatch_group_enter(group);
        [GoodsPublishAPI uploadGoodsPicWithParam:param success:^(NSString *path) {
            [pathArr addObject:path];
            if(i==_selectedPhotos.count-1){
                self.param.imagePath = [pathArr componentsJoinedByString:@","];
                DLog(@"商品图片上传 = %lu",pathArr.count);
//                DLog(@"self.param.imagePath = %@",self.param.imagePath);
            self.param.productName = self.goodsNameTF.text;
            self.param.introduce = self.detailTV.text;
            
            if(self.specViewArr.count>0){
                self.param.hasSpec = @"1";
//                NSString *specStr = @"";
                for(int i=0;i<self.specViewArr.count;i++){
                    NSSpecView *specV = self.specViewArr[i];
                    [jsonArr addObject:specV.dataDict];
                }
                self.param.productSpec = [self arrayToJSONString:jsonArr];
            }else{
                self.param.hasSpec = @"0";
            }
                
//                DLog(@"categoryId = %@",self.param.categoryId);
            }
            dispatch_group_leave(group);
        } faulre:^(NSError *error) {
        }];
    }
//    DLog(@"self.param = %@",self.param.mj_keyValues);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    //调用发布接口API
    [GoodsPublishAPI createProductWithParam:self.param success:^{
        DLog(@"商品发布成功");
        //                [self dismissViewControllerAnimated:YES completion:nil];
        [Common AppShowToast:NSLocalizedString(@"goods publish success", nil)];
        [self dismissModalStack];
        //                [kAppDelegate setUpRootVC];
    } faulre:^(NSError *error) {
        DLog(@"商品发布失败");
    }];
        });
}

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

- (NSString *)arrayToJSONString:(NSArray *)array

{
    
    NSError *error = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
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
//            self.SV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-20-TopBarHeight+_selectedPhotos.count/4*(_itemWH + _margin*2));
            
            self.addView.alpha = 0.0;
            self.collectionView.alpha = 1.0;
            self.collectionView.height = (_selectedPhotos.count + 4)/4 *(_itemWH + _margin*2);
            self.middleView.dc_y = CGRectGetMaxY(self.collectionView.frame)+GetScaleWidth(9);
            self.upTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
            [self tableViewFrameChange];
        }else{
            self.addView.alpha = 1.0;
            self.collectionView.alpha = 0.0;
            self.middleView.dc_y = GetScaleWidth(109);
            self.upTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
            [self tableViewFrameChange];
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)contentSizeWithTitle:(NSString *)title {
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
}

- (EditUserType)getEditType:(NSString *)title {
    EditUserType type = 0;

    if ([title isEqualToString:NSLocalizedString(@"price(N)", nil)]) {
        type = EditUserTypePrice;
        
    } else if ([title isEqualToString:NSLocalizedString(@"stock(g)", nil)]) {
        type = EditUserTypeNumber;
        
    } else if ([title isEqualToString:NSLocalizedString(@"fee(N)", nil)]) {
        type = EditUserTypeFee;
        
    }
    
    return type;
}

-(NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

-(NSMutableArray *)specViewArr{
    if (!_specViewArr) {
        _specViewArr = [NSMutableArray array];
    }
    return _specViewArr;
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

//- (void)clipPhoto:(NSMutableArray *)array  andAssetArray:(NSMutableArray *)assetArray{
//    [_selectedPhotos removeAllObjects];
//    [_selectedAssets removeAllObjects];
//    _selectedAssets = assetArray;
//    _selectedPhotos = array;
//    //    _isSelectOriginalPhoto = isSelectOriginalPhoto;
//
//    [_collectionView reloadData];
//    if(_selectedPhotos.count >0){
//        self.addView.alpha = 0.0;
//        self.collectionView.alpha = 1.0;
//        self.collectionView.height = (_selectedPhotos.count + 4)/4 *(_itemWH + _margin*2);
//        self.middleView.dc_y = CGRectGetMaxY(self.collectionView.frame)+GetScaleWidth(9);
//        self.upTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
//        [self tableViewFrameChange];
//    }else{
//        self.addView.alpha = 1.0;
//        self.collectionView.alpha = 0.0;
//        self.collectionView.height = GetScaleWidth(100);
//        self.middleView.dc_y = GetScaleWidth(109);
//        self.upTableView.dc_y = CGRectGetMaxY(self.middleView.frame)+GetScaleWidth(15);
//        [self tableViewFrameChange];
//    }
//}

-(void)tableViewFrameChange{
    if(self.hasSpec){
        self.midTableView.alpha = 0.0;
        self.addSpecTableView.dc_y = CGRectGetMaxY(self.upTableView.frame)+GetScaleWidth(10);
        self.specTotalView.dc_y = CGRectGetMaxY(self.addSpecTableView.frame);
        self.specTotalView.height = self.specViewArr.count*(GetScaleWidth(49)*3+10);
        self.otherTableView.dc_y = CGRectGetMaxY(self.specTotalView.frame);
        self.SV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-20-TopBarHeight+_selectedPhotos.count/4*(_itemWH + _margin*2)+self.specViewArr.count*(GetScaleWidth(49)*3+10)-GetScaleWidth(86));
    }else{
        self.midTableView.alpha = 1.0;
        self.midTableView.dc_y = CGRectGetMaxY(self.upTableView.frame)+GetScaleWidth(10);
        self.addSpecTableView.dc_y = CGRectGetMaxY(self.midTableView.frame);
        self.specTotalView.dc_y = CGRectGetMaxY(self.addSpecTableView.frame);
        self.specTotalView.height = 0;
        self.otherTableView.dc_y = CGRectGetMaxY(self.specTotalView.frame);
        self.SV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-20-TopBarHeight+_selectedPhotos.count/4*(_itemWH + _margin*2));
    }
}

-(void)specTotalViewReloadData{
    [self.specTotalView removeAllSubviews];
    for (NSSpecView *view in self.specViewArr) {
        [self.specTotalView addSubview:view];
    }
}

#pragma mark -      键盘即将跳出

-(void)didClickKeyboard:(NSNotification *)sender{
    
    CGFloat durition = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyboardRect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:durition animations:^{
        
        self.SV.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
//        self.otherTableView.dc_y = CGRectGetMaxY(self.specTotalView.frame)+GetScaleWidth(10);
    }];
    
}

#pragma mark -      当键盘即将消失

-(void)didKboardDisappear:(NSNotification *)sender{
    
    CGFloat duration = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.SV.transform = CGAffineTransformIdentity;
//        self.otherTableView.dc_y = CGRectGetMaxY(self.specTotalView.frame)+GetScaleWidth(10);
    }];
    
}


@end

//
//  TDUserCertifySubVCPics.m
//  Trade
//
//  Created by FeiFan on 2017/8/30.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifySubVCPics.h"
#import "TDUserCertifyDataPics.h"
#import "TDUserCertifyCellPics.h"
#import "TDUserCertifySectionHeader.h"
#import "AJPhotoBrowserViewController.h"

@interface TDUserCertifySubVCPics () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,AJPhotoBrowserDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* commitBtn;
@property (nonatomic, strong) TDUserCertifyDataPics* dataSource;
@property (nonatomic, strong) NSArray<NSArray<NSString*>*>* headerTitles;
@property (nonatomic, assign) NSInteger curImageIndex;
@end

@implementation TDUserCertifySubVCPics

# pragma mark - datasource

// 重载数据源
- (void) reloadDatas {
    // 刷新数据源
    __weak typeof(self) wself = self;
    [self.dataSource reloadDatasOnCompletion:^{
        // 重载表格
        [wself.tableView reloadData];
    }];
}


# pragma mark - IBActions

- (IBAction) clickedCommitBtn:(id)sender {
    [self.dataSource commitDatas];
    if (self.touchEvent) {
        self.touchEvent();
    }
}

- (IBAction) clickedLoadImageBtn:(UIButton*)sender {
    self.curImageIndex = sender.tag;
    [self showImgAlertWithTag:sender.tag];
}

# pragma mark - tools

// 显示图片点击的操作事件
- (void) showImgAlertWithTag:(NSInteger)tag {
    UIAlertController* alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:KLocalizableStr(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertCtrl dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertCtrl addAction:cancel];
    BOOL isOrigin = NO;
    if (tag == 0) {
        isOrigin = self.dataSource.imageFace == self.dataSource.originImgFace;
    }
    else if (tag == 1) {
        isOrigin = self.dataSource.imageBack == self.dataSource.originImgBack;
    }
    else if (tag == 2) {
        isOrigin = self.dataSource.imageHandle == self.dataSource.originImgHandle;
    }
    
    
    __weak typeof(self) wself = self;
    if (!isOrigin) {
        UIAlertAction* large = [UIAlertAction actionWithTitle:KLocalizableStr(@"查看大图") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [wself takeLook];
        }];
        [alertCtrl addAction:large];
    }
    UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:KLocalizableStr(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [wself takePhoto];
    }];
    [alertCtrl addAction:takePhoto];
    UIAlertAction* album = [UIAlertAction actionWithTitle:KLocalizableStr(@"查看相册") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [wself takeAlbum];
    }];
    [alertCtrl addAction:album];
    [self presentViewController:alertCtrl animated:YES completion:^{
        
    }];
}

// 调起拍照
- (void) takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
        ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        [MBProgressHUD mb_showOnlyText:KLocalizableStr(@"相机不可用") detail:nil delay:1.5 inView:self.parentViewController.view];
        return;
    }
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.parentViewController presentViewController:imagePicker animated:YES completion:^{
        
    }];
}
// 调起相册
- (void) takeAlbum {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.parentViewController presentViewController:imagePicker animated:YES completion:^{
        
    }];
}
// 调起查看
- (void) takeLook {
    UIImage* image = nil;
    if (self.curImageIndex == 0) {
        image = self.dataSource.imageFace;
    }
    else if (self.curImageIndex == 1) {
        image = self.dataSource.imageBack;
    }
    else if (self.curImageIndex == 2) {
        image = self.dataSource.imageHandle;
    }
    AJPhotoBrowserViewController* photoBrowserVC = [[AJPhotoBrowserViewController alloc] initWithPhotos:@[image]];
    photoBrowserVC.delegate = self;
    [self.parentViewController presentViewController:photoBrowserVC animated:YES completion:nil];
}

// 裁剪出可视的图片
- (UIImage*) cuttingImage:(UIImage*)image {
    CGSize size = image.size;
    CGSize curSize = [UIImage imageNamed:@"certify_icon_demo"].size;
    CGSize newSize = CGSizeMake(size.width, size.width * curSize.height/curSize.width);
    return [image imageCutedWithNewSize:newSize contentMode:UIViewContentModeCenter];
}

# pragma mark - AJPhotoBrowserDelegate
- (void)photoBrowser:(AJPhotoBrowserViewController *)vc didDonePhotos:(NSArray *)photos {
    [vc dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    UIImage* originImage = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        originImage = editingInfo[@"UIImagePickerControllerOriginalImage"];
    } else {
        originImage = image;
    }
    
    if (self.curImageIndex == 0) {
        self.dataSource.imageFace = originImage;
    }
    else if (self.curImageIndex == 1) {
        self.dataSource.imageBack = originImage;
    }
    else if (self.curImageIndex == 2) {
        self.dataSource.imageHandle = originImage;
    }
    __weak typeof(self) wself = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [wself.tableView reloadData];
    }];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}



# pragma mark - tools 数据源

// header的identifier
- (NSString*) headerIdentifierInSection:(NSInteger)section {
    if (section == 2) {
        return @"TDUserCertifySectionHeaderDouble";
    } else {
        return @"TDUserCertifySectionHeader";
    }
}
// 生成header
- (UITableViewHeaderFooterView*)newHeaderViewForSection:(NSInteger)section {
    if (section == 2) {
        return [[TDUserCertifySectionHeaderDouble alloc] initWithReuseIdentifier:[self headerIdentifierInSection:section]];
    } else {
        return [[TDUserCertifySectionHeader alloc] initWithReuseIdentifier:[self headerIdentifierInSection:section]];
    }
}
// 装填header
- (void)setupHeader:(UITableViewHeaderFooterView*)header inSection:(NSInteger)section {
    if (section == 2) {
        TDUserCertifySectionHeaderDouble* doubleHeader = (TDUserCertifySectionHeaderDouble*)header;
        doubleHeader.titleLabel1.text = self.headerTitles[section][0];
        doubleHeader.titleLabel2.text = self.headerTitles[section][1];
    } else {
        TDUserCertifySectionHeader* singleHeader = (TDUserCertifySectionHeader*)header;
        singleHeader.titleLabel.text = self.headerTitles[section][0];
    }
}

// 装填图片cell
- (void) setupImageCell:(TDUserCertifyCellPics*)cell atIndexPath:(NSIndexPath*)indexPath {
    cell.loadBtn.tag = indexPath.section;
    cell.demoBtn.tag = indexPath.section;
    [cell.loadBtn removeTarget:self action:@selector(clickedLoadImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.loadBtn addTarget:self action:@selector(clickedLoadImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.section == 0) {
        [cell.loadBtn setBackgroundImage:[self cuttingImage:self.dataSource.imageFace] forState:UIControlStateNormal];
        [cell.demoBtn setBackgroundImage:self.dataSource.demoFace forState:UIControlStateNormal];
    }
    else if (indexPath.section == 1) {
        [cell.loadBtn setBackgroundImage:[self cuttingImage:self.dataSource.imageBack] forState:UIControlStateNormal];
        [cell.demoBtn setBackgroundImage:self.dataSource.demoBack forState:UIControlStateNormal];
    }
    else if (indexPath.section == 2) {
        [cell.loadBtn setBackgroundImage:[self cuttingImage:self.dataSource.imageHandle] forState:UIControlStateNormal];
        [cell.demoBtn setBackgroundImage:self.dataSource.demoHandle forState:UIControlStateNormal];
    }
}


# pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize imgSize = [UIImage imageNamed:@"certify_icon_demo"].size;
    CGFloat perWidth = (kScreenWidth - GetScaleWidth(16) * 2 - 10)/2;
    return imgSize.height / imgSize.width * perWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray* titles = self.headerTitles[section];
    CGFloat padding = GetScaleWidth(TDUserCertifySectionHeaderPadding);
    CGFloat avilableWidth = kScreenWidth - GetScaleWidth(16) * 2 - kEdgeInsetTop - [UIImage imageNamed:@"icon_circle_yellow"].size.width;
    CGFloat height = padding;
    for (NSString* title in titles) {
        CGSize textSize = KTextSize(title, avilableWidth, TDUserCertifySectionHeaderTitleFontSize);
        height += textSize.height + padding;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* view = [UIView new];
    view.backgroundColor = KColorMainBackground;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString* identifier = [self headerIdentifierInSection:section];
    UITableViewHeaderFooterView* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [self newHeaderViewForSection:section];
    }
    [self setupHeader:header inSection:section];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDUserCertifyCellPics* cell = [tableView dequeueReusableCellWithIdentifier:@"TDUserCertifyCellPics"];
    if (!cell) {
        cell = [[TDUserCertifyCellPics alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TDUserCertifyCellPics"];
    }
    [self setupImageCell:cell atIndexPath:indexPath];
    return cell;
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
    RAC(self.commitBtn, enabled) = RACObserve(self.dataSource, imagesAllLoading);
}

- (void) initializeViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetScaleWidth(20));
        make.right.mas_equalTo(GetScaleWidth(-20));
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = KColorMainBackground;
    }
    return _tableView;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [UIButton new];
        _commitBtn.backgroundColor = KColorMainOrange;
        _commitBtn.layer.cornerRadius = 5;
        [_commitBtn setTitle:KLocalizableStr(@"确认上传") forState:UIControlStateNormal];
        [_commitBtn setTitleColor:KBGCOLOR forState:UIControlStateNormal];
        [_commitBtn setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        [_commitBtn setTitleColor:kWhiteColor forState:UIControlStateDisabled];
        [_commitBtn addTarget:self action:@selector(clickedCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (NSArray *)headerTitles {
    if (!_headerTitles) {
        _headerTitles = @[@[KLocalizableStr(@"请上传清晰的身份证正面照片，拍照时请确保无反光、无遮挡.")],
                          @[KLocalizableStr(@"请上传清晰的身份证正面照片，拍照时请确保无反光、无遮挡.")],
                          @[KLocalizableStr(@"请上传清晰的双手持身份证照片，需免冠，五官清晰可见，建议未化妆，完整露出双手手臂."),
                            KLocalizableStr(@"请确保照片中身份证信息清晰可见，否则无法通过审核.")]];
    
    }
    return _headerTitles;
}

- (TDUserCertifyDataPics *)dataSource {
    if (!_dataSource) {
        _dataSource = [TDUserCertifyDataPics new];
    }
    return _dataSource;
}


@end

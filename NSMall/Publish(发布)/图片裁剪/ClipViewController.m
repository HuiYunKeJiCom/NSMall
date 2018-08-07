//
//  ClipViewController.m
//  Camera
//
//  Created by wzh on 2017/6/6.
//  Copyright © 2017年 wzh. All rights reserved.
//

#import "ClipViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetChangeRequest.h>
#import <Photos/PHFetchOptions.h>
#import "TKImageView.h"

#define SelfWidth [UIScreen mainScreen].bounds.size.width
#define SelfHeight  [UIScreen mainScreen].bounds.size.height
@interface ClipViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isClip;

@property (nonatomic, strong) TKImageView *tkImageView;

@property(nonatomic,strong)UIScrollView *imageSV;/* 选上的图片 */

@property(nonatomic,strong)UIView *dot;/* 选中标记 */
@property(nonatomic)NSInteger index;/* 裁剪下标 */
@property(nonatomic,strong)NSMutableArray *clipImageArr;/* 裁剪图片数组 */
@property(nonatomic,strong)NSMutableArray *clipAssetArr;/* 裁剪图片数组 */
@property(nonatomic,strong)UIView  *bottomView;/* 底部view */
@end

@implementation ClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 0;
//    self.imageArr = [NSMutableArray array];
    self.clipImageArr = [NSMutableArray array];

    [self createdTkImageView];

    [self createdBottomView];
    
    [self createdTool];
}

- (void)createdTkImageView
{
    _tkImageView = [[TKImageView alloc] initWithFrame:CGRectMake(0, 60, SelfWidth, SelfHeight - 180)];
    [self.view addSubview:_tkImageView];
    //需要进行裁剪的图片对象
    _tkImageView.toCropImage = _image;
    //是否显示中间线
    _tkImageView.showMidLines = NO;
    //是否需要支持缩放裁剪
    _tkImageView.needScaleCrop = YES;
    //是否显示九宫格交叉线
    _tkImageView.showCrossLines = NO;
    _tkImageView.cornerBorderInImage = NO;
    _tkImageView.cropAreaCornerWidth = 44;
    _tkImageView.cropAreaCornerHeight = 44;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = KMainColor;
    _tkImageView.cropAreaBorderLineColor = KMainColor;
    _tkImageView.cropAreaCornerLineWidth = 0;
    _tkImageView.cropAreaBorderLineWidth = 2;
    _tkImageView.cropAreaMidLineWidth = 20;
    _tkImageView.cropAreaMidLineHeight = 2;
    _tkImageView.cropAreaMidLineColor = KMainColor;
    _tkImageView.cropAreaCrossLineColor = [UIColor clearColor];
    _tkImageView.cropAreaCrossLineWidth = 0.5;
    _tkImageView.initialScaleFactor = .944f;//.944f
    _tkImageView.cropAspectRatio = 1;
    _tkImageView.maskColor = [UIColor clearColor];
    
    self.isClip = NO;
}

- (void)createdTool
{
    UIView  *editorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, 60)];
    editorView.backgroundColor = [UIColor blackColor];
    editorView.alpha = 0.8;
    [self.view addSubview:editorView];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(((SelfWidth / 3.0) - 25)/2.0, (60 - 25)/2.0, 25, 25);
    [cancleBtn setImage:[UIImage imageNamed:@"canclePhoto"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [editorView addSubview:cancleBtn];
    
//    UIButton *clipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    clipBtn.frame = CGRectMake(((SelfWidth) - 50)/2.0, (120 - 50)/2.0, 50, 50);
//    [clipBtn setImage:[UIImage imageNamed:@"clipPhoto"] forState:UIControlStateNormal];
//    [clipBtn setImage:[UIImage imageNamed:@"backPhoto"] forState:UIControlStateSelected];
//    [clipBtn addTarget:self action:@selector(clip:) forControlEvents:UIControlEventTouchUpInside];
//    [editorView addSubview:clipBtn];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(((SelfWidth) - 40)/2.0, (60 - 25)/2.0, 40, 25)];
    titLab.textColor = [UIColor whiteColor];
    titLab.font = [UIFont systemFontOfSize:15];
    titLab.text = @"裁剪";
    [editorView addSubview:titLab];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(((SelfWidth/3.0) - 40)/2.0 + (SelfWidth * 2.0/3.0), (60 - 25)/2.0, 40, 25);
//    [sureBtn setImage:[UIImage imageNamed:@"surePhoto"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"选取" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    
    [editorView addSubview:sureBtn];
}

- (void)createdBottomView{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SelfHeight - 120, SelfWidth, 120)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.alpha = 0.8;
    [self.view addSubview:self.bottomView];
    
    self.imageSV = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, SelfWidth-20, 120)];
    self.imageSV.showsHorizontalScrollIndicator = NO;
    [self.bottomView addSubview:self.imageSV];
    
    for (int i=0; i<self.imageArr.count; i++) {
        UIImageView *IV = [[UIImageView alloc]initWithFrame:CGRectMake(90*i, 20, 80, 80)];
        IV.image = self.imageArr[i];
        [self.imageSV addSubview:IV];
    }
    self.imageSV.contentSize = CGSizeMake(self.imageArr.count*90, 0);
    
    self.dot = [[UIView alloc] initWithFrame:CGRectMake(35, 5, 10, 10)];
    self.dot.layer.masksToBounds = YES; // 裁剪
    self.dot.layer.cornerRadius = 5.f;
    self.dot.backgroundColor = [UIColor blueColor];
    [self.imageSV addSubview:self.dot];
}

- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)clip:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    self.isClip = btn.selected;
    
    if (btn.selected == YES) {
        _tkImageView.toCropImage = [_tkImageView currentCroppedImage];
    }else{
        
        _tkImageView.toCropImage = _image;
    
    }
    
    

}

- (void)sure{
    
    dispatch_group_t group = dispatch_group_create();
    
    if(self.index == self.imageArr.count-1){
//        _tkImageView.toCropImage = self.imageArr[self.index];
        UIImage *image = [_tkImageView currentCroppedImage];
        if (self.isTakePhoto) {
            //将图片存储到相册
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        }
//        DLog(@"image = %@",image);
        [self.clipImageArr addObject:image];
        
        dispatch_group_enter(group);
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            PHFetchOptions*options = [[PHFetchOptions alloc]init];
            options.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"ascending:NO]];
            PHFetchResult*assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
            PHAsset *asset = [assetsFetchResults firstObject];
            [self.clipAssetArr addObject:asset];
            dispatch_group_leave(group);
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                
                [self clipImageArray:self.clipImageArr andAssetArray:self.clipAssetArr] ;
                
            });
            
        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.picker dismissViewControllerAnimated:YES completion:nil];
//        [self.controller dismissViewControllerAnimated:YES completion:nil];
    }else if(self.index < self.imageArr.count-1){
//        self.image = self.imageArr[self.index];
        
        self.index += 1;
        
        CGRect dotFrame = self.dot.frame;
        self.dot.frame = CGRectMake(dotFrame.origin.x+90, dotFrame.origin.y, dotFrame.size.width, dotFrame.size.height);
        
        if(SelfWidth - self.dot.frame.origin.x <90 || self.dot.frame.origin.x > SelfWidth){
            [self.imageSV setContentOffset:CGPointMake(self.imageSV.contentOffset.x+90, self.imageSV.contentOffset.y) animated:YES];
        }

//        NSLog(@"dot.x = %.2f",self.dot.frame.origin.x);

            UIImage *image = [_tkImageView currentCroppedImage];
            if (self.isTakePhoto) {
                //将图片存储到相册
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
            }
            [self.clipImageArr addObject:image];
        
        _tkImageView.toCropImage = self.imageArr[self.index];
        
        dispatch_group_enter(group);
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
            PHFetchOptions*options = [[PHFetchOptions alloc]init];
            options.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"ascending:NO]];
            PHFetchResult*assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
            PHAsset *asset = [assetsFetchResults firstObject];
            [self.clipAssetArr addObject:asset];
            
            dispatch_group_leave(group);
        }];
    }
}

-(void)clipImageArray:(NSMutableArray *)array andAssetArray:(NSMutableArray *)assetArray{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto: andAssetArray:)]) {
        [self.delegate clipPhoto:array  andAssetArray:assetArray];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}
         
-(NSMutableArray *)clipAssetArr{
    if (!_clipAssetArr) {
        _clipAssetArr = [NSMutableArray array];
    }
    return _clipAssetArr;
}

@end

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
@end

@implementation ClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 0;
    self.imageArr = [NSMutableArray array];
    self.clipImageArr = [NSMutableArray array];
    self.clipAssetArr = [NSMutableArray array];
//    [self.imageArr addObject:[UIImage imageNamed:@"clipPhoto"]];
//    [self.imageArr addObject:[UIImage imageNamed:@"surePhoto"]];
//    [self.imageArr addObject:[UIImage imageNamed:@"backPhoto"]];
//    [self.imageArr addObject:[UIImage imageNamed:@"canclePhoto"]];
//    [self.imageArr addObject:[UIImage imageNamed:@"clipPhoto"]];
//    [self.imageArr addObject:[UIImage imageNamed:@"surePhoto"]];
//    [self.imageArr addObject:[UIImage imageNamed:@"backPhoto"]];
//    [self.imageArr addObject:[UIImage imageNamed:@"canclePhoto"]];
    
    
    
    
    [self createdTkImageView];
    
    [self createdTool];
    
    [self createdBottomView];
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
    _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCornerLineWidth = 2;
    _tkImageView.cropAreaBorderLineWidth = 2;
    _tkImageView.cropAreaMidLineWidth = 20;
    _tkImageView.cropAreaMidLineHeight = 2;
    _tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 0.5;
    _tkImageView.initialScaleFactor = .8f;
    _tkImageView.cropAspectRatio = 0;
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
    UIView  *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SelfHeight - 120, SelfWidth, 120)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.alpha = 0.8;
    [self.view addSubview:bottomView];
    
    self.imageSV = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, SelfWidth-20, 120)];
    self.imageSV.contentSize = CGSizeMake(self.imageArr.count*90, 0);
    self.imageSV.showsHorizontalScrollIndicator = NO;
    [bottomView addSubview:self.imageSV];
    
    for (int i=0; i<self.imageArr.count; i++) {
        UIImageView *IV = [[UIImageView alloc]initWithFrame:CGRectMake(90*i, 20, 80, 80)];
        IV.image = self.imageArr[i];
        [self.imageSV addSubview:IV];
    }
    
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
    
    if(self.index == self.imageArr.count-1){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.picker dismissViewControllerAnimated:YES completion:nil];
        [self.controller dismissViewControllerAnimated:YES completion:nil];
    }else if(self.index < self.imageArr.count-1){
        self.index += 1;
//        self.image = self.imageArr[self.index];
        _tkImageView.toCropImage = self.imageArr[self.index];
        
        CGRect dotFrame = self.dot.frame;
        self.dot.frame = CGRectMake(dotFrame.origin.x+90, dotFrame.origin.y, dotFrame.size.width, dotFrame.size.height);
        
        if(SelfWidth - self.dot.frame.origin.x <90 || self.dot.frame.origin.x > SelfWidth){
            [self.imageSV setContentOffset:CGPointMake(self.imageSV.contentOffset.x+90, self.imageSV.contentOffset.y) animated:YES];
        }
        
        
//        NSLog(@"dot.x = %.2f",self.dot.frame.origin.x);
        
//        if (self.isClip == YES) {
            UIImage *image = [_tkImageView currentCroppedImage];
            if (self.isTakePhoto) {
                //将图片存储到相册
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
            }
            [self.clipImageArr addObject:image];

            
//            if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto:)]) {
//                [self.delegate clipPhoto:image];
//            }
//        }else{
//            if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto:)]) {
//                [self.delegate clipPhoto:self.image];
//            }
//            if (self.isTakePhoto) {
//                //将图片存储到相册
//                UIImageWriteToSavedPhotosAlbum(self.image, self, nil, nil);
//            }
//        }
    }
    
    //裁剪
//    if (self.isClip == YES) {
//        UIImage *image = [_tkImageView currentCroppedImage];
//        if (self.isTakePhoto) {
//            //将图片存储到相册
//            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
//        }
//
//        if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto:)]) {
//            [self.delegate clipPhoto:image];
//        }
//    }else{
//        if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto:)]) {
//            [self.delegate clipPhoto:self.image];
//        }
//        if (self.isTakePhoto) {
//            //将图片存储到相册
//            UIImageWriteToSavedPhotosAlbum(self.image, self, nil, nil);
//        }
//    }
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.picker dismissViewControllerAnimated:YES completion:nil];
//    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImageArr:(NSMutableArray *)imageArr{
    _imageArr = imageArr;

}


@end

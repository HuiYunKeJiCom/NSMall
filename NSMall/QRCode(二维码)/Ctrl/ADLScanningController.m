//
//  ADLScanningController.m
//  CXScanning
//
//  Created by adel on 16/1/7.
//  Copyright © 2016年 adel. All rights reserved.
//

#import "ADLScanningController.h"
#import "ADAudioTool.h"
#import "ADLWebCtrl.h"
#import "GPLoadingView.h"
#import "ADOrderTopToolView.h"
#import "NSGoodsDetailVC.h"
#import "UserPageVC.h"
#import "NSPayVC.h"

#define XCenter self.view.center.x
#define YCenter self.view.center.y

#define SHeight 20

#define SWidth (XCenter+30)
//#define SWidth 200


@interface ADLScanningController ()
{
    UIImageView * imageView;
}

@property (strong, nonatomic) GPLoadingView *loadingView;

@end

@implementation ADLScanningController

-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_session stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.loadingView];

    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-SWidth)/2,GetScaleWidth(160)+TopBarHeight/2.0,SWidth,SWidth)];
    imageView.image = [UIImage imageNamed:@"scanscanBg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5, SWidth-10,1)];
    _line.image = [UIImage imageNamed:@"scanLine"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(imageView.x,imageView.y  + SWidth + 10, kScreenWidth, 44)];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.centerX = self.view.centerX;
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.font = [UIFont systemFontOfSize:14];
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=KLocalizableStr(@"将二维码/条码放入框内，即可自动扫描");
    [self.view addSubview:labIntroudction];
    
    
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    [self.navigationController setNavigationBarHidden:YES];
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"二维码")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
//        [self delayPop];
    };
    [self.view addSubview:topToolView];
    [self.view bringSubviewToFront:topToolView];
}

#pragma mark - getter

- (GPLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView =  [[GPLoadingView alloc] initWithFrame:CGRectMake((kScreenWidth-130) / 2.0, (kScreenHeight-60) / 2.0, 130, 30)];
        _loadingView.commitType = YES;
        _loadingView.hidden = true;
    }
    return _loadingView;
}

#pragma mark - private methord

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
       
        if (num ==(int)(( SWidth-10)/2)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame =CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
        
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _output.rectOfInterest = [self rectOfInterestByScanViewRect:imageView.frame];//CGRectMake(0.1, 0, 0.9, 1);//
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    

    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResize;
    _preview.frame =self.view.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self.view bringSubviewToFront:imageView];

    [self setOverView];
    
    [self setUpNavTopView];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    if ([metadataObjects count] >0) {
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        /**
         *  获取扫描结果
         */
        stringValue = metadataObject.stringValue;

        //结束扫码
        [_session stopRunning];

        if([NSString isEmptyOrNull:stringValue]) {
            [Common AppShowToast:@"扫描失败!"];
            [self delayPop];
            return;
        }
        NSLog(@"二维码stringValue = %@",stringValue);
        //加入网页
        if ([NSPredicate isUrl:stringValue]) {
            [self enterWebVC:stringValue];
            [ADAudioTool playSoundWithSoundName:@"qrcode_found.wav"];
            
            return;
            
        } else {
            
            [ADAudioTool playSoundWithSoundName:@"qrcode_found.wav"];

            [self commitInfoWithQrcode:stringValue];
        }
        
    }
}

//上传二维码扫描的房间信息
- (void)commitInfoWithQrcode:(NSString *)qrcode {
    DLog(@"扫描到的字符串 = %@",qrcode);
    
    if([qrcode hasPrefix:@"uid:"]){
        UserModel *userModel = [UserModel modelFromUnarchive];
        NSArray *array = [qrcode componentsSeparatedByString:@"uid:"];
        NSString *string = [array lastObject];
        
        NSString *msg = [userModel.hx_user_name stringByAppendingString:@"要加你为好友"];
        EMError *error = [[EMClient sharedClient].contactManager addContact:string message:msg];
        if (!error) {
            [Common AppShowToast:@"添加好友成功"];
        }else{
            [Common AppShowToast:@"添加好友失败"];
        }
        [self delayPop];
    }else if ([qrcode hasPrefix:@"gid:"]){
        NSArray *array = [qrcode componentsSeparatedByString:@"gid:"];
        NSString *string = [array lastObject];
        
        NSGoodsDetailVC *detailVC = [NSGoodsDetailVC new];
        [detailVC getDataWithProductID:string andCollectNum:0];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if ([qrcode hasPrefix:@"sid:"]){
        NSArray *array = [qrcode componentsSeparatedByString:@"sid:"];
        NSString *string = [array lastObject];
    }else if ([qrcode hasPrefix:@"hid:"]){
        NSArray *array = [qrcode componentsSeparatedByString:@"hid:"];
        NSString *string = [array lastObject];
        
        //跳转至个人页面
        UserPageVC *userPageVC = [UserPageVC new];
        [userPageVC setUpDataWithUserId:string];
        [self.navigationController pushViewController:userPageVC animated:YES];
        
    }else if ([qrcode hasPrefix:@"pid:"]){
        NSArray *array = [qrcode componentsSeparatedByString:@"pid:"];
        NSString *string = [array lastObject];
        
        //跳转至付款页面
        NSPayVC *payVC = [NSPayVC new];
        [payVC setUpDataWithUserId:string];
        [self.navigationController pushViewController:payVC animated:YES];
        
    }
    
    
    
}

-(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString * string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return string;
    
}

- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
   
    return CGRectMake(x-0.1, y - 0.1, w + 0.2, h + 0.2);
}

#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = CGRectGetMinX(imageView.frame);
    CGFloat y = CGRectGetMinY(imageView.frame);
    CGFloat w = CGRectGetWidth(imageView.frame);
    CGFloat h = CGRectGetHeight(imageView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor grayColor];
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
}


#pragma mark - action

- (void)enterWebVC:(NSString *)url {
    
    ADLWebCtrl *ctrl = [[ADLWebCtrl alloc] init];
    ctrl.url = url;
    if (self.navigationController) {
        [self.navigationController pushViewController:ctrl animated:YES];
    } else {
        [self presentViewController:ctrl animated:YES completion:nil];
    }
}

- (void)delayPop {
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}

@end


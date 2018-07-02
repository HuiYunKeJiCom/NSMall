//
//  AddFriendViewController.m
//  testhuanxin
//
//  Created by gyh on 16/5/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AddFriendViewController.h"
#import "ADOrderTopToolView.h"

@interface AddFriendViewController ()
//@property (nonatomic , weak) UITextField *addfield;
@property(nonatomic,strong)UIImageView * scanView;
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UITextField *addfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 30)];
//    addfield.placeholder = @"添加好友";
//    [self.view addSubview:addfield];
//    self.addfield = addfield;
    
//    UIButton *btn = [[UIButton alloc]init];
//    btn.frame = CGRectMake(10, CGRectGetMaxY(addfield.frame)+20, self.view.frame.size.width-40, 40);
//    [btn setTitle:@"添加" forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor redColor];
//    [btn addTarget:self action:@selector(addhaoyou) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];

    self.scanView = [[UIImageView alloc] init];
    self.scanView.layer.cornerRadius = 4;
    self.scanView.layer.masksToBounds = YES;
    self.scanView.backgroundColor = [UIColor greenColor];
    self.scanView.x = kScreenWidth*0.5-100;
    self.scanView.y = kScreenHeight*0.5-100;
    self.scanView.size = CGSizeMake(200, 200);
    [self.view addSubview:self.scanView];
    
    UserModel *userModel = [UserModel modelFromUnarchive];
    [self setUpFilter:[NSString stringWithFormat:@"uid:%@",userModel.hx_user_name]];
    
    [self setUpNavTopView];
}

-(void)setUpFilter:(NSString*)string {
    /*
     注意:
     1.生成二维码时, 不建议让二维码保存过多数据, 因为数据越多, 那么二维码就越密集,那么扫描起来就越困难
     2.二维码有三个定位点, 着三个定位点不能被遮挡, 否则扫描不出来
     3.二维码即便缺失一部分也能正常扫描出结果, 但是需要注意, 这个缺失的范围是由限制的, 如果太多那么也扫面不出来
     */
    // 1.创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.还原滤镜默认属性
    [filter setDefaults];
    // 3.将需要生成二维码的数据转换为二进制
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 4.给滤镜设置数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 5.生成图片
    CIImage *qrcodeImage =  [filter outputImage];
    
    // 6.显示图片
    
    self.scanView.image = [self createNonInterpolatedUIImageFormCIImage:qrcodeImage withSize:120];
    
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *qrCodeImage = [UIImage imageWithCGImage:scaledImage];
    return qrCodeImage;
}


#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"扫一扫加我好友")];
    WEAKSELF
    
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    [self.view bringSubviewToFront:topToolView];
}

//- (void)addhaoyou
//{
//    NSString *str = [[EMClient sharedClient] currentUsername];
//    NSString *msg = [str stringByAppendingString:@"要加你为好友"];
//    EMError *error = [[EMClient sharedClient].contactManager addContact:self.addfield.text message:msg];
//    if (!error) {
//        NSLog(@"添加好友成功");
//        [MBProgressHUD showSuccess:@"添加好友成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        NSLog(@"添加好友失败,%@",error);
//        [MBProgressHUD showSuccess:@"添加好友失败"];
//    }
//}


@end

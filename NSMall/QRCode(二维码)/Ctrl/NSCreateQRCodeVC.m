//
//  NSCreateQRCode.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/5.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCreateQRCodeVC.h"
#import "ADOrderTopToolView.h"

@interface NSCreateQRCodeVC ()
@property(nonatomic,strong)UIImageView * scanView;
@property(nonatomic,strong)UIButton *personBtn;/* 个人 */
@property(nonatomic,strong)UIButton *goodsBtn;/* 商品 */
@property(nonatomic,strong)UIButton *shopBtn;/* 店铺 */
@property(nonatomic,strong)UIButton *paymentBtn;/* 收付款 */
@end

@implementation NSCreateQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNavTopView];
    
    self.personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.personBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.personBtn.titleLabel.font = UISystemFontSize(14);
    [self.personBtn setTitle:@"个人" forState:UIControlStateNormal];
    self.personBtn.tag = 2;
    [self.view addSubview:self.personBtn];
    self.personBtn.x = GetScaleWidth(20);
    self.personBtn.y = GetScaleWidth(120);
    self.personBtn.size = CGSizeMake(GetScaleWidth(60), GetScaleWidth(20));
    [self.personBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.goodsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.goodsBtn.titleLabel.font = UISystemFontSize(14);
    [self.goodsBtn setTitle:@"商品" forState:UIControlStateNormal];
    self.goodsBtn.tag = 3;
    [self.view addSubview:self.goodsBtn];
    self.goodsBtn.x = GetScaleWidth(100);
    self.goodsBtn.y = GetScaleWidth(120);
    self.goodsBtn.size = CGSizeMake(GetScaleWidth(60), GetScaleWidth(20));
    [self.goodsBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.shopBtn.titleLabel.font = UISystemFontSize(14);
    [self.shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
    self.shopBtn.tag = 4;
    [self.view addSubview:self.shopBtn];
    self.shopBtn.x = GetScaleWidth(20);
    self.shopBtn.y = GetScaleWidth(160);
    self.shopBtn.size = CGSizeMake(GetScaleWidth(60), GetScaleWidth(20));
    [self.shopBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.paymentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.paymentBtn.titleLabel.font = UISystemFontSize(14);
    [self.paymentBtn setTitle:@"付款" forState:UIControlStateNormal];
    self.paymentBtn.tag = 5;
    [self.view addSubview:self.paymentBtn];
    self.paymentBtn.x = GetScaleWidth(100);
    self.paymentBtn.y = GetScaleWidth(160);
    self.paymentBtn.size = CGSizeMake(GetScaleWidth(60), GetScaleWidth(20));
    [self.paymentBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.scanView = [[UIImageView alloc] init];
    self.scanView.layer.cornerRadius = 4;
    self.scanView.layer.masksToBounds = YES;
    self.scanView.backgroundColor = [UIColor greenColor];
    self.scanView.x = kScreenWidth*0.5-75;
    self.scanView.y = kScreenHeight*0.5-75;
    self.scanView.size = CGSizeMake(150, 150);
    [self.view addSubview:self.scanView];
}

-(void)buttonClick:(UIButton *)button{
    switch (button.tag) {
        case 2:
            [self handleType:QRCodeTypePerson];
            break;
        case 3:
            [self handleType:QRCodeTypeGoods];
            break;
        case 4:
            [self handleType:QRCodeTypeShop];
            break;
        case 5:
            [self handleType:QRCodeTypePaymePnt];
            break;
        default:
            break;
    }
}

- (void)handleType:(QRCodeType)type {
    [self.view endEditing:YES];
    switch (type) {
        case QRCodeTypePerson:
            {
                //个人
                [self setUpFilter:[NSString stringWithFormat:@"uid:123%@",self.QRString]];
            }
            break;
        case QRCodeTypeGoods:
        {
            //商品
            [self setUpFilter:[NSString stringWithFormat:@"gid:123%@",self.QRString]];
        }
            break;
        case QRCodeTypeShop:
        {
            //店铺
            [self setUpFilter:[NSString stringWithFormat:@"sid:123%@",self.QRString]];
        }
            break;
        case QRCodeTypePaymePnt:
        {
            //付款
            [self setUpFilter:[NSString stringWithFormat:@"hid:123%@",self.QRString]];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"二维码")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:topToolView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)setQRString:(NSString *)QRString{
    _QRString = QRString;
}

@end

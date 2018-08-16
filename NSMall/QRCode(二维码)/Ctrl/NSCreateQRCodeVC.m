//
//  NSCreateQRCode.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/5.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCreateQRCodeVC.h"
#import "ADOrderTopToolView.h"
#import "ReceivableRecordVC.h"

@interface NSCreateQRCodeVC ()
@property(nonatomic,strong)UIView *bgView;/* 背景View */
@property(nonatomic,strong)UILabel *tipLab;/* 提示语 */
@property(nonatomic,strong)UIImageView * scanView;
@property(nonatomic,strong)UIView *lineView;/* 线 */
@property(nonatomic,strong)UIView *receivableRecordV;/* 收款记录View */
@property(nonatomic,strong)UIImageView *headerIV;/* 头像 */

//@property(nonatomic,strong)UIButton *personBtn;/* 个人 */
//@property(nonatomic,strong)UIButton *goodsBtn;/* 商品 */
//@property(nonatomic,strong)UIButton *shopBtn;/* 店铺 */
//@property(nonatomic,strong)UIButton *paymentBtn;/* 收付款 */
@end

@implementation NSCreateQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor =KBGCOLOR;
    [self setUpNavTopView];
    

    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.tipLab];
//    self.scanView.center = self.bgView.center;
    [self.bgView addSubview:self.scanView];
    //    self.scanView.center = self.bgView.center;
    [self.bgView addSubview:self.headerIV];
    
    UserModel *userModel = [UserModel modelFromUnarchive];
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:userModel.pic_img]];
    
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.receivableRecordV];
    [self makeConstraints];

//    self.receivableRecordV.backgroundColor = [UIColor greenColor];
    
    UIImageView *recordIV = [[UIImageView alloc]init];
//    recordIV.backgroundColor = kRedColor;
    recordIV.image = IMAGE(@"money_ico_list");
    [self.receivableRecordV addSubview:recordIV];
    recordIV.x = 0;
    recordIV.y = 16;
    recordIV.size = CGSizeMake(17, 18);
    
    UILabel *recordLab = [[UILabel alloc]init];
    recordLab.font = UISystemFontSize(14);
    recordLab.textColor = kBlackColor;
    recordLab.textAlignment = NSTextAlignmentLeft;
    [self.receivableRecordV addSubview:recordLab];
    recordLab.x = CGRectGetMaxX(recordIV.frame)+10;
    recordLab.y = 15;
    recordLab.size = CGSizeMake(100, 20);
    recordLab.text = NSLocalizedString(@"receivables record", nil);
    
    UIImageView *arrowImgView = [[UIImageView alloc]init];
    arrowImgView.image = IMAGE(@"my_ico_right_arrow");
    [self.receivableRecordV addSubview:arrowImgView];
    arrowImgView.x = kScreenWidth-80-9;
    arrowImgView.y = 20;
    arrowImgView.size = CGSizeMake(5, 9);
    
    //付款
    [self setUpFilter:[NSString stringWithFormat:@"pid:%@",userModel.user_id]];

    
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:NSLocalizedString(@"QR code receipt", nil)];
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

//-(void)setQRString:(NSString *)QRString{
//    _QRString = QRString;
//}

-(void)checkReceivableRecord{
    //跳转到转账记录
    ReceivableRecordVC *recordVC = [[ReceivableRecordVC alloc]init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(GetScaleWidth(20));
        make.top.equalTo(weakSelf.view.mas_top).with.offset(GetScaleWidth(30)+TopBarHeight);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-40, 568*0.7));
    }];
    
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(GetScaleWidth(30));
    }];
    
    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(GetScaleWidth(20));
        make.top.equalTo(weakSelf.scanView.mas_bottom).with.offset(GetScaleWidth(20));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-80, 1));
    }];
    
    [self.receivableRecordV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(GetScaleWidth(20));
        make.top.equalTo(weakSelf.lineView.mas_bottom).with.offset(GetScaleWidth(5));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-80, 50));
    }];
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectZero];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc]init];
        _tipLab.font = UISystemFontSize(14);
        _tipLab.textColor = kBlackColor;
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.text = NSLocalizedString(@"pay with QR code", nil);
    }
    return _tipLab;
}

-(UIImageView *)scanView{
    if (!_scanView) {
        _scanView = [[UIImageView alloc] init];
        _scanView.layer.cornerRadius = 4;
        _scanView.layer.masksToBounds = YES;
    }
    return _scanView;
}

-(UIImageView *)headerIV{
    if (!_headerIV) {
        _headerIV = [[UIImageView alloc] init];
    }
    return _headerIV;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = kGreyColor;
    }
    return _lineView;
}

-(UIView *)receivableRecordV{
    if (!_receivableRecordV) {
        _receivableRecordV = [[UIView alloc]initWithFrame:CGRectZero];
        _receivableRecordV.backgroundColor = kWhiteColor;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkReceivableRecord)];
        [_receivableRecordV addGestureRecognizer:myTap];
    }
    return _receivableRecordV;
}






@end

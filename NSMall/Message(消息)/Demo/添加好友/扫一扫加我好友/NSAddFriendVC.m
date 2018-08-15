//
//  NSAddFriendVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/10.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSAddFriendVC.h"
#import "ADOrderTopToolView.h"

@interface NSAddFriendVC ()<EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate>
@property(nonatomic,strong)UIImageView * scanView;
/** 好友的名称 */
@property (nonatomic, copy) NSString *buddyUsername;
@end

@implementation NSAddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KBGCOLOR;
    [self setUpNavTopView];
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
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

#pragma mark - 好友请求回调
/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage
{
    NSLog(@"aUsername = %@,%@",aUsername,aMessage);
    self.buddyUsername = aUsername;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友添加请求" message:aMessage delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        //同意好友请求
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:self.buddyUsername];
        if (!error) {
            NSLog(@"同意加好友成功");
        }else{
            NSLog(@"同意加好友失败");
        }
    }else{
        //拒绝好友请求
        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:self.buddyUsername];
        if (!error) {
            NSLog(@"拒绝加好友成功");
        }else{
            NSLog(@"拒绝加好友失败");
        }
    }
}

/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage{
    DLog(@"收到%@的好友请求",aUsername);
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
    if (!error) {
        NSLog(@"发送同意成功");
    }
}

@end

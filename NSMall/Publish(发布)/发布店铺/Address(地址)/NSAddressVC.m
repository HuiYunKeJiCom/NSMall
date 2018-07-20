//
//  NSAddressVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSAddressVC.h"
#import "ADOrderTopToolView.h"
#import "NSSearchAddressVC.h"


@interface NSAddressVC ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,BMKMapViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)BMKMapView *mapView;/* 地图view */
@property(nonatomic,strong)BMKLocationService *locService;/* 定位 */
@property(nonatomic,strong)UIImageView *pinIV;/* 大头针 */
@property(nonatomic,strong)UILabel *geographicLab;/* 地理信息 */
@property(nonatomic,strong)UIImageView *labelBgV;/* 地理信息背景图 */
@property(nonatomic,strong)BMKGeoCodeSearch *searcher;/* 云检索 */
@property(nonatomic,strong)UITextField *searchTF;/* 搜索地址 */
@property(nonatomic,strong)ShopAddressParam *shopAddressParam;/* 店铺住址和坐标 */

@end

@implementation NSAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shopAddressParam = [ShopAddressParam new];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy =  kCLLocationAccuracyBest;
    _locService.distanceFilter = 10;//大于100米
    //启动LocationService
    [_locService startUserLocationService];
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, TopBarHeight, kScreenWidth, kScreenHeight-44)];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    [self.mapView setMapType:BMKMapTypeStandard]; //切换为标准地图
    self.mapView.userTrackingMode = BMKUserTrackingModeHeading;//设置定位的状态为定位罗盘模式，我的位置始终在地图中心，我的位置图标和地图都会跟着旋转
    //以下_mapView为BMKMapView对象
    self.mapView.showsUserLocation = NO;//显示定位图层
    //    self.mapView.userTrackingMode = BMKUserTrackingModeHeading;
    [self.view addSubview:_mapView];
    self.mapView.userInteractionEnabled = YES;
    
    self.pinIV = [[UIImageView alloc]init];
    self.pinIV.image = IMAGE(@"pin");
    self.pinIV.contentMode = UIViewContentModeScaleAspectFit;
    self.pinIV.size = CGSizeMake(32, 32);
    self.pinIV.center = self.view.center;
    [self.view addSubview:self.pinIV];
    
    self.searchTF = [[UITextField alloc]init];
    self.searchTF.delegate = self;
    self.searchTF.textColor = kBlackColor;
    self.searchTF.backgroundColor = kWhiteColor;
    self.searchTF.x = 40;
    self.searchTF.y = 30+TopBarHeight;
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, GetScaleWidth(30))];
    self.searchTF.leftView = paddingView;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchTF.size = CGSizeMake(kScreenWidth-80, 30);
    self.searchTF.clearsOnBeginEditing = YES;
    self.searchTF.alpha = 0.7;
    [self.view addSubview:self.searchTF];
    
    self.labelBgV = [[UIImageView alloc] init];
    self.labelBgV.alpha = 0.9;
    self.labelBgV.x = 40;
    self.labelBgV.y = kScreenHeight-130;
    self.labelBgV.size = CGSizeMake(kScreenWidth-80, 30);
    self.labelBgV.backgroundColor = kWhiteColor;
    [self.view addSubview:self.labelBgV];
    
    self.geographicLab = [[UILabel alloc]init];
    self.geographicLab.x = 10;
    self.geographicLab.y = 0;
    self.geographicLab.size = CGSizeMake(kScreenWidth-90, 30);
    self.geographicLab.textColor = kBlackColor;
    self.geographicLab.font = UISystemFontSize(14);
    self.geographicLab.textAlignment = NSTextAlignmentLeft;
    self.geographicLab.backgroundColor = [UIColor clearColor];
    [self.labelBgV addSubview:self.geographicLab];
    
    self.labelBgV.userInteractionEnabled = YES;
    self.geographicLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    // 2. 将点击事件添加到imageView上
    [self.geographicLab addGestureRecognizer:TapGestureRecognizer];
    
    //logo位置
    self.mapView.logoPosition = BMKLogoPositionLeftBottom;
    
    [self setUpNavTopView];
    
    
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:NSLocalizedString(@"address", nil)];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        if (weakSelf.paramBlock) {
            weakSelf.paramBlock(weakSelf.shopAddressParam);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %.6f,long %.6f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    NSLog(@"定位成功！！！");
    [self.mapView updateLocationData:userLocation];//更新位置 前提是MapView.showsUserLocation=YES;
    self.mapView.centerCoordinate = userLocation.location.coordinate;//移动到中心点
    
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = userLocation.location.coordinate;//中心点
    region.span.latitudeDelta = 0.001;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.001;//纬度范围
    [_mapView setRegion:region animated:YES];
    
    
    
    
    
}

//设置标注样式
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        BMKPinAnnotationView*annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.pinColor = BMKPinAnnotationColorPurple;
        annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop=NO;         //设置标注动画显示，默认为NO
        annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
        return annotationView;
    }
    return nil;
}

////点击标注后切换中心点
//- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
//    NSLog(@"点击标注后切换中心点");
//    self.mapView.centerCoordinate = view.annotation.coordinate;
//}

-(void)viewWillAppear:(BOOL)animated{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    _searcher.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    CGRect pinFrame = self.pinIV.frame;
    [UIView animateWithDuration:0.4 animations:^{
        self.pinIV.frame = CGRectMake(pinFrame.origin.x, pinFrame.origin.y-10, pinFrame.size.width, pinFrame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.pinIV.frame = CGRectMake(pinFrame.origin.x, pinFrame.origin.y, pinFrame.size.width, pinFrame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    
    //    NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = centerCoordinate;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        
//                NSLog(@"address = %@",result.address);

        BMKPoiInfo *poiInfo = result.poiList[0];

        self.geographicLab.text = [NSString stringWithFormat:@"%@",poiInfo.name];
        self.searchTF.text = result.address;
        self.shopAddressParam.address = result.address;
        self.shopAddressParam.location = result.location;
        if (self.paramBlock) {
            self.paramBlock(self.shopAddressParam);
        }
    }
}

//实现Deleage处理回调结果
//返回地址信息搜索结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    DLog(@"返回地址信息搜索结果");
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
//        DLog(@"latitude = %f,longitude = %f",result.location.latitude,result.location.longitude);
        self.mapView.centerCoordinate = result.location;
        //        result.location
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTF resignFirstResponder];// 使当前文本框失去第一响应者的特权，就会回收键盘了
    
    return YES;
}

- (void)tapClick {
    NSLog(@"点击图片");
  
    NSSearchAddressVC *saVC = [NSSearchAddressVC new];
    saVC.stringBlock = ^(NSString *string) {
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        //发起地理位置检索
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geoCodeSearchOption.address = string;
        //    @"广东省深圳市宝安区海汇路105";
        //    geoCodeSearchOption.city = @"北京";
        BOOL flag = [_searcher geoCode:geoCodeSearchOption];
        if(flag)
        {
            NSLog(@"geo检索发送成功");
        }
        else
        {
            NSLog(@"geo检索发送失败");
        }
    };
    [self.navigationController pushViewController:saVC animated:YES];
    
}

@end

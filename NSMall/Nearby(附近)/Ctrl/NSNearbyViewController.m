//
//  NSNearbyViewController.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSNearbyViewController.h"
#import "AnimatedAnnotationView.h"

@interface NSNearbyViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,BMKMapViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)BMKMapView *mapView;/* 地图view */
@property(nonatomic,strong)BMKLocationService *locService;/* 定位 */
@property(nonatomic,strong)UIImageView *pinIV;/* 大头针 */
@property(nonatomic,strong)BMKGeoCodeSearch *searcher;/* 云检索 */


@end

@implementation NSNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy =  kCLLocationAccuracyBest;
    _locService.distanceFilter = 10;//大于100米
    //启动LocationService
    [_locService startUserLocationService];
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44)];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    [self.mapView setMapType:BMKMapTypeStandard]; //切换为标准地图
    self.mapView.userTrackingMode = BMKUserTrackingModeHeading;//设置定位的状态为定位罗盘模式，我的位置始终在地图中心，我的位置图标和地图都会跟着旋转
    //以下_mapView为BMKMapView对象
    self.mapView.showsUserLocation = NO;//显示定位图层
//    self.mapView.userTrackingMode = BMKUserTrackingModeHeading;
    [self.view addSubview:_mapView];
    self.mapView.userInteractionEnabled = YES;

//    self.pinIV = [[UIImageView alloc]init];
//    self.pinIV.image = IMAGE(@"pin");
//    self.pinIV.contentMode = UIViewContentModeScaleAspectFit;
//    self.pinIV.size = CGSizeMake(32, 32);
//    self.pinIV.center = self.view.center;
//    [self.view addSubview:self.pinIV];
    
    
    
    //logo位置
    self.mapView.logoPosition = BMKLogoPositionLeftBottom;
    

    
    
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
    NSLog(@"设置标注样式");
    //动画annotation
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    AnimatedAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[AnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
        [images addObject:image];
    }
    annotationView.annotationImages = images;
    
//        MarkerOptions ooD = new MarkerOptions().position(llD).icons(giflist)
//        .zIndex(0).period(10);
//
//        if (animationBox.isChecked()) {
//            // 生长动画
//            ooD.animateType(MarkerAnimateType.grow);
//        }
//        Marker  mMarkerD = (Marker) (mBaiduMap.addOverlay(ooD));
    
    return annotationView;
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
    
//    DLog(@"error = %u",error);
//    DLog(@"BMK_SEARCH_NO_ERROR = %d",BMK_SEARCH_NO_ERROR);
    if (error == BMK_SEARCH_NO_ERROR) {
        
//        NSLog(@"address = %@",result.address);
//        NSLog(@"addressDetail = %@",result.addressDetail);
//        NSLog(@"sematicDescription = %@",result.sematicDescription);
        
//        self.geographicLab.text = [NSString stringWithFormat:@"%@",result.address];
    }
}




@end

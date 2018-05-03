//
//  NSNearbyViewController.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSNearbyViewController.h"

@interface NSNearbyViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate>
@property(nonatomic,strong)BMKMapView *mapView;/* 地图view */
@property(nonatomic,strong)BMKLocationService *locService;/* 定位 */
@end

@implementation NSNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44)];
    [self.mapView setMapType:BMKMapTypeStandard]; //切换为标准地图
    //以下_mapView为BMKMapView对象
    self.mapView.showsUserLocation = YES;//显示定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态为普通定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeHeading;
    self.view = self.mapView;
    //logo位置
    self.mapView.logoPosition = BMKLogoPositionLeftBottom;
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(22.597, 113.996);
    annotation.title = @"这里是北京";
    [self.mapView addAnnotation:annotation];
    
    BMKPointAnnotation* annotation2 = [[BMKPointAnnotation alloc]init];
    annotation2.coordinate = CLLocationCoordinate2DMake(22.577466, 113.895634);
    annotation2.title = @"这里是辉云科技有限公司";
    [self.mapView addAnnotation:annotation2];
    
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

//    NSLog(@"定位成功！！！");
//    [self.mapView updateLocationData:userLocation];//更新位置 前提是MapView.showsUserLocation=YES;
//    self.mapView.centerCoordinate = userLocation.location.coordinate;//移动到中心点
//
//    BMKCoordinateRegion region ;//表示范围的结构体
//    region.center = userLocation.location.coordinate;//中心点
//    region.span.latitudeDelta = 0.01;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
//    region.span.longitudeDelta = 0.01;//纬度范围
//    [_mapView setRegion:region animated:YES];
    
    
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
        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

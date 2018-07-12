//
//  NSNearbyViewController.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//



#import "NSNearbyViewController.h"
#import "NearbyStoreParam.h"
#import "NearbyStoreAPI.h"
#import "NearbyStoreModel.h"
#import "NSClusterAnnotationView.h"
#import "NSClusterAnnotation.h"
#import "ShopInfoView.h"
#import "BMKClusterManager.h"
#import "NSTotalStoreV.h"


@interface NSNearbyViewController ()<NSTotalStoreVDelegate,ShopInfoViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,BMKMapViewDelegate,UITextFieldDelegate,NSClusterAnnotationViewDelegate>{
    BMKClusterManager *_clusterManager;//点聚合管理类
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
}
@property(nonatomic,strong)BMKMapView *mapView;/* 地图view */
@property(nonatomic,strong)BMKLocationService *locService;/* 定位 */
@property(nonatomic,strong)UIImageView *pinIV;/* 大头针 */
@property(nonatomic,strong)BMKGeoCodeSearch *searcher;/* 云检索 */
@property(nonatomic,strong)NearbyStoreModel *shopListModel;/* 商品列表模型 */
@property(nonatomic,strong)ShopInfoView *shopInfoV;/* 店铺信息 */
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;/* 中心点坐标 */
@property(nonatomic,strong)NSString *address;/* 用来判断定位地址是否一致 */
@property(nonatomic,strong)NSTotalStoreV *totalStoreV;/* 总的商户 */

@property (nonatomic,assign) CLLocationCoordinate2D endCoordinate;  //!< 要导航的坐标
@property (nonatomic,assign) CLLocationCoordinate2D startCoordinate;  //!< 起点坐标
     
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
    [self.view addSubview:_mapView];
    self.mapView.userInteractionEnabled = YES;
    

    
    //logo位置
    self.mapView.logoPosition = BMKLogoPositionLeftBottom;
    
    WEAKSELF
    self.shopInfoV = [[ShopInfoView alloc]initWithFrame:CGRectMake(kScreenWidth*0.15, kScreenHeight, kScreenWidth*0.7, kScreenHeight*0.6)];
    self.shopInfoV.backgroundColor = [UIColor whiteColor];
    self.shopInfoV.delegate = self;
    self.shopInfoV.closeClickBlock = ^{
        [weakSelf mapViewClick];
    };
    [self.view addSubview:self.shopInfoV];

    UITapGestureRecognizer *mapViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewClick)];
    [_mapView addGestureRecognizer:mapViewTapGestureRecognizer];
    _mapView.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    self.totalStoreV = [[NSTotalStoreV alloc]initWithFrame:CGRectMake(kScreenWidth*0.15, kScreenHeight-140, kScreenWidth*0.7, kScreenHeight*0.6)];
    self.totalStoreV.backgroundColor = [UIColor whiteColor];
    self.totalStoreV.delegate = self;
    [self.view addSubview:self.totalStoreV];
    
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    upSwipe.numberOfTouchesRequired = 1;
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.totalStoreV addGestureRecognizer:upSwipe];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    swipe.numberOfTouchesRequired = 1;
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.totalStoreV addGestureRecognizer:swipe];
    
    
    
    
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
    
    
    //设置地图中心为用户经纬度
    [_mapView updateLocationData:userLocation];
    self.mapView.centerCoordinate = userLocation.location.coordinate;//移动到中心点
    self.centerCoordinate = userLocation.location.coordinate;
    
//    [self searchNearbyStore:userLocation.location.coordinate];
//    [self updateClusters];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
//    [self searchNearbyStore:self.centerCoordinate];
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
    
        DLog(@"regionDidChangeAnimated");
    
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    self.centerCoordinate = region.center;
    
    _clusterManager = [[BMKClusterManager alloc] init];
    
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = self.mapView.centerCoordinate;
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
//    DLog(@"result = %@",result.mj_keyValues);
//    DLog(@"self.address = %@",self.address);
//    DLog(@"result.address = %@",result.address);
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKPoiInfo *poiInfo = result.poiList[0];
        if([self.address isEqualToString:poiInfo.name]){
            DLog(@"定位相同");
        }else{
            DLog(@"定位不同");
//            self.address = result.address;
            self.address = [NSString stringWithFormat:@"%@",poiInfo.name];
            
            self.endCoordinate = result.location;
            [self searchNearbyStore:self.centerCoordinate];
//            [self updateClusters];

        }
        
//        result.address;
    }
}

-(void)searchNearbyStore:(CLLocationCoordinate2D )center{
    NearbyStoreParam *param = [NearbyStoreParam new];
    param.longitude = [NSString stringWithFormat:@"%f",center.longitude];
    param.latitude = [NSString stringWithFormat:@"%f",center.latitude];
    
    [NearbyStoreAPI getNearbyStoreList:param success:^(NearbyStoreModel *result) {
        DLog(@"获取附近店铺列表成功");
        self.shopListModel = result;
        self.totalStoreV.storeList = result.storeList;
        [_clusterManager clearClusterItems];
        for (NSStoreModel *storeModel in result.storeList) {
            //            NSStoreModel *storeModel = [[NSStoreModel alloc] init];
            //            storeModel.name = poiInfo.name;
            //            storeModel.latitude = poiInfo.pt.latitude;
            //            storeModel.longitude = poiInfo.pt.longitude;
            
            [self addAnnoWithPT:storeModel];
            [self updateClusters];
        }
        
    } failure:^(NSError *error) {
        DLog(@"获取附近店铺列表失败");
        NSArray *nilArr = [NSArray array];
        self.totalStoreV.storeList = nilArr;
    }];
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    
    //    view.backgroundColor = [UIColor cyanColor];
    //点击了商店
    NSClusterAnnotationView *clusterAnnotation = (NSClusterAnnotationView *)view.annotation;
//    [self positionButtonClick];
    
    NSLog(@"点击了%@", clusterAnnotation.storeModel.name);
    //    NSLog(@"name = %@",clusterAnnotation.storeModel.name);
    
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    
    //普通annotation
    NSString *AnnotationViewID = @"ClusterMark";
    NSClusterAnnotation *cluster = (NSClusterAnnotation*)annotation;
    NSClusterAnnotationView *annotationView = [[NSClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    annotationView.size = cluster.size;
    annotationView.storeModel = cluster.storeModel;
    annotationView.delegate = self;
    annotationView.canShowCallout = NO;//在点击大头针的时候会弹出那个黑框框
    annotationView.draggable = NO;//禁止标注在地图上拖动
    annotationView.annotation = cluster;
    annotationView.frame = CGRectMake(0, 0, 100, 100);
    return annotationView;
}

#pragma mark - XJClusterAnnotationViewDelegate
-(void)showShopInfoViewWithClusterAnnotationView:(NSStoreModel *)storeModel clusterAnnotationView:(NSClusterAnnotationView *)clusterAnnotationView{
    self.totalStoreV.isShow = YES;
    [self hideTotalStoreViewWithAlpha];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.shopInfoV.frame = CGRectMake(kScreenWidth*0.15, kScreenHeight*0.4, kScreenWidth*0.7, kScreenHeight*0.6);
    }];
    self.shopInfoV.storeModel = storeModel;
//    DLog(@"storeModel = %@",storeModel.mj_keyValues);
}

-(void)mapViewClick{
    //    NSLog(@"收起");
    [UIView animateWithDuration:0.3 animations:^{
        self.shopInfoV.frame = CGRectMake(kScreenWidth*0.15, kScreenHeight, kScreenWidth*0.7, kScreenHeight*0.6);
    }];
    self.totalStoreV.isShow = NO;
    [self hideTotalStoreViewWithAlpha];
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)swipe{
    if(swipe.direction == UISwipeGestureRecognizerDirectionUp){
        DLog(@"向上");
        self.totalStoreV.isShow = NO;
        [self showTotalStoreView];
    }else if(swipe.direction == UISwipeGestureRecognizerDirectionDown){
        DLog(@"向下");
        self.totalStoreV.isShow = YES;
        [self showTotalStoreView];
    }
}


#pragma mark - 添加PT
- (void)addAnnoWithPT:(NSStoreModel *)storeModel {
    
    BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
    clusterItem.coor = CLLocationCoordinate2DMake(storeModel.latitude, storeModel.longitude);
    clusterItem.title = storeModel.name;
    clusterItem.v = storeModel;
    [_clusterManager addClusterItem:clusterItem];
}

//更新聚合状态(数据数组)
- (void)updateClusters {
    
    
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    @synchronized(_clusterCaches) {
        
        
        NSMutableArray *clusters = [NSMutableArray array];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            ///获取聚合后的标注
            __block NSArray *array = [_clusterManager getClusters:_clusterZoom];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for (BMKCluster *item in array) {
                    NSClusterAnnotation *annotation = [[NSClusterAnnotation alloc] init];
                    annotation.coordinate = item.coordinate;
                    annotation.size = item.size;
                    annotation.title = item.title;
                    annotation.storeModel = item.storeModel;
                    [clusters addObject:annotation];
                }
                [_mapView removeOverlays:_mapView.overlays];
                [_mapView removeAnnotations:_mapView.annotations];
                [_mapView addAnnotations:clusters];
                
            });
        });
    }
    //    }
}

/**
 *地图初始化完毕时会调用此接口
 *@param mapView 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    [_mapView updateLocationViewWithParam:displayParam];

    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = self.centerCoordinate;//中心点
    region.span.latitudeDelta = 0.001;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.001;//纬度范围
    [_mapView setRegion:region animated:YES];
    
//    [self searchNearbyStore:self.centerCoordinate];
    
//    [self updateClusters];
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    if ([view isKindOfClass:[NSClusterAnnotationView class]]) {
        NSClusterAnnotationView *clusterAnnotation = (NSClusterAnnotationView*)view.annotation;
        if (clusterAnnotation.size > 3) {
            [mapView setCenterCoordinate:view.annotation.coordinate];
            [mapView zoomIn];
        }
    }
}

/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *@param mapView 地图View
 *@param status 此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
//    _clusterZoom != 0 &&
//    if ( _clusterZoom != (NSInteger)mapView.zoomLevel) {
//        [self updateClusters];
//    }
}

-(void)callUpWithPhoneNumber:(NSString *)phoneNumber{
    
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",phoneNumber];
                          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:phoneNumber preferredStyle:UIAlertControllerStyleAlert];
                          
                          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
                          
                          UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
                          
                          // Add the actions.
                          [alertController addAction:cancelAction];
                          [alertController addAction:otherAction];
                          [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showTotalStoreView{
    if(self.totalStoreV.isShow){
        [UIView animateWithDuration:0.3 animations:^{
            self.totalStoreV.frame = CGRectMake(kScreenWidth*0.15, kScreenHeight-140, kScreenWidth*0.7, kScreenHeight*0.6);
        }];
        self.totalStoreV.isShow = NO;
    }else{
//        DLog(@"kScreenHeight = %.2f",kScreenHeight);
//        DLog(@"storeList.count = %ld",self.shopListModel.storeList.count);
        [UIView animateWithDuration:0.3 animations:^{
            if(self.shopListModel.storeList.count>4){
                self.totalStoreV.frame = CGRectMake(kScreenWidth*0.15, kScreenHeight-60-4*GetScaleWidth(80), kScreenWidth*0.7, 60+4*GetScaleWidth(80));
            }else{
                self.totalStoreV.frame = CGRectMake(kScreenWidth*0.15, kScreenHeight-60-self.shopListModel.storeList.count*GetScaleWidth(80), kScreenWidth*0.7, 60+self.shopListModel.storeList.count*GetScaleWidth(80));
            }
        }];
        self.totalStoreV.isShow = YES;
    }
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"section = %ld",indexPath.section);
    
    [self hideTotalStoreViewWithAlpha];
    
    NSStoreModel *storeModel = self.totalStoreV.storeList[indexPath.section];
    NSClusterAnnotationView *clusterAnnotationView = [NSClusterAnnotationView new];
    [self showShopInfoViewWithClusterAnnotationView:storeModel clusterAnnotationView:clusterAnnotationView];
    

}

-(void)hideTotalStoreViewWithAlpha{
    if(self.totalStoreV.isShow){
        [UIView animateWithDuration:0.3 animations:^{
            self.totalStoreV.frame = CGRectMake(kScreenWidth*0.15, kScreenHeight-140, kScreenWidth*0.7, kScreenHeight*0.6);
            self.totalStoreV.alpha = 0.0;
        }];
        self.totalStoreV.isShow = NO;

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.totalStoreV.frame = CGRectMake(kScreenWidth*0.15, kScreenHeight-140, kScreenWidth*0.7, kScreenHeight*0.6);
            self.totalStoreV.alpha = 1.0;
        }];
        self.totalStoreV.isShow = YES;
    }
}
//跳转导航的方法
-(void)navigateToTargetPositionWithThird{
    DLog(@"跳转导航的方法");
    
    DLog(@"address = %@",self.address);
    
    //由于与百度地图所转化的经纬度坐标存在差异通过 transform_baidu_from_mars方法进行转化（使用转化之后的坐标）

    double lat =0.0;
    double lng =0.0;
    transform_baidu_from_mars(self.endCoordinate.latitude, self.endCoordinate.longitude, &lat, &lng);
    
    CLLocation * location2 = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    
    CLLocationCoordinate2D endCoor =location2.coordinate;
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //自带地图
    [alertController addAction:[UIAlertAction actionWithTitle:@"自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"alertController -- 自带地图");
        
        //使用自带地图导航
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil]];
        
        toLocation.name = self.address;
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
        
    }]];
    
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme=  &poiname=%@&lat=%f&lon=%f&dev=0&style=2",self.address,endCoor.latitude,endCoor.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",endCoor.latitude,endCoor.longitude,self.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //显示alertController
    [self presentViewController:alertController animated:YES completion:nil];
    
}

const double x_pi =M_PI * 3000.0 /180.0;
void transform_baidu_from_mars(double bd_lat,double bd_lon, double *gg_lat,double *gg_lon)
{
    double x = bd_lon -0.0065, y = bd_lat - 0.006;
    double z =sqrt(x * x + y * y) - 0.00002 * sin(y *x_pi);
    double theta =atan2(y, x) - 0.000003 *cos(x * x_pi);
    *gg_lon = z * cos(theta);
    *gg_lat = z * sin(theta);
}

@end

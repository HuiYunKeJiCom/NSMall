//
//  NSClusterAnnotationView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import "NSStoreModel.h"

@class NSClusterAnnotationView;
@protocol NSClusterAnnotationViewDelegate <NSObject>

-(void)showShopInfoViewWithClusterAnnotationView:(NSStoreModel *)storeModel clusterAnnotationView:(NSClusterAnnotationView *)clusterAnnotationView;

@end

//BMKPinAnnotationView
@interface NSClusterAnnotationView : BMKAnnotationView
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, assign) NSInteger size;
@property(nonatomic,strong)NSStoreModel *storeModel;/* 商品模型 */
@property (nonatomic, weak)id <NSClusterAnnotationViewDelegate>delegate;
@end

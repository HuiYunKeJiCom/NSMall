//
//  AnimatedAnnotationView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotationView.h>

@interface AnimatedAnnotationView : BMKAnnotationView
@property (nonatomic, strong) NSMutableArray *annotationImages;
@property (nonatomic, strong) UIImageView *annotationImageView;
@end

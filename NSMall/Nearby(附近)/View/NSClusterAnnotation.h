//
//  NSClusterAnnotation.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import "NSStoreModel.h"

@interface NSClusterAnnotation : BMKPointAnnotation
//所包含annotation个数
@property (nonatomic, assign) NSInteger size;
@property(nonatomic,strong)NSStoreModel *storeModel;/* 商品模型 */
@end

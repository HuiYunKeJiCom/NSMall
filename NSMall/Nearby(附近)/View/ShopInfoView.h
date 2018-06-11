//
//  ShopInfoView.h
//  BMKMapClusterView
//
//  Created by 张锐凌 on 2018/4/30.
//  Copyright © 2018年 BaiduMap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSStoreModel.h"

@interface ShopInfoView : UIView
/** 点击关闭 */
@property (nonatomic, copy) dispatch_block_t closeClickBlock;
@property(nonatomic,strong)NSStoreModel *storeModel;/* 商品模型 */
@end

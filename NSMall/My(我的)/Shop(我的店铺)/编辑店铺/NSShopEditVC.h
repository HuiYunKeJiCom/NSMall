//
//  NSShopEditVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/16.
//  Copyright © 2018年 www. All rights reserved.
//

#import "DCBaseSetViewController.h"
#import "NSShopListItemModel.h"

@interface NSShopEditVC : DCBaseSetViewController
@property(nonatomic,strong)NSShopListItemModel *shopModel;/* 店铺模型 */
- (void)getDataWithShopModel:(NSShopListItemModel *)shopModel;
@end

//
//  NSGoodsEditVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import "DCBaseSetViewController.h"
#import "CategoryModel.h"
#import "NSMyProductListItemModel.h"

@interface NSGoodsEditVC : DCBaseSetViewController
@property(nonatomic,copy)CategoryModel *model;/* 选择分类 */
- (void)getDataWithProductId:(NSMyProductListItemModel *)productModel;

@end

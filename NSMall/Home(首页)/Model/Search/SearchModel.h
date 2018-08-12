//
//  SearchModel.h
//  NSMall
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductListItemModel.h"
#import "NSShopListItemModel.h"
#import "LabelItemModel.h"

@interface SearchModel : NSObject

/*
    参考在线API文档
    http://doc.huist.cn/index.php?s=/10&page_id=289
 */

@property (nonatomic,assign)NSInteger totalPage;//总页数
@property (nonatomic,assign)NSInteger pageSize;//显示个数
@property (nonatomic,assign)NSInteger rows;//总条数
@property (nonatomic,assign)NSInteger currentPage;//当前页数
@property (nonatomic,strong)NSArray<ProductListItemModel *> *productList;//商品集合参数
@property (nonatomic,strong)NSArray<NSShopListItemModel *> *storeList;//店铺集合参数
@property (nonatomic,strong)NSArray<LabelItemModel*> *labelList;//店铺标签集合参数

@end

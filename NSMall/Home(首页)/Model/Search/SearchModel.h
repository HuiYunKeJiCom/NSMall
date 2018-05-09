//
//  SearchModel.h
//  NSMall
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductListItemModel.h"
#import "StoreItemModel.h"

@interface SearchModel : NSObject

/*
    参考在线API文档
    http://doc.huist.cn/index.php?s=/10&page_id=289
 */

@property (nonatomic,assign)NSInteger totalPage;//
@property (nonatomic,assign)NSInteger pageSize;//
@property (nonatomic,assign)NSInteger rows;//
@property (nonatomic,assign)NSInteger currentPage;//
@property (nonatomic,strong)NSArray<ProductListItemModel *> *productList;//
@property (nonatomic,strong)NSArray<StoreItemModel *> *storeList;//
@property (nonatomic,strong)NSArray *labelList;//

@end

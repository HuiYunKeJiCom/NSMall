//
//  ProductListModel.h
//  NSMall
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductListItemModel.h"

/*
    映射模型，参考在线文档
    http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@interface ProductListModel : NSObject<YYModel>

@property (nonatomic,assign)NSInteger rows;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger totalPage;
@property (nonatomic,strong)NSArray<ProductListItemModel *> *productList;

@end

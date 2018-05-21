//
//  NSMyProductListModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/17.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMyProductListItemModel.h"

@interface NSMyProductListModel : NSObject<YYModel>

@property (nonatomic,assign)NSInteger rows;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger totalPage;
@property (nonatomic,strong)NSArray<NSMyProductListItemModel *> *productList;

@end

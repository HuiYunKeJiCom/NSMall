//
//  NSStoreListModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSStoreItemModel.h"

@interface NSStoreListModel : NSObject
@property (nonatomic,assign)NSInteger rows;//总条数
@property (nonatomic,assign)NSInteger currentPage;//当前页数
@property (nonatomic,assign)NSInteger pageSize;//显示个数
@property (nonatomic,assign)NSInteger totalPage;//总页数
@property (nonatomic,strong)NSArray<NSStoreItemModel *> *storeList;
@end

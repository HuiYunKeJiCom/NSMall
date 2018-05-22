//
//  NSOrderListModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSOrderListItemModel.h"

@interface NSOrderListModel : NSObject<YYModel>

@property (nonatomic,assign)NSInteger rows;//总条数
@property (nonatomic,assign)NSInteger currentPage;//当前页数
@property (nonatomic,assign)NSInteger pageSize;//显示个数
@property (nonatomic,assign)NSInteger totalPage;//总页数
@property (nonatomic,strong)NSArray<NSOrderListItemModel *> *orderList;

@end

//
//  NSRecordLogModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSLogListModel.h"

@interface NSRecordLogModel : NSObject
@property (nonatomic,assign)NSInteger rows;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger totalPage;
@property (nonatomic,strong)NSArray<NSLogListModel *> *logs;

@end

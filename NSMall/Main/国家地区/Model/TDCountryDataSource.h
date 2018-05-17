//
//  TDCountryDataSource.h
//  Trade
//
//  Created by FeiFan on 2017/9/8.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id data);
typedef void (^FailBlock)(NSString * msg);

@class TDCountryCodesModel;

@interface TDCountryDataSource : NSObject

// 获取国家码列表
- (void) getCountryDatasOnSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

# pragma mark - 过滤方法

- (void) filterringWithText:(NSString*)text onFinished:(void (^) (void))finishedBlock;

# pragma mark - tableView的数据源方法

// section个数
- (NSInteger) numberOfSections;
// row个数
- (NSInteger) numberOfRowsInSection:(NSInteger)section;
// 国家名
- (NSString*) countryNameAtIndexPath:(NSIndexPath*)indexPath;
// 分组标题
- (NSString*) sectionNameInSection:(NSInteger)section;
// 字母索引数组
- (NSArray*) sectionIndexs;
// 获取指定索引的国家数据
- (TDCountryCodesModel*) countryModelAtIndexPath:(NSIndexPath*)indexPath;

@end

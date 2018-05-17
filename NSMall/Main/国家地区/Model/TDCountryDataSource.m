//
//  TDCountryDataSource.m
//  Trade
//
//  Created by FeiFan on 2017/9/8.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDCountryDataSource.h"
#import "TDCountryCodesModel.h"

@interface TDCountryNewModel : TDCountryCodesModel <NSCopying>
@property (nonatomic, copy) NSString* countryNamePin; // 国家名的拼音
@end



@interface TDCountryDataSource()

@property (nonatomic, strong) NSMutableArray<TDCountryNewModel*>* originDataSource; // 源数据
@property (nonatomic, strong) NSMutableArray<TDCountryNewModel*>* filteredDataSource; // 过滤后的数据
@property (nonatomic, strong) NSMutableArray<NSArray<TDCountryNewModel*>*>* displayDataSource; // 即将显示的数据
@property (nonatomic, strong) NSMutableArray* countryNamePinList; // 国家名拼音数组
@end

@implementation TDCountryDataSource

# pragma mark - interface

- (NSArray*) sectionIndexs {
    return self.countryNamePinList;
}

// section个数
- (NSInteger) numberOfSections {
    return self.countryNamePinList.count;
}
// row个数
- (NSInteger) numberOfRowsInSection:(NSInteger)section {
    return self.displayDataSource[section].count;
}
// 国家名
- (NSString*) countryNameAtIndexPath:(NSIndexPath*)indexPath {
    return self.displayDataSource[indexPath.section][indexPath.row].nameCn;
}
// 分组标题
- (NSString*) sectionNameInSection:(NSInteger)section {
    return self.countryNamePinList[section];
}

// 获取指定索引的国家数据
- (TDCountryCodesModel*) countryModelAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath) {
        return self.displayDataSource[indexPath.section][indexPath.row];
    } else {
        return nil;
    }
}


// 获取国家信息列表
- (void)getCountryDatasOnSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
   //这里需要修改,判断电话号码归属地
//    WEAKSELF
//    [RequestTool appCountryCodesSuccess:^(NSDictionary *result) {
//        [weak_self.originDataSource removeAllObjects];
//        NSArray* list = result[@"data"];
//        for (NSDictionary* node in list) {
//            TDCountryNewModel* cnModel = [TDCountryNewModel mj_objectWithKeyValues:node];
//            cnModel.countryNamePin = [[NSString phonetic:cnModel.nameCn] uppercaseString];
//            [weak_self.originDataSource addObject:cnModel];
//        }
//        // 处理数据
//        if (weak_self.originDataSource.count > 0) {
//            // 过滤、分组
//            [weak_self filterringWithText:nil onFinished:^{
//                if (successBlock) {
//                    successBlock(nil);
//                }
//            }];
//        } else {
//            if (successBlock) {
//                successBlock(nil);
//            }
//        }
//    } fail:^(NSString *msg) {
//        if (failBlock) {
//            failBlock(msg);
//        }
//    }];
}

// 过滤、分组
- (void) filterringWithText:(NSString*)text onFinished:(void (^) (void))finishedBlock {
    // 过滤
    [self.filteredDataSource removeAllObjects];
    if (text && text.length > 0) {
        // 从origin过滤到filter; 要确保filter要有数据
        for (TDCountryNewModel* node in self.originDataSource) {
            if ([node.nameCn containsString:[NSString trimWhitespace:text]]) {
                [self.filteredDataSource addObject:node];
            }
        }
        // 没有匹配到就用原来的数据
        if (self.filteredDataSource.count == 0) {
            [self.filteredDataSource addObjectsFromArray:self.originDataSource];
        }
    } else {
        [self.filteredDataSource addObjectsFromArray:self.originDataSource];
    }
    // 分组
    [self divideIntoNewGroups];
    if (finishedBlock) {
        finishedBlock();
    }
}


# pragma mark - tools

// 按拼音首字母分组：升序排序(分组过程中，重置拼音数组)
- (void) divideIntoNewGroups {
    // 排序一次：升序 ?? 是否要添加立即停止处理
    [self.filteredDataSource sortUsingComparator:^NSComparisonResult(TDCountryNewModel* node1, TDCountryNewModel* node2) {
        return [node1.countryNamePin compare:node2.countryNamePin];
    }];
    // 按字母分组
    [self.countryNamePinList removeAllObjects];
    [self.displayDataSource removeAllObjects];
    NSMutableArray* tempArray = @[].mutableCopy;
    for (int i = 0; i < self.filteredDataSource.count; i++) {
        TDCountryNewModel* node = self.filteredDataSource[i];
        NSString* firstC = [node.countryNamePin substringWithRange:NSMakeRange(0, 1)];
        // 存在就将数组追加到显示列表
        if ([self.countryNamePinList containsObject:firstC]) {
            [tempArray addObject:node];
        }
        // 不存在则添加到临时列表,并添加字母
        else {
            [self.countryNamePinList addObject:firstC];
            // 如果当前临时列表有数据，要添加到显示列表中
            if (tempArray.count > 0) {
                [self.displayDataSource addObject:[NSArray arrayWithArray:tempArray]];
                [tempArray removeAllObjects];
            }
            [tempArray addObject:node];
        }
        // 已经是最后一个node:将临时列表追加到显示列表中
        if (i == self.filteredDataSource.count - 1) {
            [self.displayDataSource addObject:[NSArray arrayWithArray:tempArray]];
        }
    }
}



# pragma mark - getter

- (NSMutableArray *)originDataSource {
    if (!_originDataSource) {
        _originDataSource = @[].mutableCopy;
    }
    return _originDataSource;
}

- (NSMutableArray *)filteredDataSource {
    if (!_filteredDataSource) {
        _filteredDataSource = @[].mutableCopy;
    }
    return _filteredDataSource;
}

- (NSMutableArray *)countryNamePinList {
    if (!_countryNamePinList) {
        _countryNamePinList = @[].mutableCopy;
    }
    return _countryNamePinList;
}

- (NSMutableArray<NSArray<TDCountryNewModel *> *> *)displayDataSource {
    if (!_displayDataSource) {
        _displayDataSource = @[].mutableCopy;
    }
    return _displayDataSource;
}

@end




@implementation TDCountryNewModel

- (id)copyWithZone:(NSZone *)zone {
    TDCountryNewModel* model = [TDCountryNewModel allocWithZone:zone];
    model.modeifyTime = self.modeifyTime;
    model.nameCn = self.nameCn;
    model.createBy = self.createBy;
    model.idx = self.idx;
    model.code = self.code;
    model.modeifyBy = self.modeifyBy;
    model.nameEn = self.nameEn;
    model.timeZone = self.timeZone;
    model.createTime = self.createTime;
    model.countryNamePin = self.countryNamePin;

    return model;
}

@end

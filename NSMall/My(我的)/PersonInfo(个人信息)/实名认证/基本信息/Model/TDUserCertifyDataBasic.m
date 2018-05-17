//
//  TDUserCertifyDataBasic.m
//  Trade
//
//  Created by FeiFan on 2017/8/31.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifyDataBasic.h"
#import "TDUserCertifyDataSource.h"
#import "NSDate+Addition.h"


@interface TDUserCertifyDataBasic()
@property (nonatomic, strong) NSArray* dataSource;
@end

@implementation TDUserCertifyDataBasic

# pragma mark - 提交数据
- (void) commitDatas {
    if (self.dataAllInputed) {
        TDNameCertifyModel* model = [TDUserCertifyDataSource sharedRealNameCtrl].realNameModel;
        for (TDUserCertifyDataBasicNode* node in self.dataSource) {
            // 姓名
            if ([node.title isEqualToString:KLocalizableStr(TDUserCertifyTitleName)]) {
                model.name = node.value;
            }
            // 国家
            else if ([node.title isEqualToString:KLocalizableStr(TDUserCertifyTitleCountry)]) {
                model.country = node.value;
            }
            // 身份证
            else if ([node.title isEqualToString:KLocalizableStr(TDUserCertifyTitleIdType)]) {
                model.idType = node.value;
            }
            // 身份证号
            else if ([node.title isEqualToString:KLocalizableStr(TDUserCertifyTitleIdNumber)]) {
                model.idNo = node.value;
            }
            // 性别
            else if ([node.title isEqualToString:KLocalizableStr(TDUserCertifyTitleSex)]) {
                model.sex = node.value;
            }
            // 生日
            else if ([node.title isEqualToString:KLocalizableStr(TDUserCertifyTitleBirth)]) {
                NSDate* date = node.value;
                model.birth = [date dateWithFormat:@"yyyy-MM-dd"];
            }
            // 职业
            else if ([node.title isEqualToString:KLocalizableStr(TDUserCertifyTitleDuty)]) {
                model.vocation = node.value;
            }
            // 地址
            else if ([node.title isEqualToString:KLocalizableStr(TDUserCertifyTitleAddr)]) {
                model.commonAddress = node.value;
            }
        }
    }
}


# pragma mark - update
// 刷新数据源(从源数据重载)
- (void) reloadDatas {
    TDNameCertifyModel* model = [TDUserCertifyDataSource sharedRealNameCtrl].realNameModel;

    // 姓名
    if (model.name && model.name.length > 0) {
        [self updateValue:model.name forTitle:KLocalizableStr(TDUserCertifyTitleName)];
    }
    // 国家
    if (model.country && model.country.length > 0) {
        [self updateValue:model.country forTitle:KLocalizableStr(TDUserCertifyTitleCountry)];
    }
    // 身份证
    if (model.idType) {
        [self updateValue:model.idType forTitle:KLocalizableStr(TDUserCertifyTitleIdType)];
    }
    // 身份证号
    if (model.idNo && model.idNo.length > 0) {
        [self updateValue:model.idNo forTitle:KLocalizableStr(TDUserCertifyTitleIdNumber)];
    }
    // 性别
    if (model.sex) {
        [self updateValue:model.sex forTitle:KLocalizableStr(TDUserCertifyTitleSex)];
    }
    // 生日
    if (model.birth && model.birth.length > 0) {
        [self updateValue:[NSString dateFromString:model.birth formate:@"yyyy-MM-dd hh:mm:ss"] forTitle:KLocalizableStr(TDUserCertifyTitleBirth)];
    }
    // 职业
    if (model.vocation && model.vocation.length > 0) {
        [self updateValue:model.vocation forTitle:KLocalizableStr(TDUserCertifyTitleDuty)];
    }
    // 地址
    if (model.commonAddress && model.commonAddress.length > 0) {
        [self updateValue:model.commonAddress forTitle:KLocalizableStr(TDUserCertifyTitleAddr)];
    }
}

// 更新性别
- (void)updateSexWithValue:(NSNumber *)value {
    [self updateValue:value forTitle:KLocalizableStr(TDUserCertifyTitleSex)];
}

// 更新出生日期
- (void) updateBirthDayWithValue:(NSString*)value {
    [self updateValue:value forTitle:KLocalizableStr(TDUserCertifyTitleBirth)];
}

- (void) updateValue:(id)value forTitle:(NSString*)title {
    NSLog(@"--=-=-=-setvalue[%@] for title[%@]", value, title);
    TDUserCertifyDataBasicNode* node = [self nodeForTitle:title];
    if (node) {
        node.value = value;
    }
}
- (TDUserCertifyDataBasicNode*)nodeForTitle:(NSString*)title {
    for (TDUserCertifyDataBasicNode* node in self.dataSource) {
        NSLog(@"-----title[%@], node.title[%@]", title, node.title);
        if ([node.title isEqualToString:title]) {
            return node;
        }
    }
    return nil;
}


# pragma mark - datasource
- (NSInteger)numberOfRows {
    return self.dataSource.count;
}

- (CGFloat)heightForCellAtRow:(NSInteger)row {
    return GetScaleWidth(50);
}

- (TDUserCertifyDataBasicNode *)dataNodeAtRow:(NSInteger)row {
    if (row >= self.dataSource.count) {
        return nil;
    } else {
        return self.dataSource[row];
    }
}

# pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataAllInputed = NO;
        [self bindingAllValues];
    }
    return self;
}

- (void) bindingAllValues {
    NSMutableArray* allNodes = [NSMutableArray array];
    for (TDUserCertifyDataBasicNode* node in self.dataSource) {
        [allNodes addObject:RACObserve(node, value)];
    }
    RAC(self, dataAllInputed) = [RACSignal combineLatest:allNodes
    reduce:^id(NSString* name, NSString* country, NSNumber* type, NSString* idNo, NSNumber* sex, NSDate* date, NSString* duty, NSString* addr){
        return @(name && name.length > 0 && country && country.length > 0 && type && idNo && idNo.length > 0 && sex && date && duty && duty.length > 0 && addr && addr.length > 0 );
    }];
}

# pragma mark - getter


- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[[TDUserCertifyDataBasicNode nodeWithTitle:KLocalizableStr(TDUserCertifyTitleName) identifier:TDUserCertifyCellTypeTxtInputed placeHolder:KLocalizableStr(@"请输入姓名") value:nil],
                        [TDUserCertifyDataBasicNode nodeWithTitle:KLocalizableStr(TDUserCertifyTitleCountry) identifier:TDUserCertifyCellTypePicker placeHolder:nil value:KLocalizableStr(@"中国")],
                        [TDUserCertifyDataBasicNode nodeWithTitle:KLocalizableStr(TDUserCertifyTitleIdType) identifier:TDUserCertifyCellTypePicker placeHolder:nil value:@(1)], // 1:身份证
                        [TDUserCertifyDataBasicNode nodeWithTitle:KLocalizableStr(TDUserCertifyTitleIdNumber) identifier:TDUserCertifyCellTypeTxtInputed placeHolder:KLocalizableStr(@"请输入您的身份证号码") value:nil],
                        [TDUserCertifyDataBasicNode nodeWithTitle:KLocalizableStr(TDUserCertifyTitleSex) identifier:TDUserCertifyCellTypePicker placeHolder:nil value:@(1)], // 1:男,0:女
                        [TDUserCertifyDataBasicNode nodeWithTitle:KLocalizableStr(TDUserCertifyTitleBirth) identifier:TDUserCertifyCellTypePicker placeHolder:KLocalizableStr(@"请选择") value:nil],
                        [TDUserCertifyDataBasicNode nodeWithTitle:KLocalizableStr(TDUserCertifyTitleDuty) identifier:TDUserCertifyCellTypeTxtInputed placeHolder:KLocalizableStr(@"请输入您的职业") value:nil],
                        [TDUserCertifyDataBasicNode nodeWithTitle:KLocalizableStr(TDUserCertifyTitleAddr) identifier:TDUserCertifyCellTypeTxtInputed placeHolder:KLocalizableStr(@"请输入您的常用地址") value:nil]];
    }
    return _dataSource;
}

@end


@implementation TDUserCertifyDataBasicNode

+ (instancetype)nodeWithTitle:(NSString *)title identifier:(NSString *)identifier placeHolder:(NSString *)placeHolder value:(NSString *)value {
    TDUserCertifyDataBasicNode* node = [TDUserCertifyDataBasicNode new];
    node.title = title;
    node.cellIdentifier = identifier;
    node.placeHolder = placeHolder;
    node.value = value;
    return node;
}

@end

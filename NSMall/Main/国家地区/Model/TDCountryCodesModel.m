//
//  TDCountryCodesModel.m
//  Trade
//
//  Created by 郭善明 on 2017/9/6.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDCountryCodesModel.h"

@implementation TDCountryCodesModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idx": @"id"};
}

- (id)copyWithZone:(NSZone *)zone {
    TDCountryCodesModel* model = [TDCountryCodesModel new];
    model.modeifyTime = self.modeifyTime;
    model.nameCn = self.nameCn;
    model.createBy = self.createBy;
    model.idx = self.idx;
    model.code = self.code;
    model.modeifyBy = self.modeifyBy;
    model.nameEn = self.nameEn;
    model.timeZone = self.timeZone;
    model.createTime = self.createTime;
    return model;
}
@end

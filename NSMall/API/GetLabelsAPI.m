//
//  GetLabelsAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import "GetLabelsAPI.h"

@implementation GetLabelsAPI
+ (void)getLabels:(GetLabelsParam *_Nullable)param success:(void (^)(LabelListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kGetLabelsAPI showHUD:NetNullStr resultClass:[LabelListModel class] success:^(LabelListModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:failure];
}

+ (void)saveLabels:(SaveLabelParam *_Nullable)param success:(void (^)(LabelItemModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kSaveLabelsAPI showHUD:NetNullStr resultClass:[LabelItemModel class] success:^(LabelItemModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:failure];
}
@end

//
//  GetLabelsAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabelListModel.h"
#import "LabelItemModel.h"
#import "GetLabelsParam.h"
#import "SaveLabelParam.h"

@interface GetLabelsAPI : NSObject
/*
 获取标签列表
 */
+ (void)getLabels:(GetLabelsParam *_Nullable)param success:(void (^)(LabelListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

/*
 新增标签
 */
+ (void)saveLabels:(SaveLabelParam *_Nullable)param success:(void (^)(LabelItemModel * _Nullable result))success failure:(void (^)(NSError *error))failure;
@end

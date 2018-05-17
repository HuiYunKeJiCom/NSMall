//
//  TDUserCertifyDataSource.h
//  Trade
//
//  Created by FeiFan on 2017/9/11.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDNameCertifyModel.h"

typedef void (^SuccessBlock)(id data);
typedef void (^FailBlock)(NSString * msg);

@interface TDUserCertifyDataSource : NSObject

// 公共入口；用于在childrenVC填充数据
+ (instancetype) sharedRealNameCtrl;

// 保存要上传的数据
@property (nonatomic, copy) TDNameCertifyModel* realNameModel;

// 上传数据(完成后要清空数据)
- (void) uploadRealNameDataOnSuccess:(SuccessBlock)successBlock orFail:(FailBlock)failBlock;

// 重新获取实名认证信息
- (void) reloadRealNameDataOnSuccess:(SuccessBlock)successBlock orFail:(FailBlock)failBlock;

@end

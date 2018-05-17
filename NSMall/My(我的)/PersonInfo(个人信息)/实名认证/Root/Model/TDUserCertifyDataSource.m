//
//  TDUserCertifyDataSource.m
//  Trade
//
//  Created by FeiFan on 2017/9/11.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifyDataSource.h"


@implementation TDUserCertifyDataSource

+ (instancetype)sharedRealNameCtrl {
    static TDUserCertifyDataSource* globalUserCertify;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalUserCertify = [TDUserCertifyDataSource new];
    });
    return globalUserCertify;
}


- (void)uploadRealNameDataOnSuccess:(SuccessBlock)successBlock orFail:(FailBlock)failBlock {
    //这里需要修改,上传三张照片
    
    // 上传正面照
//    __weak typeof(self) wself = self;
//    [RequestTool appUploadWithImage:self.realNameModel.imageFace onSuccess:^(id data) {
//        // 保存正面图片的url
//        wself.realNameModel.cardFront = data;
//        // 上传反面照
//        [RequestTool appUploadWithImage:wself.realNameModel.imageBack onSuccess:^(id data) {
//            // 保存背面图片的url
//            wself.realNameModel.cardBack = data;
//            // 上传手持照
//            [RequestTool appUploadWithImage:wself.realNameModel.imageHold onSuccess:^(id data) {
//                // 保存手持图片的url
//                wself.realNameModel.holdCard = data;
//                // 上传所有信息
//                [RequestTool appRealNameCreateInfo:wself.realNameModel onSuccess:^(id data) {
//                    if (successBlock) {
//                        successBlock(data);
//                    }
//                } fail:^(NSString *msg) {
//                    if (failBlock) {
//                        failBlock(msg);
//                    }
//                }];
//            } orFail:^(NSString *msg) {
//                if (failBlock) {
//                    failBlock(msg);
//                }
//            }];
//        } orFail:^(NSString *msg) {
//            if (failBlock) {
//                failBlock(msg);
//            }
//        }];
//    } orFail:^(NSString *msg) {
//        if (failBlock) {
//            failBlock(msg);
//        }
//    }];
}

// 重新获取实名认证信息
- (void) reloadRealNameDataOnSuccess:(SuccessBlock)successBlock orFail:(FailBlock)failBlock {
//这里需要修改
    
//    __weak typeof(self) wself = self;
//    [RequestTool appRealNameGetInfoOnSuccess:^(TDNameCertifyModel* data) {
//        wself.realNameModel = data;
//        successBlock(nil);
//    } fail:^(NSString *msg) {
//        failBlock(msg);
//    }];
}

# pragma mark - getter

- (TDNameCertifyModel *)realNameModel {
    if (!_realNameModel) {
        _realNameModel = [TDNameCertifyModel new];
    }
    return _realNameModel;
}


@end

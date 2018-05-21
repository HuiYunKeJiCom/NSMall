//
//  TDUserCertifyDataSource.m
//  Trade
//
//  Created by FeiFan on 2017/9/11.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifyDataSource.h"
#import "UserInfoAPI.h"


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
    WEAKSELF
    NSMutableDictionary *foregroundParam = [NSMutableDictionary dictionary];
    [foregroundParam setObject:self.realNameModel.imageFace forKey:@"pic"];
    [foregroundParam setObject:@"foreground" forKey:@"imageName"];
    
    NSMutableDictionary *backgroundParam = [NSMutableDictionary dictionary];
    [backgroundParam setObject:self.realNameModel.imageBack forKey:@"pic"];
    [backgroundParam setObject:@"background" forKey:@"imageName"];
    
    NSMutableDictionary *holdParam = [NSMutableDictionary dictionary];
    [holdParam setObject:self.realNameModel.imageHold forKey:@"pic"];
    [holdParam setObject:@"hold" forKey:@"imageName"];
    // 上传正面照
    [UserInfoAPI uploadIDCardWithParam:foregroundParam success:^(NSString *path) {
        NSLog(@"正面照上传成功");
        weakSelf.realNameModel.cardFront = path;
        // 上传反面照
        [UserInfoAPI uploadIDCardWithParam:backgroundParam success:^(NSString *path) {
            NSLog(@"反面照上传成功");
            weakSelf.realNameModel.cardBack = path;
            // 上传手持照
            [UserInfoAPI uploadIDCardWithParam:holdParam success:^(NSString *path) {
                NSLog(@"手持照上传成功");
                weakSelf.realNameModel.holdCard = path;
                // 上传所有信息
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:self.realNameModel.name forKey:@"realName"];
                [param setObject:self.realNameModel.idNo forKey:@"idcard"];
                [param setObject:self.realNameModel.cardFront forKey:@"frontImage"];
                [param setObject:self.realNameModel.cardBack forKey:@"backImage"];
                [param setObject:self.realNameModel.holdCard forKey:@"handheldImage"];
                [UserInfoAPI certificationWithParam:param success:^(NSString *message){
                    NSLog(@"认证信息上传成功");
                    if (successBlock) {
                        successBlock(message);
                    }
                } faulre:^(NSError *error) {
                    NSLog(@"认证信息上传失败");
                }];
                
            } faulre:^(NSError *error) {
                NSLog(@"手持照上传失败");
            }];
        } faulre:^(NSError *error) {
            NSLog(@"反面照上传失败");
        }];
    } faulre:^(NSError *error) {
        NSLog(@"正面照上传失败");
    }];
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

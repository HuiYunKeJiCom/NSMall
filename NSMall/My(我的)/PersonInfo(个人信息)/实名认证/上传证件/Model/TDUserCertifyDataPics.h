//
//  TDUserCertifyDataPics.h
//  Trade
//
//  Created by FeiFan on 2017/9/8.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDUserCertifyDataPics : NSObject

- (void) reloadDatasOnCompletion:(void (^) (void))completion;

// 所有图片都采集了(当前有三张)
@property (nonatomic, assign) BOOL imagesAllLoading;

// 正面
@property (nonatomic, copy) UIImage* imageFace;
@property (nonatomic, strong) UIImage* demoFace;

// 背面
@property (nonatomic, copy) UIImage* imageBack;
@property (nonatomic, strong) UIImage* demoBack;

// 手持
@property (nonatomic, copy) UIImage* imageHandle;
@property (nonatomic, strong) UIImage* demoHandle;


@property (nonatomic, strong) UIImage* originImgFace;
@property (nonatomic, strong) UIImage* originImgBack;
@property (nonatomic, strong) UIImage* originImgHandle;

// 提交数据
- (void) commitDatas;

@end

//
//  TDUserCertifyDataPics.m
//  Trade
//
//  Created by FeiFan on 2017/9/8.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifyDataPics.h"
#import "TDUserCertifyDataSource.h"

@interface TDUserCertifyDataPics()


@end

@implementation TDUserCertifyDataPics

- (void)commitDatas {
    if (self.imagesAllLoading) {
        TDNameCertifyModel* userCenterModel = [TDUserCertifyDataSource sharedRealNameCtrl].realNameModel;
        userCenterModel.imageFace = self.imageFace;
        userCenterModel.imageBack = self.imageBack;
        userCenterModel.imageHold = self.imageHandle;
    }
}

- (void) reloadDatasOnCompletion:(void (^) (void))completion {
    __weak typeof(self) wself = self;
    TDNameCertifyModel* model = [TDUserCertifyDataSource sharedRealNameCtrl].realNameModel;
    if (model.cardFront && model.cardFront.length > 0) {
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:model.cardFront] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            wself.imageFace = image;
            if (completion) {
                completion();
            }
        }];
    }
    if (model.cardBack && model.cardBack.length > 0) {
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:model.cardBack] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            wself.imageBack = image;
            if (completion) {
                completion();
            }
        }];
    }
    if (model.holdCard && model.holdCard.length > 0) {
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:model.holdCard] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            wself.imageHandle = image;
            if (completion) {
                completion();
            }
        }];
    }

}


- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self);
        RAC(self, imagesAllLoading) = [RACSignal combineLatest:@[RACObserve(self, imageFace), RACObserve(self, imageBack), RACObserve(self, imageHandle)]
                                                        reduce:^id (UIImage* face, UIImage* back, UIImage* handle) {
                                                            @strongify(self);
                                                            return @(face != self.originImgFace && back != self.originImgBack && handle != self.originImgHandle);
        }];
    }
    return self;
}


# pragma mark - getter

- (UIImage *)originImgFace {
    if (!_originImgFace) {
        _originImgFace = [UIImage imageNamed:@"certify_icon_foreground"];
    }
    return _originImgFace;
}
- (UIImage *)originImgBack {
    if (!_originImgBack) {
        _originImgBack = [UIImage imageNamed:@"certify_icon_background"];
    }
    return _originImgBack;
}
- (UIImage *)originImgHandle {
    if (!_originImgHandle) {
        _originImgHandle = [UIImage imageNamed:@"certify_icon_hold"];
    }
    return _originImgHandle;
}
- (UIImage *)demoFace {
    if (!_demoFace) {
        _demoFace = [UIImage imageNamed:@"certify_icon_demo1"];
    }
    return _demoFace;
}
- (UIImage *)demoBack {
    if (!_demoBack) {
        _demoBack = [UIImage imageNamed:@"certify_icon_demo2"];
    }
    return _demoBack;
}
- (UIImage *)demoHandle {
    if (!_demoHandle) {
        _demoHandle = [UIImage imageNamed:@"certify_icon_demo3"];
    }
    return _demoHandle;
}
- (UIImage *)imageFace {
    if (!_imageFace) {
        _imageFace = self.originImgFace;
    }
    return _imageFace;
}
- (UIImage *)imageBack {
    if (!_imageBack) {
        _imageBack = self.originImgBack;
    }
    return _imageBack;
}
- (UIImage *)imageHandle {
    if (!_imageHandle) {
        _imageHandle = self.originImgHandle;
    }
    return _imageHandle;
}

@end

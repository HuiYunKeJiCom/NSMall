//
//  TKImageView.h
//  TKImageDemo
//
//  Created by yinyu on 16/7/10.
//  Copyright © 2016年 yinyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TKCropAreaCornerStyle) {
    TKCropAreaCornerStyleRightAngle,
    TKCropAreaCornerStyleCircle
};
@interface TKImageView : UIView
//需要进行裁剪的图片对象
@property (strong, nonatomic) UIImage *toCropImage;
//是否需要支持缩放裁剪
@property (assign, nonatomic) BOOL needScaleCrop;
//是否显示中间线
@property (assign, nonatomic) BOOL showMidLines;
//是否显示九宫格交叉线
@property (assign, nonatomic) BOOL showCrossLines;
//裁剪区域的宽高比
@property (assign, nonatomic) CGFloat cropAspectRatio;
//裁剪区域边界线颜色
@property (strong, nonatomic) UIColor *cropAreaBorderLineColor;
//裁剪区域边界线宽度
@property (assign, nonatomic) CGFloat cropAreaBorderLineWidth;
//裁剪区域四个角的线条颜色
@property (strong, nonatomic) UIColor *cropAreaCornerLineColor;
//裁剪区域四个角的线条宽度
@property (assign, nonatomic) CGFloat cropAreaCornerLineWidth;
//裁剪区域四个角的宽度
@property (assign, nonatomic) CGFloat cropAreaCornerWidth;
//裁剪区域四个角的高度
@property (assign, nonatomic) CGFloat cropAreaCornerHeight;
//裁剪区域相邻两个角的最小间距
@property (assign, nonatomic) CGFloat minSpace;
//裁剪区域交叉线的宽度
@property (assign, nonatomic) CGFloat cropAreaCrossLineWidth;
//裁剪区域交叉线的颜色
@property (strong, nonatomic) UIColor *cropAreaCrossLineColor;
@property (assign, nonatomic) CGFloat cropAreaMidLineWidth;
@property (assign, nonatomic) CGFloat cropAreaMidLineHeight;
@property (strong, nonatomic) UIColor *cropAreaMidLineColor;
@property (strong, nonatomic) UIColor *maskColor;
@property (assign, nonatomic) BOOL cornerBorderInImage;
@property (assign, nonatomic) CGFloat initialScaleFactor;
- (UIImage *)currentCroppedImage;
@end

//
//  ClipViewController.h
//  Camera
//
//  Created by wzh on 2017/6/6.
//  Copyright © 2017年 wzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClipPhotoDelegate <NSObject>

- (void)clipPhoto:(NSMutableArray *)array andAssetArray:(NSMutableArray *)assetArray;

@end

@interface ClipViewController : UIViewController
@property (strong, nonatomic) UIImage *image;

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, weak) id<ClipPhotoDelegate> delegate;

@property (nonatomic, assign) BOOL isTakePhoto;
@property(nonatomic,strong)NSMutableArray *imageArr;/* 图片数组 */

//typedef void(^arrayBlock)(NSMutableArray *array);
//@property (nonatomic, copy) arrayBlock                   arrayBlock;/* 保存修改的信息回调 */

@end

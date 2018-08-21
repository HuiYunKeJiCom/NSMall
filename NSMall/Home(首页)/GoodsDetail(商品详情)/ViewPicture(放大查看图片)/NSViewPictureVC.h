//
//  NSViewPictureVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSViewPictureVC : UIViewController

@property(nonatomic,strong)NSMutableArray *photoArr;/* 保存图片的数组 */
@property (nonatomic, assign)NSInteger imageTag;/* 图片 tag */

@end

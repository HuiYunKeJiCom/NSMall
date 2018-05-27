//
//  NSAllSortView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

@protocol NSAllSortViewDelegate <NSObject>

@optional

- (void)didClickByButton:(UIButton *)btn andNSArray:(NSArray *)array;

@end

@interface NSAllSortView : UIView
@property(nonatomic,strong)NSArray<CategoryModel*> *dataArr;/* 数据数组 */
@property (assign,nonatomic) id<NSAllSortViewDelegate> tbDelegate;
-(float)getHeight;
@end

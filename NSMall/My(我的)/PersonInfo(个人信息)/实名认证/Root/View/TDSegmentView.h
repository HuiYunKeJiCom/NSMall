//
//  TDSegmentView.h
//  Trade
//
//  Created by FeiFan on 2017/8/30.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDSegmentView : UIView

// 初始化: 指定所有的items标题
- (instancetype) initWithItems:(NSArray<NSString*>*)items;

@property (nonatomic, copy) NSArray* items;

// 高亮色: 橙色
@property (nonatomic, strong) UIColor* selectedColor;

// 默认颜色: 灰色
@property (nonatomic, strong) UIColor* normalColor;

// 当前序号；默认：-1
@property (nonatomic, assign) NSInteger curSelectedIndex;

@end

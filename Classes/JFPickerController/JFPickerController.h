//
//  JFPickerController.h
//  Trade
//
//  Created by FeiFan on 2017/9/11.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFPickerController;

@protocol JFPickerControllerDelegate <NSObject>

// section 个数
- (NSInteger) numberOfSections;

// 指定section的rows个数
- (NSInteger) pickerController:(JFPickerController*)pickerController numberOfRowsInSection:(NSInteger)section;

// 指定索引的title
- (NSString*) pickerController:(JFPickerController*)pickerController titleForRowAtIdexPath:(NSIndexPath*)indexPath;

// 返回选定的索引
- (void) pickerController:(JFPickerController*)pickerController hiddenWithPickedIndexPath:(NSIndexPath*)indexPath;


@end



@interface JFPickerController : UIView

// 显示选择器
- (void) showPicker;
// 隐藏选择器
- (void) hidePicker;

@property (nonatomic, weak) id<JFPickerControllerDelegate> delegate;

// 默认文本色
@property (nonatomic, strong) UIColor* normalTextColor;
// 选中文本色
@property (nonatomic, strong) UIColor* selectedTextColor;
// 文本字体大小
@property (nonatomic, strong) UIFont* textFont;

// vc背景色
@property (nonatomic, strong) UIColor* ctrlBackgroundColor;
// picker背景色
@property (nonatomic, strong) UIColor* pickerViewBackgroundColor;


// pickerView的高度
@property (nonatomic, assign) CGFloat heightOfPickerView;


@end

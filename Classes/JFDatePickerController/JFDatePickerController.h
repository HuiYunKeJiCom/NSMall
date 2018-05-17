//
//  JFDatePickerController.h
//  Trade
//
//  Created by FeiFan on 2017/9/11.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFDatePickerController;

@protocol JFDatePickerControllerDelegate <NSObject>

// 回调:选择了日期
- (void) datePickerCtrl:(JFDatePickerController*)datePickerCtrl hiddenWithSelectedDate:(NSDate*)date;

@end

@interface JFDatePickerController : UIView

@property (nonatomic, weak) id delegate;

- (void) showPicker;
- (void) hidePicker;

@end

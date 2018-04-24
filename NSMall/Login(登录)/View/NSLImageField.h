//
//  ADLImageField.h
//  Lock
//
//  Created by occ on 2017/5/25.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLImageField : UIView

@property (nonatomic, strong) UIImageView       *imgView;

@property (nonatomic, strong) UITextField       *textField;

@property (nonatomic, strong) UIView            *lineView;

@property (nonatomic, readonly, copy) NSString         *text;


- (void)placeholder:(NSString *)place color:(UIColor *)color;

@end

//
//  FFLoadFailView.h
//  EasyLife
//
//  Created by 朱鹏 on 16/7/25.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RequestDataBlock)(void);

@interface FFLoadFailView : UIView

@property (nonatomic, assign) BOOL showButton;

@property (nonatomic, copy) NSString *failureText;

@property (nonatomic, copy) RequestDataBlock requestDataBlock;

//初始化
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end

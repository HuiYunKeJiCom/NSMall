//
//  PageSelectBar.h
//  ScrollView_Nest
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 1911. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageSelectBar : UIView

@property (nonatomic,readonly)NSInteger selectIndex;//当前选中的第几个

- (instancetype)initWithFrame:(CGRect)frame options:(NSArray<NSString *> *)options selectBlock:(void(^)(NSString *option,NSInteger index))callBackBlock;
- (void)setSelected:(NSInteger)index withAction:(BOOL)withAction;//代码调用选中某个状态，withAction参数为是否触发回调


@end

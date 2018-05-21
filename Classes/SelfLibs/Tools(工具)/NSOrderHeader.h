//
//  orderHeader.h
//  YKHXProject
//
//  Created by 杜文全 on 15/11/1.
//  Copyright © 2015年 com.iOSDeveloper.duwenquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSOrderHeader : UIView
//外部决定有多少模块
@property (nonatomic,strong) NSArray * items;

//内部选中某一个模块，传递给外部
@property (nonatomic,copy) void(^itemClickAtIndex)(NSInteger index);

//由外部决定选中哪一个模块
-(void)setSelectAtIndex:(NSInteger)index;
-(void)buttonClick:(UIButton*)button;
@end

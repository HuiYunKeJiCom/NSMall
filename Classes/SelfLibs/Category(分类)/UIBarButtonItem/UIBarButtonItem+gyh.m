//
//  UIBarButtonItem+gyh.m
//  
//
//  Created by gyh on 15-3-9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIBarButtonItem+gyh.h"


@implementation UIBarButtonItem (gyh)



//快速创建一个显示图片的item
+(UIBarButtonItem *)ItemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    if (highIcon) {
     [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];

    }
    button.frame = (CGRect){CGPointZero,button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}



+(UIBarButtonItem *)ItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:233/255.0f green:251/255.0f blue:216/255.0f alpha:1]];
    if ([title isEqualToString:@"会员权益"]||[title isEqualToString:@"选择路线"]) {
        button.frame = (CGRect){CGPointZero,80,20};
    }else{
     button.frame = (CGRect){CGPointZero,40,20};
    }
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithRed:153/255.0f green:215/255.0f blue:121/255.0f alpha:1] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}


+(UIBarButtonItem *)ItemTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = (CGRect){CGPointZero,70,40};
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}



@end

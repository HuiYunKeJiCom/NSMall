//
//  Global.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/1/29.
//  Copyright © 2018年 Adel. All rights reserved.

#ifndef Global_h
#define Global_h

#endif /* Global_h */

#define CurrentHost @"://2008503qw3.51mypc.cn" //锡恩外网接口

//用于替换查找
#define TEMPHost @"://"

#define NetDomainADDR @""

/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;

//屏幕的宽度，屏幕的高度
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

//屏幕宽度相对iPhone6屏幕宽度的比例
#define kWidth_Iphone6_Scale    [UIScreen mainScreen].bounds.size.width/375.0

//根据iphone6尺寸算高度
#define GetScaleWidth(width)  width * kWidth_Iphone6_Scale

//封装了一个宏 用来方便输入文字--实际是文字对应的key
#define KLocalizableStr(key) [(AppDelegate *)[[UIApplication sharedApplication] delegate] showText:(key)]

//错误提示
#define k_requestErrorMessage              @"网络异常，请稍后重试"

#define IMAGE(image)               [UIImage imageNamed:image]

/******************    TabBar          *************/
#define MallClassKey   @"rootVCClassString"
#define MallTitleKey   @"title"
#define MallImgKey     @"imageName"
#define MallSelImgKey  @"selectedImageName"

static inline BOOL IsEmpty(id thing) {
    
    return thing == nil || [thing isEqual:[NSNull null]]
    
    || ([thing respondsToSelector:@selector(length)]
        
        && [(NSData *)thing length] == 0)
    
    || ([thing respondsToSelector:@selector(count)]
        
        && [(NSArray *)thing count] == 0);
}

#define k_UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]


//
//  GlobalColor.h
//  NSMall
//
//  Created by 张锐凌 on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//

#ifndef GlobalColor_h
#define GlobalColor_h


#endif /* GlobalColor_h */

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 全局背景色  灰色
//#define kBACKGROUNDCOLOR [UIColor colorWithHexString:@"#eeeeee"]
// 全局背景色  白色
#define kBACKGROUNDCOLOR [UIColor whiteColor]
#define KColorMainBackground [UIColor blackColor]
//[UIColor blackColor]
// 背景色  淡灰色
#define KBGCOLOR [UIColor colorWithHexString:@"#E0E0E0"]

/** 次红*/
#define KColorTextFBECEE                UIColorFromRGB(0XFBECEE)

#define KColorText333333                UIColorFromRGB(0X333333)
#define KColorTextEFFFFA                UIColorFromRGB(0XEFFFFA)

#define KColorText999999                UIColorFromRGB(0X999999)

#define KColorTextF8FBFA                UIColorFromRGB(0XF8FBFA)
#define KColorTextFFFFFF                UIColorFromRGB(0XFFFFFF)
#define KColorText323232                UIColorFromRGB(0X323232)
#define KColorText878686                UIColorFromRGB(0X878686)
#define KColorTextf4f4f4                UIColorFromRGB(0Xf4f4f4)
#define KColorTexte6e8eb                UIColorFromRGB(0Xe6e8eb)

/** 输入框背景色 */
#define KColorTextF2F4F7                UIColorFromRGB(0XF2F4F7)

/** 错误提示 红 */
#define KColorText0XFC3A06                UIColorFromRGB(0XFC3A06)

/** 切换字体蓝 */
#define KColorText059DAB                UIColorFromRGB(0X059DAB)

/** 登录输入宽未选中字体显示*/
#define KColorTextEBA0A0                UIColorFromRGB(0XEBA0A0)

//色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define kFontNum10                  10
#define kFontNum11                  11
#define kFontNum12                  12
#define kFontNum13                  13
#define kFontNum14                  14
#define kFontNum15                  15
#define kFontNum16                  16
#define kFontNum17                  17

/** 副背景色: 深蓝色 */
#define KColorSubBackground         UIColorFromRGB(0x26263a)
/** 主绿色 */
#define KColorMainGreen             UIColorFromRGB(0x3ba447)

/** 文本色: placeHolder */
#define KColorTextPlaceHolder       UIColorFromRGB(0x8399a8)
/** 文本色: content */
#define KColorTextContent           UIColorFromRGB(0xd6e9fc)
/** 文本色: title */
#define KColorTextTitle             UIColorFromRGB(0xffffff)

#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"
#define PFR20Font [UIFont fontWithName:PFR size:20];
#define PFR18Font [UIFont fontWithName:PFR size:18];
#define PFR16Font [UIFont fontWithName:PFR size:16];
#define PFR15Font [UIFont fontWithName:PFR size:15];
#define PFR14Font [UIFont fontWithName:PFR size:14];
#define PFR13Font [UIFont fontWithName:PFR size:13];
#define PFR12Font [UIFont fontWithName:PFR size:12];
#define PFR11Font [UIFont fontWithName:PFR size:11];
#define PFR10Font [UIFont fontWithName:PFR size:10];
#define PFR9Font [UIFont fontWithName:PFR size:9];
#define PFR8Font [UIFont fontWithName:PFR size:8];

#define VCBackgroundColor kGetColor(238, 238, 238)

#define kGetColor(r,g,b)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

/** 主色调 蓝 */
#define KMainColor UIColorFromRGB(0x0aa1e0)

///** 白色 */
//#define KColorTextFFFFFF5               k_UIColorRGBA(0XFFFFFF,0.5)

#define k_UIColorRGBA(rgbValue,a)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:a]

/**
 *  border颜色
 */
#define LXBorderColor [UIColor colorWithRed:(225)/255.0 green:(225)/255.0 blue:(225)/255.0 alpha:1.0]

// RGB颜色
#define HX_RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


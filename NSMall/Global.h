//
//  Global.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/1/29.
//  Copyright © 2018年 Adel. All rights reserved.

#ifndef Global_h
#define Global_h

#endif /* Global_h */

#define AppWindow [UIApplication sharedApplication].keyWindow
#define AppHeight AppWindow.height
#define AppWidth AppWindow.width
#define AppCenter CGPointMake(AppWidth,AppHeight)

#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度
#define NavBarHeight 44.f //导航栏高度
#define TopBarHeight (StatusBarHeight + NavBarHeight)//总起始高度，使用这个

#define TabBarHeight (((([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)>kCenterTabBarButtonHeight)?([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49):kCenterTabBarButtonHeight) + 2.f) //底部tabbar高度

#define kBlackColor [UIColor blackColor]
#define kWhiteColor [UIColor whiteColor]

#define kRedColor [UIColor redColor]
#define kBlueColor [UIColor blueColor]
#define kClearColor [UIColor clearColor]
#define kGreyColor [UIColor colorWithHex:0x696969]


#define kColorCSS(colorStr) [UIColor colorWithCSS:colorStr]
#define kColorHex(colorHex) [UIColor colorWithHex:colorHex]

#define kGetImage(imgName) [UIImage imageNamed:imgName]

#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]
#define kLoginUserInfoPath [kDocumentPath stringByAppendingPathComponent:@"loginUserInfo.archiver"]


#define adjustsScrollViewInsets(scrollView)\
do{\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while(0)

#define ExpandScrollViewHorizonContentSize(scrollView,horizonMax)\
{\
scrollView.contentSize = CGSizeMake(horizonMax,scrollView.contentSize.height);\
}\

#define ExpandScrollViewVerticalContentSize(scrollView,verticalMax)\
{\
scrollView.contentSize = CGSizeMake(scrollView.contentSize.width,verticalMax);\
}\


#define YYModelEqualImplementation \
- (NSUInteger)hash { return [self yy_modelHash]; }\
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }\
- (NSString *)description { return [self yy_modelDescription]; }\

#define YYModelCodingImplementation \
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }\
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }\
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }\
YYModelEqualImplementation\


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);





#define CurrentHost @"://2008503qw3.51mypc.cn" //锡恩外网接口

//用于替换查找
#define TEMPHost @"://"

//#define NetDomainADDR @""

/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;

//屏幕的宽度，屏幕的高度
//#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
//#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

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

#define kFontSize10                 [UIFont systemFontOfSize:10]
#define kFontSize11                 [UIFont systemFontOfSize:11]
#define kFontSize12                 [UIFont systemFontOfSize:12]
#define kFontSize13                 [UIFont systemFontOfSize:13]
#define kFontSize14                 [UIFont systemFontOfSize:14]
#define kFontSize15                 [UIFont systemFontOfSize:15]
#define kFontSize16                 [UIFont systemFontOfSize:16]
#define kFontSize17                 [UIFont systemFontOfSize:17]

#define Image_Host  [NSString stringWithFormat:@"http%@%@",CurrentHost,@"/adel-admin/images"]

#define Image_Url(url) [NSString stringWithFormat:@"%@%@",Image_Host,url]

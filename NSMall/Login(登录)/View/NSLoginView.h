//
//  NSLoginView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UseLoginType){
    UseLoginTypeLogin = 1,
    UseLoginTypePhone,
    UseLoginTypeRegister,
    UseLoginTypeForget,
    UseLoginTypeWXAuth,
    UseLoginTypeQQAuth,
    UseLoginTypeSinaAuth
};

@class NSLoginView;
@protocol NSLoginViewDelegate <NSObject>

- (void)loginView:(NSLoginView *)logView eventType:(UseLoginType)eventType;

- (void)loginView:(NSLoginView *)logView userName:(NSString *)userName pwd:(NSString *)pwd;


@end

@interface NSLoginView : UIView
@property (nonatomic, weak) id<NSLoginViewDelegate> delegate;
//获取验证码
@property (nonatomic, strong) UIButton       *sendBtn;
@end

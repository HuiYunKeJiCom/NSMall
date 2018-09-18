//
//  NSChatSettingView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/29.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NSChatSettingViewDelegate <NSObject>

@optional

-(void)topSwitchAction:(UISwitch *)topSwitch;

-(void)messageSwitchAction:(UISwitch *)messageSwitch;

@end

@interface NSChatSettingView : UIView
/* 清空 点击回调 */
@property (nonatomic, copy) dispatch_block_t clearBtnClickBlock;

@property (weak,nonatomic) id<NSChatSettingViewDelegate> tbDelegate;
@property(nonatomic,strong)UISwitch *messageSch;/* 消息免打扰 开关 */
@property(nonatomic,strong)UISwitch *topSch;/* 置顶聊天 开关 */
@end

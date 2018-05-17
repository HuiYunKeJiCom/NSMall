//
//  TDUserCertifyDataConfirm.h
//  Trade
//
//  Created by FeiFan on 2017/8/31.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TDUserDertifyConfirmState) {
    TDUserDertifyConfirmStateNone, // 未确认
    TDUserDertifyConfirmStateYes, // 同意
    TDUserDertifyConfirmStateNo // 不同意
};

@interface TDUserCertifyDataConfirm : NSObject

@property (nonatomic, assign) BOOL allConfirmed;

- (NSString*) titleForHeaderView;
- (NSString*) titleForFooterView;

- (NSInteger) numberOfRows;

- (CGFloat) heightForRowAtIndexPath:(NSIndexPath*)indexPath;

- (NSString*) titleForRowAtIndexPath:(NSIndexPath*)indexPath;

- (NSString*) textForRowAtIndexPath:(NSIndexPath*)indexPath;

- (TDUserDertifyConfirmState) confirmStateForRowAtIndexPath:(NSIndexPath*)indexPath;


/**
 更新状态

 @param state 指定状态
 @param indexPath 指定索引
 */
- (void) updateConfirmState:(TDUserDertifyConfirmState)state atIndexPath:(NSIndexPath*)indexPath;


@end

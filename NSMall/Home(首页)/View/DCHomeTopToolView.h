//
//  DCHomeTopToolView.h
//  CDDStoreDemo
//
//  Created by dashen on 2017/11/28.
//Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCHomeTopToolView : UIView

/** 右边Item点击 */
@property (nonatomic, copy) dispatch_block_t rightItemClickBlock;

/** 搜索按钮点击点击 */
@property (nonatomic, copy) dispatch_block_t searchButtonClickBlock;


@end

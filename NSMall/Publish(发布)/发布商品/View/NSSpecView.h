//
//  NSSpecView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSSpecView : UIView

@property (nonatomic, copy) dispatch_block_t deleteClickBlock;/* closeView 点击回调 */
@property(nonatomic,strong)NSMutableDictionary *dataDict;/* 规格字典 */
@end

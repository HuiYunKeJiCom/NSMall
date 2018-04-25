//
//  ADOrderTopToolView.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/2/5.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADOrderTopToolView : UIView
-(void)setTopTitleWithNSString:(NSString *)string;
/* 左边Item */
@property (strong , nonatomic)UIButton *leftItemButton;
/** 左边Item点击 */
@property (nonatomic, copy) dispatch_block_t leftItemClickBlock;
///** 右边Item点击 */
//@property (nonatomic, copy) dispatch_block_t rightItemClickBlock;
@end

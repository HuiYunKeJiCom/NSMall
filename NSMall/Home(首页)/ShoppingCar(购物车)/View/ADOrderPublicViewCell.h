//
//  ADOrderPublicViewCell.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/1.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADOrderPublicViewCell : UICollectionViewCell
/* 设置标题 */
-(void)setTopTitleWithNSString:(NSString *)string;
/* 设置按钮标题 */
-(void)setButtonTitleWithNSString:(NSString *)string;
/* 查看详情 点击回调 */
@property (nonatomic, copy) dispatch_block_t quickBtnClickBlock;
@end

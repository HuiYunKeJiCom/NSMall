//
//  ADReceivingAddressViewCell.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/1.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADAddressModel;
@interface ADReceivingAddressViewCell : UICollectionViewCell
/* 查看详情 点击回调 */
@property (nonatomic, copy) dispatch_block_t detailBtnClickBlock;
/** 地址模型 */
@property (strong,nonatomic)ADAddressModel *addressModel;
@end

//
//  ADCartGoodsListTableViewCell.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/4/11.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZGoodsModel;
@interface ADCartGoodsListTableViewCell : UITableViewCell
///** 商品模型 */
//@property(nonatomic,strong)LZGoodsModel *model;
- (void)reloadDataWithModel:(LZGoodsModel*)model;
@end

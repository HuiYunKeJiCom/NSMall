//
//  ADGoodsListViewCell.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/1.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZShopModel;
@interface ADGoodsListViewCell : UICollectionViewCell
-(void)loadDataWithArray:(NSMutableArray<LZShopModel *> *)dataArray;
@end

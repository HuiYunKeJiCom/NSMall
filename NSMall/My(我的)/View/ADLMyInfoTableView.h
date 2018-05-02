//
//  ADLMyInfoTableView.h
//  Kart
//
//  Created by 朱鹏 on 17/3/9.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "BaseTableView.h"
#import "ADLMyInfoModel.h"

@protocol ADLMyInfoTableViewDelegate <NSObject>

@optional

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@class DCGridItem,ADCenterOrderView;
@interface ADLMyInfoTableView : BaseTableView
@property (strong,nonatomic) ADCenterOrderView *orderView;
/* 数据 */
@property (strong , nonatomic)NSMutableArray<DCGridItem *> *orderItemArray;
@property (strong,nonatomic) NSDictionary *personInfoDic;
@property (assign,nonatomic) id<ADLMyInfoTableViewDelegate> tbDelegate;
@end

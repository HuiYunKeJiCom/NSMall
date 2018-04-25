//
//  NSPersonInfoTableView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/4/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableView.h"
#import "ADLMyInfoModel.h"

@protocol NSPersonInfoTableViewDelegate <NSObject>

@optional

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@class DCGridItem,ADCenterOrderView;
@interface NSPersonInfoTableView : BaseTableView
@property (strong,nonatomic) ADCenterOrderView *orderView;
@property (strong , nonatomic)NSMutableArray<DCGridItem *> *orderItemArray;/* 数据 */
@property (strong,nonatomic) NSDictionary *personInfoDic;
@property (assign,nonatomic) id<NSPersonInfoTableViewDelegate> tbDelegate;
@end

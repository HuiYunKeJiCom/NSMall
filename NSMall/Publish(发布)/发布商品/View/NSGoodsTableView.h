//
//  NSGoodsTableView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/7.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableView.h"

@protocol NSGoodsTableViewDelegate <NSObject>

@optional

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)addSpecViewWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSGoodsTableView : BaseTableView
@property (assign,nonatomic) id<NSGoodsTableViewDelegate> tbDelegate;
@property(nonatomic,strong)NSMutableDictionary *dict;/* 改变高度的字典 */
@end

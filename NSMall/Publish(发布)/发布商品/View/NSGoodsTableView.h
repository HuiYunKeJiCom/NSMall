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

-(void)addSpecView;

@end

@interface NSGoodsTableView : BaseTableView
@property (assign,nonatomic) id<NSGoodsTableViewDelegate> tbDelegate;
@end

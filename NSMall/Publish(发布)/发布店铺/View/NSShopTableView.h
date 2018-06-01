//
//  NSShopTableView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/4.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableView.h"

@protocol NSShopTableViewDelegate <NSObject>

@optional

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSShopTableView : BaseTableView
@property (weak,nonatomic) id<NSShopTableViewDelegate> tbDelegate;
@end

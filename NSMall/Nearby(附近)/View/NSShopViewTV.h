//
//  NSShopViewTV.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/15.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableView.h"

@protocol NSShopViewTVDelegate <NSObject>

@optional

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSShopViewTV : BaseTableView

@property (weak,nonatomic) id<NSShopViewTVDelegate> tbDelegate;

@end

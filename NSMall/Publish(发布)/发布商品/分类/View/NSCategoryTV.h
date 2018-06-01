//
//  NSCategoryTV.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/22.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableView.h"

@protocol NSCategoryTVDelegate <NSObject>

@optional

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSCategoryTV : BaseTableView
@property (weak,nonatomic) id<NSCategoryTVDelegate> tbDelegate;
@end

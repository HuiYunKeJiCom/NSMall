//
//  NSShopVM.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSShopVM : NSObject
@property (nonatomic,readonly)BaseTableView *shopTV;//懒加载使用，外部需要设定frame
- (void)layoutWithProperty:(NSArray *)propertyies;

@end

//
//  NSGoodsVM.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSGoodsVM : NSObject

@property (nonatomic,readonly)BaseTableView *goodsTV;//懒加载使用，外部需要设定frame
- (void)layoutWithProperty:(NSArray *)propertyies;
//-(void)reloadData;
@end

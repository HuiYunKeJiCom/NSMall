//
//  NSGoodsVM.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSGoodsVMDelegate <NSObject>

-(void)didSelectWith:(NSIndexPath *)indexPath;
-(void)likeClickAtIndexPath:(NSIndexPath *)indexPath;
-(void)showGoodsQRCode:(NSIndexPath *)indexPath;

@end

@interface NSGoodsVM : NSObject

@property (nonatomic,readonly)BaseTableView *goodsTV;//懒加载使用，外部需要设定frame
- (void)layoutWithProperty:(NSArray *)propertyies;
//-(void)reloadData;
@property (nonatomic, weak) id<NSGoodsVMDelegate> delegate;
@end

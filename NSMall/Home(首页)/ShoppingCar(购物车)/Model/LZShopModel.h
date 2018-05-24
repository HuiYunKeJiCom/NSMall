//
//  LZShopModel.h
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LZGoodsModel;
@interface LZShopModel : NSObject

@property (assign,nonatomic)BOOL select;
/** 店铺项Id */
@property (copy,nonatomic)NSString *idx;
/** 店铺id */
@property (copy,nonatomic)NSString *store_id;
/** 店铺名称 */
@property (copy,nonatomic)NSString *store_name;
/** 店铺所属人 */
@property (copy,nonatomic)NSString *store_ower;
/** 店铺id */
@property (strong,nonatomic,readonly)NSMutableArray<LZGoodsModel *> *goodsCarts;

//- (void)configGoodsArrayWithArray:(NSArray*)array;
@end

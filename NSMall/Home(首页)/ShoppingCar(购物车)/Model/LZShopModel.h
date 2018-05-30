//
//  LZShopModel.h
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LZGoodsModel;
@interface LZShopModel : NSObject<YYModel>

@property (assign,nonatomic)BOOL select;

@property (copy,nonatomic)NSString *user_id;/* 卖家用户id */
@property (copy,nonatomic)NSString *user_name;/* 卖家昵称 */
@property (copy,nonatomic)NSString *user_avatar;/* 卖家头像路径 */
@property (strong,nonatomic)NSMutableArray <LZGoodsModel *> *productList;

@property (nonatomic)double sum_price;/* 单个商家订单总金额（诺一股）【包含运费】 */
@property (nonatomic)double sum_score;/* 单个商家订单总金额（人民币）【包含运费】 */

@property(nonatomic)float cellHeight;/* cell高度 */
@end

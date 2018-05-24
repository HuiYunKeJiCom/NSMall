//
//  LZGoodsModel.h
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZGoodsModel : NSObject

@property (nonatomic,assign) BOOL select;

/** 商品选购数量 */
@property (assign,nonatomic)NSInteger count;
/** 商品ID */
@property (copy,nonatomic)NSString *goods_id;
/** 商品名称 */
@property (copy,nonatomic)NSString *goods_name;
/** 商品单价 */
@property (copy,nonatomic)NSString *price;
/** 商品规格 */
@property (copy,nonatomic)NSString *spec_info;
///** 商品选购数量 */
//@property (copy,nonatomic)NSString *detail2;
/** 商品主图片路径 */
@property (copy,nonatomic)NSString *goods_image_path;

/** 商品总价 */
@property (copy,nonatomic)NSString *total_price;
/** 商品项ID */
@property (copy,nonatomic)NSString *goodscart_id;
/** 商品状态（0=上架，1=仓库中，-1=已下架，-2=违规下架） */
@property (copy,nonatomic)NSString *goods_status;
/** 商品库存数 */
@property (copy,nonatomic)NSString *goods_inventory;
/** 商品所属店铺id */
@property (copy,nonatomic)NSString *goods_store_id;
@end

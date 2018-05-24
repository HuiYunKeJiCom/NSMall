//
//  ADCartGoodsModel.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/30.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADCartGoodsModel : NSObject
///** 商品id */
//@property (nonatomic, copy) NSString      *idx;
/** 商品项ID */
@property (nonatomic, copy) NSString      *goodscart_id;
/** 商品选购数量 */
@property (nonatomic, copy) NSString      *count;
/** 商品单价 */
@property (nonatomic, copy) NSString      *price;
/** 商品总价 */
@property (nonatomic, copy) NSString      *total_price;
/** 商品规格 */
@property (nonatomic, copy) NSString      *spec_info;
/** 商品ID */
@property (nonatomic, copy) NSString      *goods_id;
/** 商品名称 */
@property (nonatomic, copy) NSString      *goods_name;
/** 商品状态（0=上架，1=仓库中，-1=已下架，-2=违规下架） */
@property (nonatomic, copy) NSString      *goods_status;
/** 商品库存数 */
@property (nonatomic, copy) NSString      *goods_inventory;
/** 商品所属店铺id */
@property (nonatomic, copy) NSString      *goods_store_id;
/** 商品主图片路径 */
@property (nonatomic, copy) NSString      *goods_image_path;
@end

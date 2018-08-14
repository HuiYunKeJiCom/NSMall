//
//  GoodAttrModel.h
//  AiMeiBang
//
//  Created by Lingxiu on 16/2/21.
//  Copyright © 2016年 zym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodAttrModel : NSObject

/** 属性名 */
@property (nonatomic, copy) NSString *attr_name;
/** 属性ID */
@property (nonatomic, copy) NSString *attr_id;
/** 属性 */
@property (nonatomic, copy) NSArray *attr_value;
@property(nonatomic,strong)NSArray *attr_price;/* 价格 */
@property(nonatomic,strong)NSArray *attr_stock;/* 库存 */
@end


@interface GoodAttrValueModel : NSObject

/** 属性值 */
@property (nonatomic, copy) NSString *attr_value;
@property (nonatomic, copy) NSString *attr_price;
@property (nonatomic, copy) NSString *attr_stock;
@end

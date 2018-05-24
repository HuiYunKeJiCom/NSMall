//
//  ADPaymentGoodsModel.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/14.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADPaymentGoodsModel : NSObject
/** id */
@property (nonatomic, copy) NSString      *idx;
/** 商品名 */
@property (nonatomic, copy) NSString      *goodsName;
/** 类型 */
@property (nonatomic, copy) NSString      *type;
/** 描述1 */
@property (nonatomic, copy) NSString      *detail1;
/** 描述2 */
@property (nonatomic, copy) NSString      *detail2;
@end

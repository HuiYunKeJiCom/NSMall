//
//  ADAddressLinkageModel.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/4/3.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADAddressLinkageModel : NSObject
/** 区域ID */
@property (nonatomic, copy) NSString      *idx;
/** 区域名称 */
@property (nonatomic, copy) NSString      *area_name;
/** 父级ID */
@property (nonatomic, copy) NSString      *parent_id;

@property (nonatomic, assign) BOOL  isSelected;
@end

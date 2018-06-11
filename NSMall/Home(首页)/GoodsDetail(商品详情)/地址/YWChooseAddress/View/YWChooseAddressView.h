//
//  YWChooseAddressView.h
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YWFrame.h"

@interface YWChooseAddressView : UIView

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * provinceName;
@property (nonatomic, copy) NSString * cityName;
@property (nonatomic, copy) NSString * districtName;
@property (nonatomic, copy) NSString * streetName;
@property (nonatomic, copy) void(^chooseFinish)(void);

@property (nonatomic,copy) NSString * areaCode;
/** 所属区域ID【省、市ID省略，只需要传县区ID】 */
@property (nonatomic,copy) NSString * provinceId;
@property (nonatomic,copy) NSString * cityId;
@property (nonatomic,copy) NSString * districtId;
@property (nonatomic,copy) NSString * streetId;

@end

//
//  NSChangeParamVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/7.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ADLFilterSelectItem.h"


typedef NS_ENUM(NSInteger, EditUserType) {
    /** 价格*/
    EditUserTypePrice = 1,
    /** 数量*/
    EditUserTypeNumber,
    /** 运费*/
    EditUserTypeFee,
    
    /** 手机*/
    EditUserTypePhone,
    /** 群名称*/
    EditUserTypeGroupName,
};

typedef void(^stringBlock)(NSString *string);

@interface NSChangeParamVC : BaseViewCtrl
@property (nonatomic, copy) NSString  *editTitle;

- (instancetype)initEditType:(EditUserType)type;
@property (nonatomic, copy) stringBlock                   stringBlock;/* 保存修改的信息回调 */
@end


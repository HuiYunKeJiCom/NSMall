//
//  TDNameCertifyModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/16.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDNameCertifyModel : NSObject <NSCopying>

/** 姓名 */
@property (nonatomic, copy) NSString* name;
/** 证件类型(1 身份证) */
@property (nonatomic, copy) NSNumber* idType;
/** 证件号码 */
@property (nonatomic, copy) NSString* idNo;
/** 国家 */
@property (nonatomic, copy) NSString* country;
/** 职业 */
@property (nonatomic, copy) NSString* vocation;
/** 常用地址 */
@property (nonatomic, copy) NSString* commonAddress;
/** 性别(1 男，2女) */
@property (nonatomic, copy) NSNumber* sex;
/** 生日(时间戳) */
@property (nonatomic, copy) NSString* birth;
/** 证件正面照 */
@property (nonatomic, copy) NSString* cardFront;
/** 证件背面照 */
@property (nonatomic, copy) NSString* cardBack;
/** 手持证件照 */
@property (nonatomic, copy) NSString* holdCard;
/** 邮箱 */
@property (nonatomic, copy) NSString* email;
/** 审核状态（1：未审核；2：已审核） */
@property (nonatomic, copy) NSNumber* auditStatus;
/** 审核结果（1：通过；2：打回） */
@property (nonatomic, copy) NSNumber* auditResult;
/** 反馈信息 */
@property (nonatomic, copy) NSString* feedback;

/** 证件正面照 */
@property (nonatomic, copy) UIImage* imageFace;
/** 证件背面照 */
@property (nonatomic, copy) UIImage* imageBack;
/** 手持证件照 */
@property (nonatomic, copy) UIImage* imageHold;

@end

//
//  TDUserCertifyDataBasic.h
//  Trade
//
//  Created by FeiFan on 2017/8/31.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const TDUserCertifyTitleName = @"姓名";
static NSString* const TDUserCertifyTitleCountry = @"国家/地区";
static NSString* const TDUserCertifyTitleIdType = @"证件类型";
static NSString* const TDUserCertifyTitleIdNumber = @"证件号码";
static NSString* const TDUserCertifyTitleSex = @"性别";
static NSString* const TDUserCertifyTitleBirth = @"出生日期";
static NSString* const TDUserCertifyTitleDuty = @"职业";
static NSString* const TDUserCertifyTitleAddr = @"常用地址";


static NSString* const TDUserCertifyCellTypeTxtInputed = @"TDUserCertifyCellTypeTxtInputed"; // 文本输入型
static NSString* const TDUserCertifyCellTypePicker = @"TDUserCertifyCellTypePicker"; // 选择器型

static NSString* const TDUserCertifySexMan = @"男";
static NSString* const TDUserCertifySexWoman = @"女";


@interface TDUserCertifyDataBasicNode : NSObject

+ (instancetype) nodeWithTitle:(NSString*)title identifier:(NSString*)identifier placeHolder:(NSString*)placeHolder value:(id)value;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* cellIdentifier;
@property (nonatomic, copy) NSString* placeHolder;
@property (nonatomic, copy) id value;

@end



@interface TDUserCertifyDataBasic : NSObject


/**
 所有字段都已输入;(用来绑定button的enable属性)
 */
@property (nonatomic, assign) BOOL dataAllInputed;


/**
 dataSource: number of rows
 */
- (NSInteger) numberOfRows;

/**
 dataSource: height for row
 */
- (CGFloat) heightForCellAtRow:(NSInteger)row;

/**
 dataSource: dataNode for row
 */
- (TDUserCertifyDataBasicNode*) dataNodeAtRow:(NSInteger)row;

# pragma mark - update
// 刷新数据源(从源数据重载)
- (void) reloadDatas;
// 更新性别
- (void) updateSexWithValue:(NSNumber*)value;
// 更新出生日期
- (void) updateBirthDayWithValue:(NSDate*)value;

# pragma mark - 提交数据
- (void) commitDatas;

@end

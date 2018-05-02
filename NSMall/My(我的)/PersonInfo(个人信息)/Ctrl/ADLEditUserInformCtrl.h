//
//  ADLEditUserInformCtrl.h
//  Lock
//
//  Created by occ on 2017/5/22.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ADLFilterSelectItem.h"

@class ADLSexSelectView;

typedef NS_ENUM(NSInteger, EditUserType) {
    /** 昵称*/
    EditUserTypeNickName = 1,
    /** 名字*/
    EditUserTypeName,
    /** 用户姓名*/
    EditUserTypeUserName,
    /** 性别*/
    EditUserTypeGender,
    /** 手机*/
    EditUserTypePhone,
    /** 电话*/
    EditUserTypeMobile,
    /** 微信*/
    EditUserTypeWeiXin,
    /** QQ*/
    EditUserTypeQQ,
    /** 微博*/
    EditUserTypeWeibo,
    /** 昵称*/
    EditUserTypeEmail,
};

@interface ADLEditUserInformCtrl : BaseViewCtrl

@property (nonatomic, copy) NSString  *editTitle;


- (instancetype)initEditType:(EditUserType)type;

@end




// ==================================== //

@protocol ADLSexSelectViewDelegate <NSObject>

- (void)sexSelectView:(ADLSexSelectView *)sexSelectView index:(NSInteger)index;

@end

@interface ADLSexSelectView : UIView

@property (nonatomic, weak) id<ADLSexSelectViewDelegate> delegate;

- (void)refreshIndex:(NSInteger)index;
@end


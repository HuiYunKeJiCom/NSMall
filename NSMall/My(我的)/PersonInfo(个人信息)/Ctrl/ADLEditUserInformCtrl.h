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
    /** 实名认证*/
    EditUserTypeCertification,
    /** 性别*/
    EditUserTypeGender,
    /** 手机*/
    EditUserTypePhone,
    /** 收货地址*/
    EditUserTypeAddress,
//    /** 电话*/
//    EditUserTypeMobile,
//    /** 微信*/
//    EditUserTypeWeiXin,
//    /** QQ*/
//    EditUserTypeQQ,
//    /** 微博*/
//    EditUserTypeWeibo,
//    /** 邮箱*/
//    EditUserTypeEmail,
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


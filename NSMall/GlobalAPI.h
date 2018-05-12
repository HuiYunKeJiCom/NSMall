//
//  GlobalAPI.h
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#ifndef GlobalAPI_h
#define GlobalAPI_h

#endif /* GlobalAPI_h */

#define CurrentHost @"://2008503qw3.51mypc.cn" //锡恩外网接口
//用于替换查找
#define TEMPHost @"://"
//Host
#define Host  [NSString stringWithFormat:@"http%@/adel-shop/app/",CurrentHost]

//#define NetDomainADDR @"://2008503qw3.51mypc.cn"
const static NSString * const NetDomainADDR = @"http://adelshop.iok.la:41831/nsshop/app/";

const static NSString * const kLoginAPI = @"login";
const static NSString * const kHomePageProductListAPI = @"productList";//获取首页的商品列表
const static NSString * const kHomePageAdvertListAPI = @"getAdvertByCode";//获取首页的广告信息

const static NSString * const kLogoutAPI = @"auth/logout";//退出登录
const static NSString * const kCatogeryListAPI = @"parentId";//获取分类信息

const static NSString * const kLikeProductAPI = @"likeProduct";//点赞，喜欢接口

const static NSString * const kSearchAPI = @"search";//搜索（商铺或者商品接口）

const static NSString * const kGetInfoAPI = @"auth/getUserInfo";//获取用户信息

const static NSString * const kChangeMobileAPI = @"auth/changeMobile";//更换手机号
const static NSString * const kUpdateUserAPI = @"auth/updateUser";//修改用户信息
const static NSString * const kUploadHeaderAPI = @"auth/uploadAvatar";//上传用户头像
const static NSString * const kUpdatePwdAPI = @"auth/updatePwd";//修改密码
//const static NSString * const kGetInfoAPI = @"auth/getUserInfo";//获取当前用户基本信息
const static NSString * const kCertificationAPI = @"auth/certification";//提交实名认证信息
const static NSString * const kMyProductListAPI = @"auth/myProductList";//获取我的商品列表
const static NSString * const kMyStoreListAPI = @"auth/myStoreList";//获取我的店铺列表
const static NSString * const kCollectProductListAPI = @"auth/collectProductList";//我的收藏商品列表

const static NSString * const kGetVcodeAPI = @"getSmsVerifyCode";//获取短信验证码
const static NSString * const kGetLabelsAPI = @"getLabels";//获取标签列表
const static NSString * const kSaveLabelsAPI = @"auth/saveLabel";//新增标签

const static NSString * const kGetAreaAPI = @"getArea";//获取省市区数据
const static NSString * const kGetAddressAPI = @"auth/getAddress";//获取收货地址
const static NSString * const kSaveAddressAPI = @"auth/saveAddress";//新增/编辑收货地址
const static NSString * const kSetDefaultAddressAPI = @"auth/setDefaultAddress";//设置默认收货地址
const static NSString * const kDelAddressAPI = @"auth/delAddress";//删除收货地址

const static NSString * const kCategoryAPI = @"category";//获取商品分类













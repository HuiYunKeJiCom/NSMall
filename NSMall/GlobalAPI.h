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
const static NSString * const kGetInfoAPI = @"auth/getUserInfo";//获取用户信息
const static NSString * const kChangeMobileAPI = @"auth/changeMobile";//更换手机号
const static NSString * const kGetVcodeAPI = @"getSmsVerifyCode";//获取短信验证码
const static NSString * const kUploadHeaderAPI = @"auth/uploadAvatar";//上传用户头像


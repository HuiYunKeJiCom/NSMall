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

//#define CurrentHost @"://2008503qw3.51mypc.cn" //锡恩外网接口
//用于替换查找
#define TEMPHost @"://"
//Host
#define Host  [NSString stringWithFormat:@"http%@/adel-shop/app/",CurrentHost]

//#define NetDomainADDR @"://2008503qw3.51mypc.cn"
//const static NSString * const NetDomainADDR = @"http://adelshop.iok.la:41831/nsshop/app/";

const static NSString * const NetDomainADDR = @"https://stagewww.neublockchain.com/nsshop/app/";//国外测试环境
//const static NSString * const NetDomainADDR = @"https://ns.neublockchain.com/nsshop/app/";// 生产环境

const static NSString * const kLoginAPI = @"login";
const static NSString * const kHomePageProductListAPI = @"productList";//获取首页的商品列表
const static NSString * const kHomePageAdvertListAPI = @"getAdvertByCode";//获取首页的广告信息

const static NSString * const kLogoutAPI = @"auth/logout";//退出登录
const static NSString * const kCatogeryListAPI = @"category";//获取分类信息

const static NSString * const kLikeProductAPI = @"auth/likeProduct";//点赞，喜欢接口

const static NSString * const kGetInfoAPI = @"auth/getUserInfo";//获取用户信息
const static NSString * const kGetUserAPI = @"getUserById";//获取用户信息


//我的页面
const static NSString * const kChangeMobileAPI = @"auth/changeMobile";//更换手机号
const static NSString * const kUpdateUserAPI = @"auth/updateUser";//修改用户信息
const static NSString * const kUploadHeaderAPI = @"auth/uploadAvatar";//上传用户头像
const static NSString * const kUpdatePwdAPI = @"auth/updatePwd";//修改密码
//const static NSString * const kGetInfoAPI = @"auth/getUserInfo";//获取当前用户基本信息
const static NSString * const kUploadIDCardAPI = @"auth/uploadIDCardImage";//上传身份证照片
const static NSString * const kCertificationAPI = @"auth/certification";//提交实名认证信息
const static NSString * const kMyProductListAPI = @"auth/myProductList";//获取我的商品列表
const static NSString * const kMyStoreListAPI = @"auth/myStoreList";//获取我的店铺列表

const static NSString * const kCollectionListAPI = @"auth/collectProductList";//我的收藏商品列表
const static NSString * const kOrderListAPI = @"auth/orderList";//我的订单列表

//我的店铺
const static NSString * const kRemoveStoreAPI = @"auth/removeStore";//删除店铺

const static NSString * const kGetVcodeAPI = @"getSmsVerifyCode";//获取短信验证码
const static NSString * const kGetLabelsAPI = @"getLabels";//获取标签列表
const static NSString * const kSaveLabelsAPI = @"auth/saveLabel";//新增标签

const static NSString * const kGetAreaAPI = @"getArea";//获取省市区数据
const static NSString * const kGetAddressAPI = @"auth/getAddress";//获取收货地址
const static NSString * const kSaveAddressAPI = @"auth/saveAddress";//新增/编辑收货地址
const static NSString * const kSetDefaultAddressAPI = @"auth/setDefaultAddress";//设置默认收货地址
const static NSString * const kDelAddressAPI = @"auth/delAddress";//删除收货地址

const static NSString * const kCategoryAPI = @"category";//获取商品分类

//商品发布
const static NSString * const kCreateProductAPI = @"auth/createProduct";//商品发布
const static NSString * const kUploadProductImageAPI = @"auth/uploadProductImage";//商品图片上传
const static NSString * const kShelveProductAPI = @"auth/shelveProduct";//上/下架商品

//店铺发布
const static NSString * const kCreateStoreAPI = @"auth/createStore";//店铺发布
const static NSString * const kUploadStoreImageAPI = @"auth/uploadStoreImage";//店铺图片上传


//商品详情
const static NSString * const kProductDetailAPI = @"productDetail";//获取商品详情
const static NSString * const kGetCheckDataAPI = @"auth/getCheckData";//获取立即购买页面数据
const static NSString * const kBuildOrderNowAPI = @"auth/buildOrder";//立即购买提交订单

const static NSString * const kSearchAPI = @"search";//商品/店铺搜索、分类商品列表、卖家商品/店铺列表

const static NSString * const kCollectProductAPI = @"auth/collectProduct";//收藏/取消收藏商品

//购物车
const static NSString * const kAddCartAPI = @"auth/addCart";//添加商品到购物车
const static NSString * const kUpdateCartCountAPI = @"auth/updateCartCount";//修改购物车商品数量
const static NSString * const kCartListAPI = @"auth/cartList";//获取购物车列表
const static NSString * const kRemoveCartAPI = @"auth/removeCart";//删除购物车商品
const static NSString * const kGetCartCheckDataAPI = @"auth/getCartCheckData";//获取购物车结算页面数据
const static NSString * const kBuildOrderAPI = @"auth/buildOrderOfCart";//购物车提交订单
const static NSString * const kPayOrderAPI = @"auth/payOrder";//订单支付

//钱包
const static NSString * const kWalletListAPI = @"auth/walletList";//获取已绑定的钱包列表
const static NSString * const kBindWalletAPI = @"auth/bindWallet";//绑定钱包
const static NSString * const kSetWalletAPI = @"auth/setSellWallet";//设置默认收款钱包

//附近
const static NSString * const kNearbyStoreAPI = @"nearbyStore";//获取附近店铺列表

//
const static NSString * const kOrderDetailAPI = @"auth/orderDetail";//订单详情

//收款记录
const static NSString * const kTradeLogAPI = @"auth/tradeLog";//收款记录

//商品评论
const static NSString * const kProductCommentAPI = @"productComment";//获取商品评论列表
const static NSString * const kRemoveCommentAPI = @"auth/removeComment";//删除商品评论
const static NSString * const kPublishCommentAPI = @"auth/publishComment";//发布商品评论

//检测APP版本
const static NSString * const kAppVersionAPI = @"getAppVersion";//检测APP版本





//
//  NSCreateQRCode.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/5.
//  Copyright © 2018年 www. All rights reserved.
//

#import "DCBaseSetViewController.h"

@interface NSCreateQRCodeVC : DCBaseSetViewController
typedef NS_ENUM(NSInteger, QRCodeType){
    QRCodeTypePerson = 1,
    QRCodeTypeGoods,
    QRCodeTypeShop,
    QRCodeTypePaymePnt,
};

//@property(nonatomic,copy)NSString *QRString;/* 字符串 */
@end

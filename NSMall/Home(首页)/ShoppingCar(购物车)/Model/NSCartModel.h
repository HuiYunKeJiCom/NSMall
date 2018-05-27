//
//  NSCartModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/27.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZShopModel.h"

@interface NSCartModel : NSObject<YYModel>
@property (strong,nonatomic,readonly)NSMutableArray<LZShopModel *> *result;
@end

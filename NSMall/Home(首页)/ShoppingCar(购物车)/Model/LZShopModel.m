//
//  LZShopModel.m
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZShopModel.h"
#import "LZGoodsModel.h"

@implementation LZShopModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idx": @"id"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"goodsCarts" : @"LZGoodsModel"
             };
}

//- (void)configGoodsArrayWithArray:(NSArray*)array; {
//    if (array.count > 0) {
//        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
//        for (NSDictionary *dic in array) {
//            LZGoodsModel *model = [[LZGoodsModel alloc]init];
//            
//            model.count = [[dic objectForKey:@"count"] integerValue];
//            model.goods_id = [dic objectForKey:@"goods_id"];
//            model.goods_name = [dic objectForKey:@"goods_name"];
//            model.price = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
//            model.spec_info = [dic objectForKey:@"spec_info"];
//            model.total_price = [dic objectForKey:@"total_price"];
//            [dataArray addObject:model];
//        }
//        
//        _goodsCarts = [dataArray mutableCopy];
//    }
//}
@end

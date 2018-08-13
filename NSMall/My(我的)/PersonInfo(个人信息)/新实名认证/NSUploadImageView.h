//
//  NSUploadImageView.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSUploadImageView : UIView
@property(nonatomic,strong)UILabel *tipLab;/* 提示语 */
@property(nonatomic,strong)UIImageView *addIV;/* 加号 */
@property(nonatomic,strong)UIImageView *uploadImage;/* 上传图片 */
-(void)setUpWith:(NSString *)tip andImageName:(NSString *)name;

/* 红包 点击回调 */
@property (nonatomic, copy) dispatch_block_t addBtnClickBlock;
@end

//
//  NSClusterAnnotationView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSClusterAnnotationView.h"

@interface NSClusterAnnotationView()
@property (nonatomic, strong) UILabel *pharmacyLabel;
@property (nonatomic, strong)UIImageView *labelIV;
@end

@implementation NSClusterAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _labelIV = [[UIImageView alloc] init];
        _labelIV.alpha = 0.9;
        [self addSubview:_labelIV];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.alpha = 0.9;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *imageViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)];
        // 2. 将点击事件添加到imageView上
        [_imageView addGestureRecognizer:imageViewTapGestureRecognizer];
        _imageView.userInteractionEnabled = YES; // 可以理解为设置imageView可被点击
        //        self.userInteractionEnabled = YES;
        
        _pharmacyLabel = [[UILabel alloc] init];
        _pharmacyLabel.textColor = [UIColor whiteColor];
        _pharmacyLabel.font = [UIFont systemFontOfSize:13];
        _pharmacyLabel.textAlignment = NSTextAlignmentCenter;
        _pharmacyLabel.numberOfLines = 0;
        [_labelIV addSubview:_pharmacyLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize imageSize = [self contentSizeWithTitle:self.storeModel.name andFont:13];
    _imageView.frame = CGRectMake(imageSize.width*0.5 -20, -60-5+100, 60,60 );
//    _imageView.layer.cornerRadius = 45;
//    _imageView.layer.masksToBounds = YES;
    
    _labelIV.frame = CGRectMake(2.5, 100, imageSize.width + 15,imageSize.height );
    _labelIV.layer.cornerRadius = imageSize.height/2;
    //    将多余的部分切掉
    _labelIV.layer.masksToBounds = YES;
    _pharmacyLabel.frame = CGRectMake(7.5, 0, imageSize.width ,imageSize.height);
    
    _labelIV.backgroundColor = UIColorFromRGB(0x0aa1e0);
//    _imageView.backgroundColor = [UIColor redColor];
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

- (void)imageViewClick {
        NSLog(@"点击图片");
    if ([self.delegate respondsToSelector:@selector(showShopInfoViewWithClusterAnnotationView: clusterAnnotationView:)]) {
        [self.delegate showShopInfoViewWithClusterAnnotationView:_storeModel  clusterAnnotationView:self];
    }
}

-(void)setStoreModel:(NSStoreModel *)storeModel{
    _storeModel = storeModel;
    self.pharmacyLabel.text = storeModel.name;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:storeModel.storeImageList[0]]];
//    DLog(@"storeModel.store_imge = %@",storeModel.store_imge);

}

- (void)setSize:(NSInteger)size {
    _size = size;
    _imageView.hidden = NO;
    _labelIV.hidden = NO;
    _pharmacyLabel.hidden = NO;
//    _pharmacyLabel.text = _title;
}

@end

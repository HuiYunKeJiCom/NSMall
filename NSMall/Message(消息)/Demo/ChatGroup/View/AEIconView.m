//
//  AEIconView.m
//  微信群9宫格头像
//
//  Created by carshoel on 16/11/3.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "AEIconView.h"
#import "UIImageView+WebCache.h"

//定义一个全局默认展位图
#define kHead [UIImage imageNamed:@"group_header"]



@implementation AEIconView

//检验字符串
- (BOOL)checkStr:(NSString *)str{
    if(![str isKindOfClass:[NSString class]])return NO;
    if(!str)return NO;
    return  YES;
}

//创建一个图片view
- (void)viewWithImage:(NSString *)url fram:(CGRect)frame{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:frame];
    imageV.layer.borderWidth = 1;
    imageV.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:imageV];
    [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kHead];
}

-(void)setImage:(UIImage *)image{
    _image = image;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
    imageV.image = image;
    [self addSubview:imageV];
}

-(void)setImages:(NSArray<NSString *> *)images{
    
    //删除旧的图片
    for (UIView *view  in self.subviews) {
        [view removeFromSuperview];
    }
    
    switch (images.count) {
        case 1:
            [self oneCount:images.firstObject];
            break;
        case 2:
            [self twoCount:images];
            break;
        case 3:
            [self threeCount:images];
            break;
        case 4:
            [self fourCount:images];
            break;
        case 5:
            [self fiveCount:images];
            break;
        case 6:
            [self sixCount:images];
            break;
        case 7:
            [self sevenCount:images];
            break;
        case 8:
            [self eightCount:images];
            break;
        case 9:
            [self nineCount:images];
            break;
            
        default:
            break;
    }
    
}

//1张图
- (void)oneCount:(NSString *)url{
    if(![self checkStr:url])return;
    [self viewWithImage:url fram:self.bounds];
}

//2张图
- (void)twoCount:(NSArray *)urls{
    CGFloat spaceX = 2;
    CGFloat w = (CGRectGetWidth(self.bounds)-spaceX) * 0.5;
    CGFloat x = 0;
    CGFloat y = (CGRectGetHeight(self.bounds)-w) * 0.5;
    NSString *url  = nil;
    for (int i = 0; i < urls.count;i++) {
        x = i * (w+spaceX);
        url = urls[i];
        if(![self checkStr:url])return;
        [self viewWithImage:url fram:CGRectMake(x, y, w, w)];
    }
}

//3张图
- (void)threeCount:(NSArray *)urls{
    CGFloat spaceX = 2;
    CGFloat spaceY = 2;
    CGFloat w = (CGRectGetWidth(self.bounds)-spaceX) * 0.5;
    CGFloat x = (CGRectGetWidth(self.bounds) - w) * 0.5;
    CGFloat y = 0;
    NSString *url  = nil;
    for (int i = 0; i < urls.count;i++) {
        if(i){
            y = w+spaceY;
            x = (i - 1) * (w+spaceX);
        }
        url = urls[i];
        if(![self checkStr:url])return;
        [self viewWithImage:url fram:CGRectMake(x, y, w, w)];
    }
}

//4张图
- (void)fourCount:(NSArray *)urls{
    CGFloat spaceX = 2;
    CGFloat spaceY = 2;
    CGFloat w = (CGRectGetWidth(self.bounds)-spaceX) * 0.5;
    CGFloat x = 0;
    CGFloat y = 0;
    NSString *url  = nil;
    for (int i = 0; i < urls.count;i++) {
        x = (i % 2) * (w+spaceX);
        y = (i / 2) * (w+spaceY);
        url = urls[i];
        if(![self checkStr:url])return;
        [self viewWithImage:url fram:CGRectMake(x, y, w, w)];
    }
}

//5张图
- (void)fiveCount:(NSArray *)urls{
    CGFloat spaceX = 2;
    CGFloat spaceY = 2;
    CGFloat w = (CGRectGetWidth(self.bounds)-spaceX) / 3;
    CGFloat x = 0;
    CGFloat y = (CGRectGetHeight(self.bounds)-2*w-spaceY) * 0.5;
    NSString *url  = nil;
    for (int i = 0; i < urls.count;i++) {
        if(i < 2){
            x = (CGRectGetWidth(self.bounds) - spaceX-2*w) * 0.5 + (w+spaceX) * i;
        }else{
            y = (CGRectGetHeight(self.bounds)+spaceY) * 0.5;
            x = (w+spaceX) * (i -2);
        }
        url = urls[i];
        if(![self checkStr:url])return;
        [self viewWithImage:url fram:CGRectMake(x, y, w, w)];
    }
}

//6张图
- (void)sixCount:(NSArray *)urls{
    CGFloat w = CGRectGetWidth(self.bounds) / 3;
    CGFloat x = 0;
    CGFloat y = w * 0.5;
    NSString *url  = nil;
    for (int i = 0; i < urls.count;i++) {
        x = (i % 3) * w;
        y = (i / 3) * w + w * 0.5;
        url = urls[i];
        if(![self checkStr:url])return;
        [self viewWithImage:url fram:CGRectMake(x, y, w, w)];
    }
}

//7张图
- (void)sevenCount:(NSArray *)urls{
    CGFloat w = CGRectGetWidth(self.bounds) / 3;
    CGFloat x = 0;
    CGFloat y = 0;
    NSString *url  = nil;
    for (int i = 0; i < urls.count;i++) {
        if(i){
            x = ((i - 1) % 3) * w;
            y = ((i - 1) / 3) * w + w;
        }else{
            x = w;
        }
        url = urls[i];
        if(![self checkStr:url])return;
        [self viewWithImage:url fram:CGRectMake(x, y, w, w)];
    }
}

//8张图
- (void)eightCount:(NSArray *)urls{
    CGFloat w = CGRectGetWidth(self.bounds) / 3;
    CGFloat x = 0;
    CGFloat y = 0;
    NSString *url  = nil;
    for (int i = 0; i < urls.count;i++) {
        if(i > 1){
            x = ((i - 2) % 3) * w;
            y = ((i - 2) / 3) * w + w;
        }else{
            x = w * 0.5 + w * i;
        }
        url = urls[i];
        if(![self checkStr:url])return;
        [self viewWithImage:url fram:CGRectMake(x, y, w, w)];
    }
}

//9张图
- (void)nineCount:(NSArray *)urls{
    CGFloat w = CGRectGetWidth(self.bounds) / 3;
    CGFloat x = 0;
    CGFloat y = 0;
    NSString *url  = nil;
    for (int i = 0; i < urls.count;i++) {
        
        x = (i % 3) * w;
        y = (i / 3) * w;
        
        url = urls[i];
        if(![self checkStr:url])return;
        [self viewWithImage:url fram:CGRectMake(x, y, w, w)];
    }
}

@end

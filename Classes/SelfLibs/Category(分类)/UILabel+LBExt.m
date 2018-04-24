//
//  UILabel+LBExt.m
//  EasyLife
//
//  Created by DingJian on 16/3/14.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import "UILabel+LBExt.h"

@implementation UILabel (LBExt)


-(id)initWithFrame:(CGRect)frame FontSize:(CGFloat)size
{
    self = [[UILabel alloc]initWithFrame:frame];
    self.font = [UIFont systemFontOfSize:size];
    self.textColor = [UIColor blackColor];
    return self;
}

-(id)initWithFrame:(CGRect)frame FontSize:(CGFloat)size TextColor:(UIColor *)color
{
    self = [[UILabel alloc]initWithFrame:frame];
    self.font = [UIFont systemFontOfSize:size];
    self.textColor = color;
    return self;
}

-(id)initWithFrame:(CGRect)frame FontSize:(CGFloat)size TextColor:(UIColor *)color text:(NSString *)text {
    self = [[UILabel alloc]initWithFrame:frame];
    self.font = [UIFont systemFontOfSize:size];
    self.textColor = color;
    self.text = text;
    return self;
}

- (void)setRadiusSize:(CGFloat)radiusSize {
    
    if (self.layer.cornerRadius != radiusSize) {
        self.layer.cornerRadius = radiusSize;
        self.layer.masksToBounds = YES;
    }
}

@end


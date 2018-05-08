//
//  DCTabBarCenterButton.m
//  NSMall
//
//  Created by apple on 2018/4/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import "DCTabBarCenterButton.h"
#import "XWPopMenuController.h"

@implementation DCTabBarCenterButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (id)plusButton{
    DCTabBarCenterButton *centerBtn = [DCTabBarCenterButton buttonWithType:UIButtonTypeCustom];
    centerBtn.size = CGSizeMake(GetScaleWidth(55),GetScaleWidth(55));
    [centerBtn setTitle:@"发布" forState:UIControlStateNormal];
    [centerBtn setTitleColor:UIColorFromRGB(0xd2d2d2) forState:UIControlStateNormal];
    [centerBtn addTarget:centerBtn action:@selector(centerBtnWasClicked:) forControlEvents:UIControlEventTouchDown];
    return centerBtn;
}

- (void)centerBtnWasClicked:(id)sender{
    DLog(@"点击了中央按钮，什么都没做");
    
    XWPopMenuController *vc = [[XWPopMenuController alloc]init];
    //虚化背景
    UIImage *image = [UIImage imageWithCaputureView:[DCTabBarController sharedTabBarVC].view];
    
    vc.backImg = image;
    [[DCTabBarController sharedTabBarVC] presentViewController:vc animated:YES completion:nil];
}

- (void)layoutSubviews{
    self.imageView.frame = CGRectMake(0, -GetScaleWidth(18), GetScaleWidth(55), GetScaleWidth(55));
    self.imageView.image = [UIImage imageNamed:@"main_ico_add"];
    self.titleLabel.frame = CGRectMake(-GetScaleWidth(10), GetScaleWidth(42), 80, 14);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:11];
}


@end

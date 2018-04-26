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
    centerBtn.size = CGSizeMake(80,94);
    [centerBtn setTitle:@"发布" forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [centerBtn addTarget:centerBtn action:@selector(centerBtnWasClicked:) forControlEvents:UIControlEventTouchDown];
    return centerBtn;
}

- (void)centerBtnWasClicked:(id)sender{
    DLog(@"点击了中央按钮，什么都没做");
    
    XWPopMenuController *vc = [[XWPopMenuController alloc]init];
    
    [[DCTabBarController sharedTabBarVC] presentViewController:vc animated:YES completion:nil];
}

- (void)layoutSubviews{
    self.imageView.frame = CGRectMake(0, 0, 80, 80);
    self.imageView.image = [UIImage imageNamed:@"main_ico_add"];
    self.titleLabel.frame = CGRectMake(0, 80, 80, 14);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:11];
}


@end

//
//  NSViewPictureVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSViewPictureVC.h"

@interface NSViewPictureVC ()
{
    CGFloat lastScale;
    CGRect oldFrame;    //保存图片原来的大小
    CGRect largeFrame;  //确定图片放大最大的程度
}
@end

@implementation NSViewPictureVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    oldFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    largeFrame = CGRectMake(0 , 0, 2 * oldFrame.size.width, 2 * oldFrame.size.height);
    
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    myScrollView.backgroundColor = [UIColor blackColor];
    myScrollView.pagingEnabled = YES;
    myScrollView.bounces = NO;
    
    [self.view addSubview:myScrollView];
    //根据tag 来获取当前点击的图片
    myScrollView.contentOffset = CGPointMake(self.view.frame.size.width * self.imageTag, 10);
    
    myScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.photoArr.count, 0);
    //创建
    for (int i = 0; i < self.photoArr.count; i++)
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * i + 10, 0, self.view.frame.size.width - 20, self.view.frame.size.height)];
        NSString *imgName = self.photoArr[i];
        [img sd_setImageWithURL:[NSURL URLWithString:imgName]];
        
        [myScrollView addSubview:img];
        img.userInteractionEnabled = YES;
        

//        // 缩放手势
//        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
//        [img addGestureRecognizer:pinchGestureRecognizer];
//
//        // 移动手势
//        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//        [img addGestureRecognizer:panGestureRecognizer];

        
        //自适应图片大小
        img.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    
    //轻拍跳出照片浏览
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    [myScrollView addGestureRecognizer:tap];
    
}

- (void)tapAction
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        if (pinchGestureRecognizer.view.frame.size.width < oldFrame.size.width) {
            pinchGestureRecognizer.view.frame = CGRectMake(pinchGestureRecognizer.view.tag*kScreenWidth, 0, oldFrame.size.width, oldFrame.size.height);
            //让图片无法缩得比原图小
        }
        if (pinchGestureRecognizer.view.frame.size.width > 2 * oldFrame.size.width) {
            pinchGestureRecognizer.view.frame = largeFrame;
        }
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }

}

@end

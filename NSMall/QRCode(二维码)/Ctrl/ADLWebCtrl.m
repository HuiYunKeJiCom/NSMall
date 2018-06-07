//
//  ADLWebCtrl.m
//  Lock
//
//  Created by occ on 2017/5/26.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ADLWebCtrl.h"
#import <WebKit/WebKit.h>

@interface ADLWebCtrl ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *viewConnectionFail;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation ADLWebCtrl

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString limitStringNotEmpty:self.url];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    [self makeConstraints];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter / setter

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _progressView.progressTintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}

- (WKWebView *)webView {
    if (!_webView) {
        
        //1.创建WKWebView
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
        //2.创建URL
        NSURL *URL = [NSURL URLWithString:self.url];
        //3.创建Request
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        //4.加载Request
        [_webView loadRequest:request];
        //5.添加到视图
    }
    return _webView;
}

- (UIView *)viewConnectionFail{
    if (!_viewConnectionFail) {
        _viewConnectionFail = [[UIView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 24)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = KColorTexte6e8eb;
        label.text = k_requestErrorMessage;
        [_viewConnectionFail addSubview:label];
    }
    return _viewConnectionFail;
}


#pragma mark - makeConstraints

- (void)makeConstraints {
    WEAKSELF
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(weakSelf.view);
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = YES;
    self.title = self.webView.title;

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = YES;
    [self.view addSubview:self.viewConnectionFail];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end

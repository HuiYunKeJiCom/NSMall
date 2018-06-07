//
//  GPLoadingView.m
//  GPLoadingView
//

#import "GPLoadingView.h"

#define ANGLE(a) 2*M_PI/360*a


#define k_UIColorFromRGBLoad(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define k_color_Loading 0Xff6b13

@interface GPLoadingView ()



@end

@implementation GPLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        
//        _activityIndView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
////        _activityIndView.tintColor = [UIColor orangeColor];
//        _activityIndView.frame = CGRectMake(0, 0 , 30*KWidth_Scale, 20*KWidth_Scale);
//        [_activityIndView startAnimating];
//        [self addSubview:_activityIndView];
//        
//        _messageLab = [[UILabel alloc] initWithFrame:CGRectMake(31*KWidth_Scale, 0, 100*KWidth_Scale, 20*KWidth_Scale)];
//        _messageLab.backgroundColor = [UIColor clearColor];
//        _messageLab.textColor = [UIColor lightGrayColor];
//        _messageLab.text = @"正在努力加载中....";
//        _messageLab.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_messageLab];
        
        
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        CGRect temp = frame;
        temp.origin.x = (kScreenWidth - 80) / 2.0;
        temp.size.width = 80;
        temp.size.height = 80;
        self.frame = temp;
        self.layer.cornerRadius = 5;
        
        
        _activityIndView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndView.frame = CGRectMake(15, 10 , 50, 40);
        [_activityIndView startAnimating];
        [self addSubview:_activityIndView];
        
        _messageLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 80, 30)];
        _messageLab.textColor = [UIColor whiteColor];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.text = [NSString stringWithFormat:@"%@...",KLocalizableStr(@"加载中")];
        _messageLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:_messageLab];
    }
    return self;
}

- (void)setLoadType:(BOOL)loadType {
    _loadType = loadType;
    if (_loadType) {
        _messageLab.text = [NSString stringWithFormat:@"%@...",KLocalizableStr(@"加载中")];
    }
}

- (void)setCommitType:(BOOL)commitType {
    _commitType = commitType;
    if (_commitType) {
        _messageLab.text = [NSString stringWithFormat:@"%@...",KLocalizableStr(@"提交中")];
    }
}

- (id)initWithSubFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        CGRect temp = frame;
        temp.origin.x = (frame.size.width - 80) / 2.0 + frame.origin.x;
        temp.size.width = 80;
        temp.size.height = 80;
        self.frame = temp;
        self.layer.cornerRadius = 5;
        
        
        _activityIndView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndView.frame = CGRectMake(15, 10 , 50, 40);
        [_activityIndView startAnimating];
        [self addSubview:_activityIndView];
        
        _messageLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 80, 30)];
        _messageLab.textColor = [UIColor whiteColor];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.text = [NSString stringWithFormat:@"%@...",KLocalizableStr(@"加载中")];
        _messageLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:_messageLab];
    }
    return self;
}

- (void)startAnimation
{

    if (_activityIndView) {
        [_activityIndView stopAnimating];
    }
}

- (void)stopAnimation
{
    if (_activityIndView) {
        [_activityIndView startAnimating];
    }
}

@end

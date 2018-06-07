//
//  GPLoadingView.h
//  GPLoadingView
//

#import <UIKit/UIKit.h>

@interface GPLoadingView : UIControl

@property (nonatomic, strong) UILabel                    *messageLab;
@property (nonatomic, strong) UIActivityIndicatorView    *activityIndView;

@property (nonatomic, readonly) BOOL isAnimating;
@property (nonatomic, assign) BOOL loadType;
@property (nonatomic, assign) BOOL commitType;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithSubFrame:(CGRect)frame;

- (void)startAnimation;
- (void)stopAnimation;
@end

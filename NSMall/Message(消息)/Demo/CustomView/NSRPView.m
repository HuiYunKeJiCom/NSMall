//
//  NSRPView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSRPView.h"

@interface NSRPView()
@property(nonatomic,strong)UIImageView *bgIV;/* 背景图 */
@property(nonatomic,strong)UIImageView *avatarView;/* 头像 */
@property(nonatomic,strong)UILabel *userLab;/* 昵称 */
@property(nonatomic,strong)UILabel *tipLab;/* 提示文字 */
@property(nonatomic,strong)UILabel *messageLab;/* 留言 */
@property(nonatomic,strong)UIButton *openBtn;/* 开红包按钮 */
@end

@implementation NSRPView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5];
        
        [self setupBasicView];
//        [self setUpData];
        [self makeConstraints];
    }
    return self;
}

-(void)setupBasicView{
    [self addSubview:self.bgIV];
    [self addSubview:self.avatarView];
    [self addSubview:self.userLab];
    [self addSubview:self.tipLab];
    [self addSubview:self.messageLab];
    [self addSubview:self.openBtn];
    
    UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [self addGestureRecognizer:tapBackGesture];
    
    // 添加手势，遮盖整个视图的手势，
    UITapGestureRecognizer *contentViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [self.bgIV addGestureRecognizer:contentViewTapGesture];
}

-(void)setUpDataWith:(NSDictionary *)dict{
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"avatar_url"]]];
    self.userLab.text = [dict objectForKey:@"nick"];
    self.tipLab.text = @"给你发了个红包";
    self.messageLab.text = [dict objectForKey:@"rp_leave_msg"];
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-80, 240));
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.mas_top).with.offset(165);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.userLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgIV.mas_centerX);
        make.top.equalTo(weakSelf.avatarView.mas_bottom).with.offset(15);
    }];
    
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgIV.mas_centerX);
        make.top.equalTo(weakSelf.userLab.mas_bottom).with.offset(5);
    }];
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgIV.mas_centerX);
        make.top.equalTo(weakSelf.tipLab.mas_bottom).with.offset(40);
    }];
    
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.messageLab.mas_bottom).with.offset(43);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

-(UIImageView *)bgIV{
    if (!_bgIV) {
        _bgIV = [[UIImageView alloc] init];
//        [_bgIV setBackgroundColor:[UIColor greenColor]];
        _bgIV.image = IMAGE(@"red_packet_open");
        [_bgIV setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _bgIV;
}

-(UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
//        [_avatarView setBackgroundColor:[UIColor greenColor]];
        [_avatarView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _avatarView;
}

- (UILabel *)userLab {
    if (!_userLab) {
        _userLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:kWhiteColor];
    }
    return _userLab;
}

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:kWhiteColor];
    }
    return _tipLab;
}

- (UILabel *)messageLab {
    if (!_messageLab) {
        _messageLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:20 TextColor:[UIColor goldenrodColor]];
    }
    return _messageLab;
}

- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _openBtn.backgroundColor = [UIColor greenColor];
        [_openBtn addTarget:self action:@selector(openButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

- (void)removeView {
    __weak typeof(self) _weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [_weakSelf removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
}

#pragma mark - 红包 点击
- (void)openButtonClick {
    [self removeView];
    !_openBtnClickBlock ? : _openBtnClickBlock();
}

@end

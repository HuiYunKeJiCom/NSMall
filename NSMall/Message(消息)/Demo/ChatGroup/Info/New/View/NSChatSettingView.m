//
//  NSChatSettingView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/29.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSChatSettingView.h"

@interface NSChatSettingView()
@property(nonatomic,strong)UIView *topV;/* 置顶聊天 */
@property(nonatomic,strong)UILabel *topLb;/* 置顶聊天 提示语 */
@property(nonatomic,strong)UIView *messageV;/* 消息免打扰 */
@property(nonatomic,strong)UILabel *messageLb;/* 消息免打扰 提示语 */
@property(nonatomic,strong)UIView *clearV;/* 清空聊天记录 */
@property(nonatomic,strong)UILabel *clearLb;/* 清空聊天记录 提示语 */
@property(nonatomic,strong)UIButton *clearBtn;/* 清空聊天记录 开关 */
@end

@implementation NSChatSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self setUpData];
    }
    
    return self;
}

-(void)initViews{
    
    [self addSubview:self.topV];
    [self.topV addSubview:self.topLb];
    [self.topV addSubview:self.topSch];
    [self addSubview:self.messageV];
    [self.messageV addSubview:self.messageLb];
    [self.messageV addSubview:self.messageSch];
    [self addSubview:self.clearV];
    [self.clearV addSubview:self.clearLb];
    [self.clearV addSubview:self.clearBtn];

}

-(void)setUpData{
    self.topLb.text = @"置顶聊天";
    self.messageLb.text = @"消息免打扰";
    self.clearLb.text = @"清空聊天记录";
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self makeConstraints];
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(48)));
    }];
    
    [self.topLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
        make.centerY.equalTo(weakSelf.topV.mas_centerY);
    }];
    
    [self.topSch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).with.offset(-20);
        make.centerY.equalTo(weakSelf.topV.mas_centerY).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [self.messageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.topV.mas_bottom).with.offset(1);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(48)));
    }];
    
    [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
        make.centerY.equalTo(weakSelf.messageV.mas_centerY);
    }];
    
    [self.messageSch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).with.offset(-20);
        make.centerY.equalTo(weakSelf.messageV.mas_centerY).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [self.clearV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.messageV.mas_bottom).with.offset(1);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(48)));
    }];
    
    [self.clearLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
        make.centerY.equalTo(weakSelf.clearV.mas_centerY);
    }];
    
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.clearV.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(48)));
    }];
}

-(UIView *)topV{
    if (!_topV) {
        _topV = [[UIView alloc]initWithFrame:CGRectZero];
        _topV.backgroundColor = kWhiteColor;
    }
    return _topV;
}

-(UILabel *)topLb{
    if (!_topLb) {
        _topLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _topLb;
}

-(UISwitch *)topSch{
    if (!_topSch) {
        _topSch = [[UISwitch alloc]initWithFrame:CGRectZero];
        _topSch.on = NO;//设置初始为OFF的一边
        [_topSch addTarget:self action:@selector(topSwitchAction:) forControlEvents:UIControlEventValueChanged];   // 开关事件切换通知
//        _topSch.backgroundColor = kRedColor;
    }
    return _topSch;
}

-(UIView *)messageV{
    if (!_messageV) {
        _messageV = [[UIView alloc]initWithFrame:CGRectZero];
        _messageV.backgroundColor = kWhiteColor;
    }
    return _messageV;
}

-(UILabel *)messageLb{
    if (!_messageLb) {
        _messageLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _messageLb;
}

-(UISwitch *)messageSch{
    if (!_messageSch) {
        _messageSch = [[UISwitch alloc]initWithFrame:CGRectZero];
        _messageSch.on = NO;//设置初始为OFF的一边
        [_messageSch addTarget:self action:@selector(messageSwitchAction:) forControlEvents:UIControlEventValueChanged];   // 开关事件切换通知
//        _messageSch.backgroundColor = kRedColor;
    }
    return _messageSch;
}

-(UIView *)clearV{
    if (!_clearV) {
        _clearV = [[UIView alloc]initWithFrame:CGRectZero];
        _clearV.backgroundColor = kWhiteColor;
    }
    return _clearV;
}

-(UILabel *)clearLb{
    if (!_clearLb) {
        _clearLb = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _clearLb;
}

-(UIButton *)clearBtn{
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

-(void)topSwitchAction:(UISwitch *)topSwitch{
    DLog(@"点击了开关");
    if (_tbDelegate && [_tbDelegate respondsToSelector:@selector(topSwitchAction:)]) {
        [_tbDelegate topSwitchAction:topSwitch];
    }
    
//    BOOL isButtonOn = [topSwitch isOn];
//    if (isButtonOn) {
//        NSLog(@"开");
//    }else {
//        NSLog(@"关");
//    }
}

-(void)messageSwitchAction:(UISwitch *)messageSwitch{
//    DLog(@"点击了message开关");
    if (_tbDelegate && [_tbDelegate respondsToSelector:@selector(messageSwitchAction:)]) {
        [_tbDelegate messageSwitchAction:messageSwitch];
    }
}

#pragma mark - 清空 点击
- (void)clearButtonClick {
//    NSLog(@"清空 点击");
    !_clearBtnClickBlock ? : _clearBtnClickBlock();
}



@end

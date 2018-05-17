//
//  JFDatePickerController.m
//  Trade
//
//  Created by FeiFan on 2017/9/11.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "JFDatePickerController.h"

@interface JFDatePicker : UIView
@property (nonatomic, strong) UIView* titleBackView;
@property (nonatomic, strong) UIDatePicker* datePicker;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* cancelBtn;
@property (nonatomic, strong) UIButton* sureBtn;

@end



@interface JFDatePickerController()
@property (nonatomic, strong) JFDatePicker* datePicker;
@property (nonatomic, copy) NSDate* selectedDate;
@end

@implementation JFDatePickerController

# pragma mark - interface

- (void)showPicker {
    [kAppDelegate.window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self layoutIfNeeded];
    [self.datePicker mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(220);
    }];
    [self.datePicker updateConstraintsIfNeeded];

    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [wself layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePicker {
    [self.datePicker mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [self.datePicker updateConstraintsIfNeeded];
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.backgroundColor = [UIColor clearColor];
        [wself layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [wself removeFromSuperview];
        }
    }];

}


# pragma mark - IBActions

- (IBAction) clickedCancel:(id)sender {
    [self hidePicker];
}

- (IBAction) clickedSure:(id)sender {
    if (self.selectedDate && self.delegate && [self.delegate respondsToSelector:@selector(datePickerCtrl:hiddenWithSelectedDate:)]) {
        [self.delegate datePickerCtrl:self hiddenWithSelectedDate:self.selectedDate];
    }
    [self hidePicker];
}

- (IBAction) datePickerChange:(UIDatePicker*)datePicker {
    self.selectedDate = datePicker.date;
}

# pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDatas];
        [self setupViews];
    }
    return self;
}

- (void) setupDatas {
    self.backgroundColor = [UIColor clearColor];
}

- (void) setupViews {
    [self addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
}

# pragma mark - getter
- (JFDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[JFDatePicker alloc] init];
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker.cancelBtn addTarget:self action:@selector(clickedCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_datePicker.sureBtn addTarget:self action:@selector(clickedSure:) forControlEvents:UIControlEventTouchUpInside];
        [_datePicker.datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

@end




@implementation JFDatePicker

# pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDatas];
        [self setupViews];
    }
    return self;
}

- (void) setupDatas {
}

- (void) setupViews {
    [self addSubview:self.titleBackView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.sureBtn];
    [self addSubview:self.datePicker];
    
    CGFloat insetH = 15;
    [self.titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.titleBackView);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(insetH);
        make.centerY.equalTo(self.titleBackView);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-insetH);
        make.centerY.equalTo(self.titleBackView);
    }];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.titleBackView.mas_bottom);
    }];
}

# pragma mark - getter

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        NSDateFormatter* dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyyMMdd";
        _datePicker.date = [dateFormatter dateFromString:@"19900101"];
    }
    return _datePicker;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        _cancelBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 6, 5, 6);
        _cancelBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
        _cancelBtn.layer.cornerRadius = 5;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        _sureBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 6, 5, 6);
        _sureBtn.backgroundColor = KColorMainGreen;
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
        _sureBtn.layer.cornerRadius = 5;
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _sureBtn;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIView *)titleBackView {
    if (!_titleBackView) {
        _titleBackView = [UIView new];
    }
    return _titleBackView;
}

@end

//
//  JFPickerController.m
//  Trade
//
//  Created by FeiFan on 2017/9/11.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "JFPickerController.h"

static CGFloat const JFPickerAnimationTimeInterval = 0.3;


@interface JFPickerView : UIView
@property (nonatomic, strong) UIView* titleBackView;
@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) UIButton* cancelBtn;
@property (nonatomic, strong) UIButton* sureBtn;
@property (nonatomic, strong) UILabel* titleLabel;
@end


@interface JFPickerController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) JFPickerView* pickerView;
@property (nonatomic, copy) NSIndexPath* selectedIndexPath;
@end

@implementation JFPickerController
@synthesize pickerViewBackgroundColor = _pickerViewBackgroundColor;

# pragma mark - interface

// 显示选择器
- (void) showPicker {
    [kAppDelegate.window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self layoutIfNeeded];
    [self.pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(220);
    }];
    [self.pickerView updateConstraintsIfNeeded];
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [wself layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

// 隐藏选择器
- (void) hidePicker {
    [self.pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [self.pickerView updateConstraintsIfNeeded];
    
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

- (IBAction) clickedCancelBtn:(id)sender {
    [self hidePicker];
}

- (IBAction) clickedSureBtn:(id)sender {
    if (self.selectedIndexPath) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerController:hiddenWithPickedIndexPath:)]) {
            [self.delegate pickerController:self hiddenWithPickedIndexPath:self.selectedIndexPath];
        }
    }
    [self hidePicker];
}

# pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfSections)]) {
        return [self.delegate numberOfSections];
    } else {
        return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerController:numberOfRowsInSection:)]) {
        return [self.delegate pickerController:self numberOfRowsInSection:component];
    } else {
        return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel* label = [UILabel new];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:component];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerController:titleForRowAtIdexPath:)]) {
        label.text = [self.delegate pickerController:self titleForRowAtIdexPath:indexPath];
    }
    label.font = self.textFont;
    label.textAlignment = NSTextAlignmentCenter;
    if (self.selectedIndexPath) {
        label.textColor = (row == self.selectedIndexPath.row && component == self.selectedIndexPath.section) ? self.selectedTextColor : self.normalTextColor;
    } else {
        label.textColor = self.normalTextColor;
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:component];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerController:titleForRowAtIdexPath:)]) {
        self.pickerView.titleLabel.text = [self.delegate pickerController:self titleForRowAtIdexPath:self.selectedIndexPath];
    }
    [pickerView reloadComponent:component];
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
    self.heightOfPickerView = 220;
    self.backgroundColor = [UIColor clearColor];
}

- (void) setupViews {
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
}

# pragma mark - setter
- (void)setPickerViewBackgroundColor:(UIColor *)pickerViewBackgroundColor {
    _pickerViewBackgroundColor = pickerViewBackgroundColor;
    self.pickerView.backgroundColor = self.pickerViewBackgroundColor;
}


# pragma mark - getter

- (JFPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[JFPickerView alloc] initWithFrame:CGRectZero];
        _pickerView.pickerView.delegate = self;
        _pickerView.pickerView.dataSource = self;
        _pickerView.backgroundColor = self.pickerViewBackgroundColor;
        [_pickerView.cancelBtn addTarget:self action:@selector(clickedCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView.sureBtn addTarget:self action:@selector(clickedSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickerView;
}

- (UIColor *)normalTextColor {
    if (!_normalTextColor) {
        _normalTextColor = [UIColor blackColor];
    }
    return _normalTextColor;
}


- (UIColor *)selectedTextColor {
    if (!_selectedTextColor) {
        _selectedTextColor = [UIColor orangeColor];
    }
    return _selectedTextColor;
}
- (UIFont *)textFont {
    if (!_textFont) {
        _textFont = [UIFont systemFontOfSize:15];
    }
    return _textFont;
}
- (UIColor *)ctrlBackgroundColor {
    if (!_ctrlBackgroundColor) {
        _ctrlBackgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _ctrlBackgroundColor;
}
- (UIColor *)pickerViewBackgroundColor {
    if (!_pickerViewBackgroundColor) {
        _pickerViewBackgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _pickerViewBackgroundColor ;
}



@end



@implementation JFPickerView

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
    [self addSubview:self.pickerView];
    
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
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.titleBackView.mas_bottom);
    }];
}

# pragma mark - getter

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
    }
    return _pickerView;
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
        _titleLabel.text = @"(未选中)";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = UIBoldFontSize(14);
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

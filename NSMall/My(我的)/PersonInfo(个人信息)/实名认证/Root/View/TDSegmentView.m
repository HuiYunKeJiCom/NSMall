//
//  TDSegmentView.m
//  Trade
//
//  Created by FeiFan on 2017/8/30.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDSegmentView.h"

@interface TDSegmentView()
@property (nonatomic, strong) NSMutableArray* stepLabels;
@property (nonatomic, strong) NSMutableArray* titleLabels;
@property (nonatomic, strong) NSMutableArray* seperatorViews;
@end

@implementation TDSegmentView


# pragma mark - IBActions

- (void) updateAllStatus {
    for (UILabel* step in self.stepLabels) {
        step.backgroundColor = step.tag > self.curSelectedIndex ? self.normalColor : self.selectedColor;
    }
    for (UILabel* title in self.titleLabels) {
        title.textColor = title.tag > self.curSelectedIndex ? self.normalColor : self.selectedColor;
    }
    for (UIView* seperator in self.seperatorViews) {
        seperator.backgroundColor = seperator.tag > self.curSelectedIndex ? self.normalColor : self.selectedColor;
    }
}


# pragma mark - life cycle

- (instancetype)initWithItems:(NSArray<NSString *> *)items {
    self = [super init];
    if (self) {
        self.items = items;
        [self initializeViews];
        [self initializeDatas];
    }
    return self;
}

- (void) initializeDatas {
    self.curSelectedIndex = -1;
    // 监听 curSelectedIndex，并动态更新视图的颜色
    @weakify(self);
    
    [RACObserve(self, curSelectedIndex) subscribeNext:^(id x) {
        @strongify(self);
        [self updateAllStatus];
    }];
    [RACObserve(self, normalColor) subscribeNext:^(id x) {
        @strongify(self);
        [self updateAllStatus];
    }];
    [RACObserve(self, selectedColor) subscribeNext:^(id x) {
        @strongify(self);
        [self updateAllStatus];
    }];
}

- (void) initializeViews {
    // 生成所有子视图
    // 添加所有子视图
    [self makeAndAddAllSubViews];
    // 约束所有子视图
    [self makeAllConstraints];
}

- (void) makeAndAddAllSubViews {
    for (int i = 0; i < self.items.count; i++) {
        // step
        UILabel* step = [self newStepLabelWithTag:i];
        [self addSubview:step];
        [self.stepLabels addObject:step];
        // title
        UILabel* title = [self newTitleLabelWithTag:i];
        [self addSubview:title];
        [self.titleLabels addObject:title];
        // seperator
        if (i != (self.items.count - 1)) {
            UIView* seperator = [self newSeperatorViewWithTag:i];
            [self addSubview:seperator];
            [self.seperatorViews addObject:seperator];
        }
    }
}

- (void) makeAllConstraints {
    NSInteger itemsCount = self.items.count;
    for (UILabel* step in self.stepLabels) {
        [step mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).multipliedBy((1 - 0.618) * 2);
            make.width.height.mas_equalTo(GetScaleWidth(24));
            make.centerX.equalTo(self.mas_centerX).multipliedBy(2.f * (step.tag + 0.5) * 1.f / itemsCount);
            step.layer.cornerRadius = GetScaleWidth(24) * 0.5;
        }];
    }
    
    UILabel* step = itemsCount > 0 ? self.stepLabels[0] : nil;
    for (UILabel* title in self.titleLabels) {
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(step.mas_bottom).offset(8);
            make.centerX.equalTo(self.mas_centerX).multipliedBy(2.f * (title.tag + 0.5) * 1.f / itemsCount);
        }];
    }
    
    for (UIView* seperator in self.seperatorViews) {
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).multipliedBy((1 - 0.618) * 2);
            make.width.mas_equalTo((kScreenWidth - GetScaleWidth(34) * itemsCount)/ itemsCount);
            make.height.mas_equalTo(1);
            make.centerX.equalTo(self.mas_centerX).multipliedBy(2.f * (seperator.tag + 1) * 1.f / itemsCount);
            seperator.layer.cornerRadius = 0.5;
        }];
    }
}

- (UILabel*) newStepLabelWithTag:(NSInteger)tag {
    UILabel* step = [[UILabel alloc] init];
    step.backgroundColor = self.normalColor;
    step.textColor = KColorMainBackground;//
    step.font = UISystemFontSize(14);
    step.textAlignment = NSTextAlignmentCenter;
    step.layer.masksToBounds = YES;
    step.layer.shouldRasterize = YES;
    step.text = [NSString stringWithFormat:@"%ld", tag + 1];
    step.tag = tag;
    return step;
}

- (UILabel*) newTitleLabelWithTag:(NSInteger)tag {
    UILabel* title = [UILabel new];
    title.textColor = self.normalColor;
    title.font = UIBoldFontSize(13);
    title.textAlignment = NSTextAlignmentCenter;
    title.tag = tag;
    title.text = self.items[tag];
    return title;
}

- (UIView*) newSeperatorViewWithTag:(NSInteger)tag {
    UIView* seperator = [UIView new];
    seperator.backgroundColor = self.normalColor;
    seperator.tag = tag;
    return seperator;
}

# pragma mark - getter

- (NSMutableArray *)stepLabels {
    if (!_stepLabels) {
        _stepLabels = @[].mutableCopy;
    }
    return _stepLabels;
}

- (NSMutableArray *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = @[].mutableCopy;
    }
    return _titleLabels;
}

- (NSMutableArray *)seperatorViews {
    if (!_seperatorViews) {
        _seperatorViews = @[].mutableCopy;
    }
    return _seperatorViews;
}

- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = KColorText999999;
    }
    return _normalColor;
}

- (UIColor *)selectedColor {
    if (!_selectedColor) {
        _selectedColor = KMainColor;
    }
    return _selectedColor;
}

@end

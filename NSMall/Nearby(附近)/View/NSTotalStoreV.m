//
//  NSTotalStoreV.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/15.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSTotalStoreV.h"
#import "NSShopViewTV.h"

@interface NSTotalStoreV()<NSShopViewTVDelegate>
@property(nonatomic,strong)UIView *blueLine;/* 蓝线 */
@property(nonatomic,strong)UILabel *amountLab;/* 合计商户 */
@property(nonatomic,strong)NSShopViewTV *shopViewTV;/* 店铺列表 */
@end

@implementation NSTotalStoreV

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        self.isShow = NO;
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self makeConstraints];
}

- (void)initViews {
    
    [self addSubview:self.blueLine];
    [self addSubview:self.amountLab];
    [self addSubview:self.shopViewTV];
    
    self.blueLine.userInteractionEnabled = YES;
    UITapGestureRecognizer *showTotalStoreViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTotalStoreView)];
    // 2. 将点击事件添加到label上
    [self.blueLine addGestureRecognizer:showTotalStoreViewTap];
}

-(void)showTotalStoreView{
    DLog(@"点击了横线");
    if ([self.delegate respondsToSelector:@selector(showTotalStoreView)]) {
        [self.delegate showTotalStoreView];
    }
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    WEAKSELF
    [self.blueLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.mas_top).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 8));
    }];
    
    [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.blueLine.mas_bottom).with.offset(5);
    }];
    
    [self.shopViewTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.amountLab.mas_bottom).with.offset(5);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
}

- (UIView *)blueLine {
    if (!_blueLine) {
        _blueLine = [[UIView alloc] initWithFrame:CGRectZero];
        _blueLine.backgroundColor = KMainColor;
        _blueLine.layer.cornerRadius = 2.5;//设置那个圆角的有多圆
        _blueLine.layer.masksToBounds = YES;//设为NO去试试
    }
    return _blueLine;
}

- (UILabel *)amountLab {
    if (!_amountLab) {
        _amountLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
        _amountLab.text = @"0家商户";
        _amountLab.textAlignment = NSTextAlignmentLeft;
    }
    return _amountLab;
}

#pragma mark - LazyLoad
- (NSShopViewTV *)shopViewTV {
    if (!_shopViewTV) {
        _shopViewTV = [[NSShopViewTV alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _shopViewTV.backgroundColor = kWhiteColor;
        _shopViewTV.bounces = NO;
        _shopViewTV.tbDelegate = self;
        _shopViewTV.isRefresh = NO;
        _shopViewTV.isLoadMore = NO;
        if (@available(iOS 11.0, *)) {
            _shopViewTV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _shopViewTV;
}



-(void)setStoreList:(NSArray<NSStoreModel *> *)storeList{
    _storeList = storeList;
    DLog(@"count = %ld",storeList.count);
    self.amountLab.text = [NSString stringWithFormat:@"%ld家商户",storeList.count];
    self.shopViewTV.data = [NSMutableArray arrayWithArray:storeList];
    [self.shopViewTV reloadData];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"section = %ld",indexPath.section);
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [_delegate didSelectRowAtIndexPath:indexPath];
    }
}

@end

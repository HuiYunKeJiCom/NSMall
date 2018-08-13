//
//  NSUploadImageView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSUploadImageView.h"

@interface NSUploadImageView()
@property(nonatomic,strong)UIButton *addBtn;/* 添加按钮 */

@end

@implementation NSUploadImageView

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

-(void)setUpWith:(NSString *)tip andImageName:(NSString *)name{
    self.tipLab.text = tip;
    self.uploadImage.image = IMAGE(name);
}

-(void)setupBasicView{
    [self addSubview:self.uploadImage];
    [self addSubview:self.tipLab];
    [self addSubview:self.addIV];
    [self addSubview:self.addBtn];
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.uploadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(340*0.5, 213*0.5));
    }];
    
    [self.addIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.mas_top).with.offset(15);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
    }];
}

-(UIImageView *)uploadImage{
    if (!_uploadImage) {
        _uploadImage = [[UIImageView alloc] init];
        //        [_avatarView setBackgroundColor:[UIColor greenColor]];
        [_uploadImage setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _uploadImage;
}

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:kWhiteColor];
    }
    return _tipLab;
}


-(UIImageView *)addIV{
    if (!_addIV) {
        _addIV = [[UIImageView alloc] init];
        //        [_avatarView setBackgroundColor:[UIColor greenColor]];
        _addIV.image = IMAGE(@"main_ico_add_jia");
        
//        [_addIV setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _addIV;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

#pragma mark - 照片添加 点击
- (void)addButtonClick {
    !_addBtnClickBlock ? : _addBtnClickBlock();
}

@end

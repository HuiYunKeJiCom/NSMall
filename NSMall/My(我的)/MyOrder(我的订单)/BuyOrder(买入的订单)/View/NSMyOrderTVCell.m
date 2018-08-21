//
//  NSMyOrderTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMyOrderTVCell.h"
#import "NSGoodsView.h"


@interface NSMyOrderTVCell()
@property (nonatomic, strong) UIView           *bgView;
@property(nonatomic,strong)UIImageView *headerIV;/* 用户头像 */
@property(nonatomic,strong)UILabel *userName;/* 用户昵称 */
@property(nonatomic,strong)UIImageView *arrowIV;/* 箭头 */
@property(nonatomic,strong)UILabel *stateLab;/* 状态 */
@property(nonatomic,strong)UIView *lineView1;/* 分割线1 */
@property(nonatomic,strong)UILabel *totalLab;/* 总计 */
@property (nonatomic, strong) UIView           *operationView;
@property(nonatomic,strong)UIButton *nextOperation;/* 下一步 */
@end

@implementation NSMyOrderTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = KBGCOLOR;
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI{
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kWhiteColor;
    [self addSubview:self.bgView];
    
    self.headerIV = [[UIImageView alloc] init];
    [self.headerIV setContentMode:UIViewContentModeScaleAspectFill];
    [self.bgView addSubview:self.headerIV];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    [self.bgView addSubview:self.userName];
    
    self.arrowIV = [[UIImageView alloc] init];
    [self.arrowIV setContentMode:UIViewContentModeScaleAspectFill];
    [self.bgView addSubview:self.arrowIV];
    
    self.stateLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    [self.bgView addSubview:self.stateLab];
    
    self.lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
    self.lineView1.backgroundColor = KBGCOLOR;
    [self.bgView addSubview:self.lineView1];
    
    self.totalLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:kGreyColor];
    [self.bgView addSubview:self.totalLab];
    
    self.operationView = [[UIView alloc]init];
    self.operationView.alpha = 0.0;
    self.operationView.backgroundColor = kWhiteColor;
    [self addSubview:self.operationView];
    
    self.nextOperation = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextOperation.titleLabel.font = UISystemFontSize(14);

    // 设置圆角的大小
    self.nextOperation.layer.cornerRadius = 5.0;
    [self.nextOperation.layer setMasksToBounds:YES];
//    self.nextOperation.layer.borderWidth = 1;
//    self.nextOperation.layer.borderColor = [KMainColor CGColor];
    [self.nextOperation setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.nextOperation.backgroundColor = KMainColor;
    [self.nextOperation addTarget:self action:@selector(nextOperationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.operationView addSubview:self.nextOperation];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self makeConstraints];
}

-(void)setFrame:(CGRect)frame {
    //    frame.origin.y += 15;
    [super setFrame:frame];
    
}

- (void)setModel:(NSOrderListItemModel *)model {
    _model = model;
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.user_avatar]];
    self.userName.text = model.user_name;
//    CGSize userSize = [self contentSizeWithTitle:model.user_name andFont:14];
//    self.userName.y = CGRectGetMidY(self.headerIV.frame)-userSize.height*0.5;
//    self.userName.x = CGRectGetMaxX(self.headerIV.frame)+12;
//    [self.userName sizeToFit];
//    self.arrowIV.x = CGRectGetMaxX(self.userName.frame)+11;
//    self.arrowIV.y = 13;
//    self.arrowIV.size = CGSizeMake(5, 9);
    
    DLog(@"order_status = %ld",model.order_status);
    
    self.arrowIV.image = IMAGE(@"my_ico_right_arrow");
    switch (model.order_status) {
        case 1:{
            self.operationView.alpha = 0.0;
            self.stateLab.text = NSLocalizedString(@"wait pay", nil);
//            [self.nextOperation setTitle:NSLocalizedString(@"to pay", nil) forState:UIControlStateNormal];
//            self.nextOperation.backgroundColor = kRedColor;
        }
            break;
        case 2:{
            self.operationView.alpha = 0.0;
            self.stateLab.text = NSLocalizedString(@"wait deliver", nil);
//            [self.nextOperation setTitle:@"去发货" forState:UIControlStateNormal];
//            self.nextOperation.backgroundColor = kRedColor;
        }
            break;
        case 3:{
            self.stateLab.text = NSLocalizedString(@"wait receive", nil);
//            self.nextOperation.backgroundColor = KMainColor;
            if([model.type isEqualToString:@"1"]){
                self.operationView.alpha = 0.0;
//                [self.nextOperation setTitle:NSLocalizedString(@"to evaluate", nil) forState:UIControlStateNormal];
            }else{
                self.operationView.alpha = 1.0;
                [self.nextOperation setTitle:@"确认收货" forState:UIControlStateNormal];
            }
        }
            break;
        case 4:
            self.operationView.alpha = 0.0;
            self.stateLab.text = NSLocalizedString(@"completed", nil)
;//待评价
            break;
        case 10:
            self.operationView.alpha = 0.0;
            self.stateLab.text = NSLocalizedString(@"completed", nil)
;//已结束,不可评价和退换货
            break;
        case 11:
            self.operationView.alpha = 0.0;
            self.stateLab.text = NSLocalizedString(@"cancelled", nil)
;//手动取消
            break;
        case 12:
            self.operationView.alpha = 0.0;
            self.stateLab.text = NSLocalizedString(@"cancelled", nil)
;//超时自动取消
            break;
        default:
            break;
    }
//    CGSize stateSize = [self contentSizeWithTitle:self.stateLab.text andFont:14];
//    self.stateLab.y = CGRectGetMidY(self.headerIV.frame)-stateSize.height *0.5;
//    self.stateLab.x =  kScreenWidth -19-stateSize.width;
//    [self.stateLab sizeToFit];
//    self.lineView1.x = 0;
//    self.lineView1.y = CGRectGetMaxY(self.headerIV.frame)+7;
//    self.lineView1.size = CGSizeMake(kScreenWidth, 1);
    
    float height = 41;
//    NSLog(@"productList = %lu",model.productList.count);
    for(int i=0;i<model.productList.count;i++){
        NSGoodsView *goodsView = [[NSGoodsView alloc]init];
        goodsView.model = model.productList[i];
        goodsView.x = 0;
        goodsView.y = height;
        goodsView.size = CGSizeMake(kScreenWidth, 65);
        [self.bgView addSubview:goodsView];
        
        height+=65;
    }
    
    NSString *text = [NSString stringWithFormat:@"%@%lu%@N%.2f",NSLocalizedString(@"in total", nil)
                          ,model.buy_number,NSLocalizedString(@"piece goods,subtotal", nil),model.pay_amount];
    NSArray *stringArr = [text componentsSeparatedByString:@"小计"];
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:stringArr[1]];
    [LZString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rang];
//    [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:rang];
//    [LZString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:rang];
    self.totalLab.attributedText = LZString;
    
    
    
}

-(void)nextOperationClick{
    DLog(@"点击确认收货");
    !_nextOperationClickBlock ? : _nextOperationClickBlock();
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

#pragma mark - makeConstraints

- (void)makeConstraints {
    WEAKSELF
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(173)));
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(18);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(29), GetScaleWidth(29)));
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerIV.mas_right).with.offset(12);
        make.centerY.equalTo(weakSelf.headerIV.mas_centerY);
    }];
    
    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userName.mas_right).with.offset(11);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(13);
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(5), GetScaleWidth(9)));
    }];

    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-19);
        make.centerY.equalTo(weakSelf.headerIV.mas_centerY);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left);
        make.top.equalTo(weakSelf.headerIV.mas_bottom).with.offset(7);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(1)));
    }];
    
    [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.top.equalTo(weakSelf.bgView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50));
    }];
    
    [self.nextOperation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.operationView.mas_right).with.offset(-19);
        make.bottom.equalTo(weakSelf.operationView.mas_bottom).with.offset(GetScaleWidth(-10));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(100), 30));
    }];
    
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-19);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(GetScaleWidth(-10));
//        make.bottom.equalTo(weakSelf.nextOperation.mas_top).with.offset(-10);
    }];

}

//-(CGFloat)cellHeight{
//    if([self.model.type isEqualToString:@"0"] && (self.model.order_status == 3)){
//        return GetScaleWidth(173)+50;
//    }else{
//        return GetScaleWidth(173);
//    }
//}
@end

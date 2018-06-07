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
    
    self.totalLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:KBGCOLOR];
    [self.bgView addSubview:self.totalLab];
    
    self.nextOperation = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextOperation.titleLabel.font = UISystemFontSize(14);
    
//    // 设置圆角的大小
//    self.nextOperation.layer.cornerRadius = 5;
//    [self.nextOperation.layer setMasksToBounds:YES];
//    self.nextOperation.layer.borderWidth = 1;
//    self.nextOperation.layer.borderColor = [KMainColor CGColor];
    [self.nextOperation setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.nextOperation addTarget:self action:@selector(nextOperationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.nextOperation];
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
    self.arrowIV.image = IMAGE(@"my_ico_right_arrow");
    switch (model.order_status) {
        case 1:{
            self.stateLab.text = @"待支付";
            [self.nextOperation setTitle:@"去支付" forState:UIControlStateNormal];
            self.nextOperation.backgroundColor = kRedColor;
        }
            break;
        case 2:{
            self.stateLab.text = @"待发货";
            [self.nextOperation setTitle:@"去发货" forState:UIControlStateNormal];
            self.nextOperation.backgroundColor = kRedColor;
        }
            break;
        case 3:{
            self.stateLab.text = @"待收货";
            self.nextOperation.backgroundColor = KMainColor;
            if([model.type isEqualToString:@"1"]){
                [self.nextOperation setTitle:@"去评价" forState:UIControlStateNormal];
            }else{
                [self.nextOperation setTitle:@"确认收货" forState:UIControlStateNormal];
            }
        }
            break;
        case 4:
            self.stateLab.text = @"已完成";//待评价
            break;
        case 10:
            self.stateLab.text = @"已完成";//已结束,不可评价和退换货
            break;
        case 11:
            self.stateLab.text = @"已取消";//手动取消
            break;
        case 12:
            self.stateLab.text = @"已取消";//超时自动取消
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
    NSLog(@"productList = %lu",model.productList.count);
    for(int i=0;i<model.productList.count;i++){
        NSGoodsView *goodsView = [[NSGoodsView alloc]init];
        goodsView.model = model.productList[i];
        goodsView.x = 0;
        goodsView.y = height;
        goodsView.size = CGSizeMake(kScreenWidth, 65);
        [self.bgView addSubview:goodsView];
        
        height+=65;
    }
    self.totalLab.text = [NSString stringWithFormat:@"共%lu件商品,小计N%.2f/¥%.2f",model.buy_number,model.pay_amount,model.order_score];
//    CGSize totalSize = [self contentSizeWithTitle:self.totalLab.text andFont:14];
//    [self.totalLab sizeToFit];
//    self.totalLab.x =  kScreenWidth-18-totalSize.width;
//    self.totalLab.y = height+15;
//    self.nextOperation.x = kScreenWidth-67-19;
//    self.nextOperation.y = CGRectGetMaxY(self.totalLab.frame)+10;
//    self.nextOperation.size = CGSizeMake(67, 28);
}

-(void)nextOperationClick{
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
    
    [self.nextOperation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-19);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(GetScaleWidth(-10));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(67), GetScaleWidth(28)));
    }];
    
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-19);
        make.bottom.equalTo(weakSelf.nextOperation.mas_top).with.offset(-10);
    }];

}
@end

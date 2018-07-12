//
//  NSRecordTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSRecordTVCell.h"

@interface NSRecordTVCell()
@property (nonatomic, strong) UIView           *bgView;
@property(nonatomic,strong)UILabel *dateLab;/* 日期 */
@end

@implementation NSRecordTVCell

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
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = KBGCOLOR;
    [self addSubview:self.bgView];
    
    self.dateLab = [[UILabel alloc]init];
    self.dateLab.textColor = kBlackColor;
    self.dateLab.textAlignment = NSTextAlignmentLeft;
    self.dateLab.font = UISystemFontSize(14);
    [self.bgView addSubview:self.dateLab];
}

-(void)setFrame:(CGRect)frame {
    //    frame.origin.y += 15;
    [super setFrame:frame];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self makeConstraints];
}

- (void)setModel:(NSLogListModel *)model {
    _model = model;
    
    self.dateLab.text = model.day;
    
    float height = 41;
    for(int i=0;i<model.list.count;i++){
        NSLogItemModel *item = model.list[i];
        
        UIView *recordV = [[UIView alloc]initWithFrame:CGRectMake(0, height, kScreenWidth, 65)];
        recordV.backgroundColor = kWhiteColor;
        [self.bgView addSubview:recordV];
        
        UILabel *nickName = [[UILabel alloc]init];
        nickName.textColor = kBlackColor;
        nickName.font = UISystemFontSize(14);
        [recordV addSubview:nickName];
        nickName.x = 19;
        nickName.y = 14;
        nickName.text = item.user_name;
        
        UILabel *tradeTime = [[UILabel alloc]init];
        tradeTime.textColor = kBlackColor;
        tradeTime.font = UISystemFontSize(14);
        [recordV addSubview:tradeTime];
        tradeTime.x = 19;
        tradeTime.y = 41;
        
        NSArray *dateArr = [item.trade_time componentsSeparatedByString:@" "];
        NSArray *timeArr = [[dateArr lastObject] componentsSeparatedByString:@":"];
        NSString *tradeStr = [NSString stringWithFormat:@"%@:%@",timeArr[0],timeArr[1]];

        tradeTime.text = tradeStr;
        
        UILabel *tradeAmount = [[UILabel alloc]init];
        tradeAmount.textColor = kBlackColor;
        tradeAmount.font = UISystemFontSize(14);
        [recordV addSubview:tradeAmount];
        tradeAmount.text = [NSString stringWithFormat:@"N%.2f",item.amount];
        CGSize tradeSize = [self contentSizeWithTitle:tradeAmount.text andFont:14];
        tradeAmount.x = kScreenWidth-tradeSize.width-19;
        tradeAmount.y = 27;
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = KBGCOLOR;
        [recordV addSubview:lineView];
        lineView.x = 19;
        lineView.y = 65;
        lineView.size = CGSizeMake(kScreenWidth-38, 1);
        
        height += 66;
    }
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(19);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(14);
    }];
    
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

@end

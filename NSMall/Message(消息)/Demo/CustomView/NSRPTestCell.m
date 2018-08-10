//
//  NSRPTestCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/10.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSRPTestCell.h"

@implementation NSRPTestCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self setupsubviewsWithmodel:model];
    return self;
}

+(NSString *)cellIdentifierWithModel:(id<IMessageModel>)model{
    return @"NSRPTestCell";
}

-(void)setupsubviewsWithmodel:(id<IMessageModel>)model{
//    UIView *view = [[UIView alloc]init];
//    NSString *medicine;
//    CGFloat padding = 5.0;
//    if(model.message.ext[@"rp_leave_msg"] != nil){
//        medicine = [NSString stringWithFormat:@"咨询药品:%@",model.message.ext[@"rp_leave_msg"]];
//    }
//    CGSize textSize = [medicine boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.0]} context:nil].size;
//    CGFloat viewW = textSize.width+30;
//    view.frame = CGRectMake((kScreenWidth - viewW)*0.5, 0, viewW+padding, 40);
//
//    UIView *menView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, textSize.width+30, 26)];
//    menView.backgroundColor = KBGCOLOR;
//    [view addSubview:menView];
//    [self.contentView addSubview:view];
//    UILabel *medicineLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 0, textSize.width+padding, 26)];
//    medicineLabel.text = medicine;
//    medicineLabel.textColor = [UIColor whiteColor];
//    medicineLabel.font = [UIFont systemFontOfSize:14.0];
}

-(BOOL)isCustomBubbleView:(id<IMessageModel>)model{
    return YES;
}

-(void)setCustomBubbleView:(id<IMessageModel>)model{

//    message_ico_new_friend
//    _bubbleView.imageView.image = IMAGE(@"redpacket_chatto_normal");
    
//    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
//    NSString *text = model.text;
//    UILabel *label = [[UILabel alloc]init];
//    CGSize textSize = [text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.0]} context:nil].size;
//    CGFloat labelW = textSize.width +15;
//    CGFloat labelH = textSize.height +30;
//    label.frame = CGRectMake(10, 0, labelW, labelH);
//    label.numberOfLines = 0;
//    label.text = text;
//    label.font = [UIFont systemFontOfSize:15.0];
//    label.textColor = [UIColor blackColor];
//    [self.bubbleView insertSubview:label aboveSubview:self.bubbleView.backgroundImageView];
}

-(void)setCustomModel:(id<IMessageModel>)model{
    UIImage *image = model.image;
    if(!image){
        [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
    }else{
        _bubbleView.imageView.image = image;
    }
    
    if(model.avatarURLPath){
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    }else{
        self.avatarView.image = model.avatarImage;
    }
}

-(void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model{
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
    if(model.isSender){
        CGSize textSize = [model.text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15.0]} context:nil].size;
        CGFloat bubbleViewW = textSize.width + 23;
        CGFloat bubbleViewH = textSize.height + 30;
        _bubbleView.frame = CGRectMake(kScreenWidth-55-bubbleViewW, 40, bubbleViewW, bubbleViewH);
    }
}


@end

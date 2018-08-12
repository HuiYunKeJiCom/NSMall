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
        self.sendBubbleBackgroundImage = IMAGE(@"redpacket_chatto_normal");
        self.recvBubbleBackgroundImage = IMAGE(@"redpacket_chatfrom_normal");
        self.avatarSize = 38;
        self.avatarCornerRadius = 5;
        [self configureSendLayoutConstraints];
    }
//    [self setupsubviewsWithmodel:model];
    return self;
}

+(NSString *)cellIdentifierWithModel:(id<IMessageModel>)model{
    return @"NSRPTestCell";
}

//-(void)setupsubviewsWithmodel:(id<IMessageModel>)model{
//}

-(BOOL)isCustomBubbleView:(id<IMessageModel>)model{
    return YES;
}

-(void)setCustomBubbleView:(id<IMessageModel>)model{

    NSDictionary *ext = model.message.ext;
//    _bubbleView.textLabel.text = [ext objectForKey:@"rp_leave_msg"];
    
    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
    NSString *text = [ext objectForKey:@"rp_leave_msg"];
    UILabel *label = [[UILabel alloc]init];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.0]} context:nil].size;
    CGFloat labelW = textSize.width +15;
    CGFloat labelH = textSize.height +20;
    label.frame = CGRectMake(20+30, 0, labelW, labelH);
    label.numberOfLines = 0;
    label.text = text;
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor greenColor];
    [self.bubbleView insertSubview:label aboveSubview:self.bubbleView.backgroundImageView];
    
    NSString *checkText = @"";
    if(model.isSender){
        checkText = @"查看红包";
    }else{
        checkText = @"领取红包";
    }
    UILabel *checkLab = [[UILabel alloc]init];
    CGSize checkSize = [checkText boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13.0]} context:nil].size;
    CGFloat checkLabW = checkSize.width +14;
    CGFloat checkLabH = checkSize.height;
    checkLab.frame = CGRectMake(20+30, CGRectGetMaxY(label.frame)-5, checkLabW, checkLabH);
    checkLab.numberOfLines = 0;
    checkLab.text = checkText;
    checkLab.font = [UIFont systemFontOfSize:13.0];
    checkLab.textColor = [UIColor whiteColor];
    [self.bubbleView insertSubview:checkLab aboveSubview:self.bubbleView.backgroundImageView];
    
    
    NSString *sponsorText = [ext objectForKey:@"money_sponsor_name"];
    UILabel *sponsorLab = [[UILabel alloc]init];
    sponsorLab.frame = CGRectMake(10, CGRectGetMaxY(checkLab.frame)+10, 100, 20);
    sponsorLab.text = sponsorText;
    sponsorLab.font = [UIFont systemFontOfSize:13.0];
    sponsorLab.textColor = [UIColor grayColor];
    [self.bubbleView insertSubview:sponsorLab aboveSubview:self.bubbleView.backgroundImageView];
//    message_ico_redpakect
    UIImageView *redPacketIV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 13, 30, 36)];
    redPacketIV.image = IMAGE(@"message_ico_redpakect");
    [self.bubbleView insertSubview:redPacketIV aboveSubview:self.bubbleView.backgroundImageView];
    
    if(model.isSender){
        label.frame = CGRectMake(20+30, 0, labelW, labelH);
        checkLab.frame = CGRectMake(20+30, CGRectGetMaxY(label.frame)-5, checkLabW, checkLabH);
        sponsorLab.frame = CGRectMake(10, CGRectGetMaxY(checkLab.frame)+10, 100, 20);
        redPacketIV.frame = CGRectMake(12, 13, 30, 36);
    }else{
        label.frame = CGRectMake(20+30+15, 0, labelW, labelH);
        checkLab.frame = CGRectMake(20+15+30, CGRectGetMaxY(label.frame)-5, checkLabW, checkLabH);
        sponsorLab.frame = CGRectMake(10+15, CGRectGetMaxY(checkLab.frame)+10, 100, 20);
        redPacketIV.frame = CGRectMake(12+15, 13, 30, 36);
    }
}

-(void)setCustomModel:(id<IMessageModel>)model{
//    UIImage *image = model.image;
//    if(!image){
//        [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
//    }else{
//        _bubbleView.imageView.image = image;
//    }
    
//    if(model.avatarURLPath){
//        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
//    }else{
//        self.avatarView.image = model.avatarImage;
//    }
}

-(void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model{
    
//    NSDictionary *ext = model.message.ext;
    NSString *text = @"恭喜发财,大吉大利";
    if(model.isSender){
        _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.0]} context:nil].size;
        CGFloat bubbleViewW = textSize.width + 23+40+40;
        CGFloat bubbleViewH = textSize.height + 30+30;
        _bubbleView.frame = CGRectMake(kScreenWidth-50-bubbleViewW, 18, bubbleViewW, bubbleViewH);
        
    }else{
 _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.0]} context:nil].size;
        CGFloat bubbleViewW = textSize.width + 23+40+40;
        CGFloat bubbleViewH = textSize.height + 30+30;
        _bubbleView.frame = CGRectMake(50-5, 18, bubbleViewW, bubbleViewH);
    }
}


@end

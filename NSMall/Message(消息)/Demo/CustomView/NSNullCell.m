//
//  NSNullCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/9/7.
//  Copyright © 2018年 www. All rights reserved.
//

#define RedpacketImageInset         UIEdgeInsetsMake(0, 9, 20, 20)

#import "NSNullCell.h"

@implementation NSNullCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.avatarSize = 0;
        self.avatarCornerRadius = 5;
        //        [self configureSendLayoutConstraints];
    }
    //    [self setupsubviewsWithmodel:model];
    return self;
}

+(NSString *)cellIdentifierWithModel:(id<IMessageModel>)model{
    return @"NSNullCell";
}

//-(void)setupsubviewsWithmodel:(id<IMessageModel>)model{
//}

-(BOOL)isCustomBubbleView:(id<IMessageModel>)model{
    return YES;
    
    
}

-(void)setCustomBubbleView:(id<IMessageModel>)model{
    
//    NSDictionary *ext = model.message.ext;
//    NSString *text = @"";
//    UILabel *label = [[UILabel alloc]init];
//    NSString *received = [ext objectForKey:@"rp_received_count"];
//    NSString *rpCount = [ext objectForKey:@"rp_count"];
//    if([received isEqualToString:rpCount]){
//        text = [NSString stringWithFormat:@"%@领取了你的红包\n你的红包已被领完",[ext objectForKey:@"receive_nick"]];
//        label.numberOfLines = 2;
//        label.frame = CGRectMake(0, 5, kScreenWidth, 40);
//        self.bubbleView.frame = CGRectMake(0, 0, kScreenWidth, 40);
//    }else{
//        text = [NSString stringWithFormat:@"%@领取了你的红包",[ext objectForKey:@"receive_nick"]];
//        label.numberOfLines = 1;
//        label.frame = CGRectMake(0, 5, kScreenWidth, 20);
        self.bubbleView.frame = CGRectMake(0, 0, kScreenWidth, 0);
//    }
    //    CGSize textSize = [text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.0]} context:nil].size;
    //    CGFloat labelW = textSize.width +15;
    //    CGFloat labelH = textSize.height;
//    label.text = text;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:14.0];
//    label.textColor = [UIColor grayColor];
    [self.bubbleView.backgroundImageView removeFromSuperview];
//    [self.bubbleView addSubview:label];
    
}

-(void)setCustomModel:(id<IMessageModel>)model{
}

-(void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model{
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
}


@end

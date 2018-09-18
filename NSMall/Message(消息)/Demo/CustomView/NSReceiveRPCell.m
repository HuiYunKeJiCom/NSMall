//
//  NSReceiveRPCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/9/5.
//  Copyright © 2018年 www. All rights reserved.
//

#define RedpacketImageInset         UIEdgeInsetsMake(0, 9, 20, 20)

#import "NSReceiveRPCell.h"

@implementation NSReceiveRPCell

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
    return @"NSReceiveRPCell";
}

//-(void)setupsubviewsWithmodel:(id<IMessageModel>)model{
//}

-(BOOL)isCustomBubbleView:(id<IMessageModel>)model{
    return YES;
    
    
}

-(void)setCustomBubbleView:(id<IMessageModel>)model{
    UserModel *userModel = [UserModel modelFromUnarchive];
    NSDictionary *ext = model.message.ext;
    //    _bubbleView.textLabel.text = [ext objectForKey:@"rp_leave_msg"];
    
//    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
    NSString *text = @"";
    UILabel *label = [[UILabel alloc]init];
    NSString *received = [ext objectForKey:@"rp_received_count"];
    NSString *rpCount = [ext objectForKey:@"rp_count"];
    if([received isEqualToString:rpCount]){
        if([[ext objectForKey:@"receive_nick"] isEqualToString:userModel.user_name]){
            text = @"你领取了自己发的红包\n你的红包已被领完";
        }else{
            text = [NSString stringWithFormat:@"%@领取了你的红包\n你的红包已被领完",[ext objectForKey:@"receive_nick"]];
        }
        
        label.numberOfLines = 2;
        label.frame = CGRectMake(0, 5, kScreenWidth, 40);
        self.bubbleView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    }else{
        if([[ext objectForKey:@"receive_nick"] isEqualToString:userModel.user_name]){
            text = @"你领取了自己发的红包";
        }else{
            text = [NSString stringWithFormat:@"%@领取了你的红包",[ext objectForKey:@"receive_nick"]];
        }
        
        label.numberOfLines = 1;
        label.frame = CGRectMake(0, 5, kScreenWidth, 20);
        self.bubbleView.frame = CGRectMake(0, 0, kScreenWidth, 20);
    }
//    CGSize textSize = [text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.0]} context:nil].size;
//    CGFloat labelW = textSize.width +15;
//    CGFloat labelH = textSize.height;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor grayColor];
//    label.backgroundColor = [UIColor redColor];
//    self.bubbleView.backgroundColor = [UIColor greenColor];
//    [self.bubbleView insertSubview:label aboveSubview:self.bubbleView.backgroundImageView];
    [self.bubbleView.backgroundImageView removeFromSuperview];
    [self.bubbleView addSubview:label];
    
}

-(void)setCustomModel:(id<IMessageModel>)model{
//        UIImage *image = model.image;
//        if(!image){
//            [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
//        }else{
//            _bubbleView.imageView.image = image;
//        }
//    
//        if(model.avatarURLPath){
//            [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
//        }else{
//            self.avatarView.image = model.avatarImage;
//        }
}

-(void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model{

    //    NSDictionary *ext = model.message.ext;
//    NSString *text = @"恭喜发财,大吉大利";
//    if(model.isSender){
        _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
//        CGSize textSize = [text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.0]} context:nil].size;
//        CGFloat bubbleViewW = textSize.width + 23+40+40;
//        CGFloat bubbleViewH = 10;
//        _bubbleView.frame = CGRectMake(kScreenWidth-50-bubbleViewW, 0, bubbleViewW, bubbleViewH);
//
//    }else{
//        _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
//        CGSize textSize = [text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.0]} context:nil].size;
//        CGFloat bubbleViewW = textSize.width + 23+40+40;
//        CGFloat bubbleViewH = textSize.height + 30+30;
//        _bubbleView.frame = CGRectMake(55, 18, bubbleViewW, bubbleViewH);
//    }
}

@end

//
//  NSInvitationCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/9/19.
//  Copyright © 2018年 www. All rights reserved.
//

#define RedpacketImageInset         UIEdgeInsetsMake(0, 9, 20, 20)

#import "NSInvitationCell.h"

@implementation NSInvitationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.extDict = [NSDictionary dictionary];
        self.avatarSize = 0;
        self.avatarCornerRadius = 5;
        //        [self configureSendLayoutConstraints];
        
        
    }
    //    [self setupsubviewsWithmodel:model];
    return self;
}

+(NSString *)cellIdentifierWithModel:(id<IMessageModel>)model{
    return @"NSInvitationCell";
}

//-(void)setupsubviewsWithmodel:(id<IMessageModel>)model{
//}

-(BOOL)isCustomBubbleView:(id<IMessageModel>)model{
    return YES;
    
    
}

-(void)setCustomBubbleView:(id<IMessageModel>)model{
//    UserModel *userModel = [UserModel modelFromUnarchive];
    NSDictionary *ext = model.message.ext;
    self.extDict = model.message.ext;
    
    NSString *text = @"";
    UILabel *label = [[UILabel alloc]init];
    NSString *invitee = [ext objectForKey:@"invite_nick"];
    NSString *inviter = [ext objectForKey:@"nick"];
    NSString *inviterHxid = [ext objectForKey:@"hx_username"];
    text = [NSString stringWithFormat:@"%@邀请%@进群",invitee,inviter];
    label.numberOfLines = 0;
    label.frame = CGRectMake(0, 5, kScreenWidth, 20);
    self.bubbleView.frame = CGRectMake(0, 0, kScreenWidth, 50);
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor grayColor];
    [self.bubbleView.backgroundImageView removeFromSuperview];
    [self.bubbleView addSubview:label];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *messId = model.messageId;
    
    EMError *error = nil;
    EMCursorResult* result = [[EMClient sharedClient].groupManager getGroupMemberListFromServerWithId:[ext objectForKey:@"group_id"] cursor:nil pageSize:50 error:&error];
    if (!error) {
        NSLog(@"获取成功");
        // result.list: 返回的成员列表，内部的值是成员的环信id。
        // result.cursor: 返回的cursor，如果要取下一页的列表，需要将这个cursor当参数传入到获取群组成员列表中。
        BOOL isbool = [result.list containsObject:inviterHxid];
        
        if(isbool){
            if([userDefaults objectForKey:messId]){
                NSDictionary *temp = [userDefaults objectForKey:messId];
                self.stateLab = [[UILabel alloc]init];
                self.stateLab.frame = CGRectMake(0, 25, kScreenWidth, 20);
                self.stateLab.textAlignment = NSTextAlignmentCenter;
                self.stateLab.font = [UIFont systemFontOfSize:14.0];
                self.stateLab.textColor = [UIColor grayColor];
                [self.bubbleView addSubview:self.stateLab];
                self.stateLab.text = [temp objectForKey:@"operation"];
            }else{
                NSMutableDictionary *temp = [NSMutableDictionary dictionary];
                temp = [NSMutableDictionary dictionaryWithDictionary:model.message.ext];
                self.stateLab = [[UILabel alloc]init];
                self.stateLab.frame = CGRectMake(0, 25, kScreenWidth, 20);
                self.stateLab.textAlignment = NSTextAlignmentCenter;
                self.stateLab.font = [UIFont systemFontOfSize:14.0];
                self.stateLab.textColor = [UIColor grayColor];
                [self.bubbleView addSubview:self.stateLab];
                self.stateLab.text = @"已加入";
                [temp setValue:@"已加入" forKey:@"operation"];
                [userDefaults setObject:temp forKey:messId];
                [userDefaults synchronize];
            }
        }else{
            if([userDefaults objectForKey:messId]){
                NSDictionary *temp = [userDefaults objectForKey:messId];
                self.stateLab = [[UILabel alloc]init];
                self.stateLab.frame = CGRectMake(0, 25, kScreenWidth, 20);
                self.stateLab.textAlignment = NSTextAlignmentCenter;
                self.stateLab.font = [UIFont systemFontOfSize:14.0];
                self.stateLab.textColor = [UIColor grayColor];
                [self.bubbleView addSubview:self.stateLab];
                self.stateLab.text = [temp objectForKey:@"operation"];
            }else{
                self.agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.agreeBtn.backgroundColor = KMainColor;
                [self.agreeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                self.agreeBtn.titleLabel.font = UISystemFontSize(14);
                self.agreeBtn.layer.masksToBounds = YES;
                self.agreeBtn.layer.cornerRadius = 5;
                [self.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
                [self.agreeBtn addTarget:self action:@selector(agreeButtonClick) forControlEvents:UIControlEventTouchUpInside];
                self.agreeBtn.frame = CGRectMake(kScreenWidth*0.5-5-50, 25, 50, 20);
                [self.bubbleView addSubview:self.agreeBtn];
                
                self.refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.refuseBtn.backgroundColor = kRedColor;
                [self.refuseBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                self.refuseBtn.titleLabel.font = UISystemFontSize(14);
                self.refuseBtn.layer.masksToBounds = YES;
                self.refuseBtn.layer.cornerRadius = 5;
                [self.refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
                [self.refuseBtn addTarget:self action:@selector(refuseButtonClick) forControlEvents:UIControlEventTouchUpInside];
                self.refuseBtn.frame = CGRectMake(kScreenWidth*0.5+5, 25, 50, 20);
                [self.bubbleView addSubview:self.refuseBtn];
                
                self.stateLab = [[UILabel alloc]init];
                self.stateLab.frame = CGRectMake(0, 25, kScreenWidth, 20);
                self.stateLab.textAlignment = NSTextAlignmentCenter;
                self.stateLab.font = [UIFont systemFontOfSize:14.0];
                self.stateLab.textColor = [UIColor grayColor];
                self.stateLab.alpha = 0.0;
                [self.bubbleView addSubview:self.stateLab];
            }
        }
    }

}

-(void)setCustomModel:(id<IMessageModel>)model{

}

-(void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model{
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;

}

#pragma mark - 同意 点击
- (void)agreeButtonClick {
    //    NSLog(@"同意 点击");
    !_agreeBtnClickBlock ? : _agreeBtnClickBlock();
}

#pragma mark - 拒绝 点击
- (void)refuseButtonClick {
    //    NSLog(@"拒绝 点击");
    !_refuseBtnClickBlock ? : _refuseBtnClickBlock();
}
@end

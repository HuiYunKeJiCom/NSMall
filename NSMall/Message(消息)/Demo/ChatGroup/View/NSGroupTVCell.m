//
//  NSGroupTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGroupTVCell.h"
#import "NSHuanXinUserModel.h"
#import "AEIconView.h"

@interface NSGroupTVCell(){
    NSMutableArray *_groupMembers;
}
@property (nonatomic, weak)AEIconView *iconV;//九宫格头像
@property (nonatomic, strong)NSMutableArray <NSString *>*images;//获取到的图片的url

@end

@implementation NSGroupTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kWhiteColor;
        _groupMembers = [NSMutableArray array];
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI{
//    CGFloat w = 60;
//    CGFloat h = w;
//    CGFloat x = ([UIScreen mainScreen].bounds.size.width - w) * 0.5;
//    CGFloat y = 50;
    AEIconView *iconV = [[AEIconView alloc] initWithFrame:CGRectMake(10, 2, 45, 45)];
    _iconV = iconV;
    iconV.image = [UIImage imageNamed:@"group_header"];
    //设置背景色
    iconV.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:iconV];
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect rect = self.textLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.iconV.frame) + 10;
    self.textLabel.frame = rect;
}

- (void)setGroupModel:(NSGroupModel *)groupModel{
    _groupModel = groupModel;
    [_groupMembers removeAllObjects];
    [self.images removeAllObjects];
    
    NSDictionary *tempDict = [self dictionaryWithJsonString:groupModel.group_name_json];
    _groupMembers =  [tempDict objectForKey:@"jsonArray"];
    
    NSString *groupName = @"";
    for (int i=0;i<_groupMembers.count;i++) {
        NSDictionary *dict = _groupMembers[i];
        NSHuanXinUserModel *model = [NSHuanXinUserModel new];
        model.user_avatar = [dict objectForKey:@"avatar"];
        model.hx_user_name = [dict objectForKey:@"hxUsername"];
        model.nick_name = [dict objectForKey:@"nick"];
//        [self.membersArr addObject:model];
        if(i == 0){
            groupName = [NSString stringWithFormat:@"%@",model.nick_name];
        }else{
            groupName = [groupName stringByAppendingFormat:@"、%@",model.nick_name];
        }
        if(i<6){
            [self.images addObject:model.user_avatar];
        }
        //
    }
    
//    self.groupName = [tempDict objectForKey:@"groupName"];
    
    self.textLabel.text = groupName;
//    self.imageView.image = IMAGE(@"group_header");
    self.iconV.images = self.images;
//[self.avatarIV sd_setImageWithURL:[NSURL URLWithString:model.user_avatar]];
}

//json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//懒加载图片url数组
-(NSMutableArray<NSString *> *)images{
    if(!_images){
        _images = [NSMutableArray array];
    }
    return _images;
}


@end

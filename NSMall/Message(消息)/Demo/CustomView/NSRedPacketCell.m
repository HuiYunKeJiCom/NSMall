//
//  NSRedPacketCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/10.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSRedPacketCell.h"
#import "EaseBubbleView+Text.h"

@interface NSRedPacketCell()

//@property(nonatomic,strong)UIImageView *bgIV;/* 背景图 */
//@property(nonatomic,strong)UIImageView *rpImageView;/* 红包图片 */
//@property(nonatomic,strong)UILabel *messageLab;/* 留言 */
//@property(nonatomic,strong)UILabel *rpStatus;/* 红包状态 */
//@property(nonatomic,strong)UILabel *body;/* 消息体 */

@end

@implementation NSRedPacketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
//        _messageType = model.bodyType;
//        [self _setupSubviewsWithType:_messageType
//                            isSender:model.isSender
//                               model:model];

    }
    return self;
}

//- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
//{
//    return YES;
//}
//
//-(void)setBubbleView:(EaseBubbleView *)bubbleView{
//
//    [self.bubbleView setupTextBubbleView];
//    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
//}
//
//- (void)setCustomBubbleView:(id<IMessageModel>)model
//{
//    // 这里创建自定义的view
//}
//
//- (void)setCustomModel:(id<IMessageModel>)model
//{
//    // 这里边给view赋值
//}
//
//
//
//- (void)setModel:(id<IMessageModel>)model
//{
//    // 这里边给view赋值
//}




//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//
//    if (self) {
//
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor clearColor];
//
//        [self addSubview:self.bgIV];
//        [self addSubview:self.rpImageView];
//        [self addSubview:self.messageLab];
//        [self addSubview:self.rpStatus];
//        [self addSubview:self.body];
//
//        [self makeConstraints];
//    }
//
//    return self;
//}
//
//-(void)setFrame:(CGRect)frame {
//
//    [super setFrame:frame];
//
//}
//
//#pragma mark - Constraints
//- (void)makeConstraints {
//
//    WEAKSELF
//
//}
//
//-(UIImageView *)bgIV{
//    if (!_bgIV) {
//        _bgIV = [[UIImageView alloc] init];
//        //        [_goodsIV setBackgroundColor:[UIColor greenColor]];
//        [_bgIV setContentMode:UIViewContentModeScaleAspectFill];
//    }
//    return _bgIV;
//}
//
//-(UIImageView *)rpImageView{
//    if (!_rpImageView) {
//        _rpImageView = [[UIImageView alloc] init];
//        //        [_goodsIV setBackgroundColor:[UIColor greenColor]];
//        [_rpImageView setContentMode:UIViewContentModeScaleAspectFit];
//    }
//    return _rpImageView;
//}
//
//- (UILabel *)messageLab {
//    if (!_messageLab) {
//        _messageLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum16 TextColor:[UIColor blackColor]];
//    }
//    return _messageLab;
//}
//
//- (UILabel *)rpStatus {
//    if (!_rpStatus) {
//        _rpStatus = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
//    }
//    return _rpStatus;
//}
//
//- (UILabel *)body {
//    if (!_body) {
//        _body = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
//    }
//    return _body;
//}
//
//-(void)setDict:(NSDictionary *)dict{
//    _dict = dict;
//
//    DLog(@"dict = %@",dict);
//}

@end

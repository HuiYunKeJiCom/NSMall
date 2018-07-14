//
//  NSReplyItemModel.h
//  
//
//  Created by 张锐凌 on 2018/7/13.
//

#import <Foundation/Foundation.h>

@interface NSReplyItemModel : NSObject
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *comment_reply_id;//回复主键id
@property (nonatomic,copy)NSString *parent_reply_id;//上级评论id
@property (nonatomic,copy)NSString *reply_content;//回复内容
@property (nonatomic,copy)NSString *reply_time;//回复时间
@property (nonatomic)NSInteger reply_type;//回复类型【0=用户回复，1=官方回复】
@property (nonatomic,copy)NSString *reply_user_id;//回复人ID
@property (nonatomic,copy)NSString *reply_user_name;//回复人昵称
@property (nonatomic,strong)NSString *reply_user_avatar;//回复人头像
@end

//
//  NSAddLabelVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/7.
//  Copyright © 2018年 www. All rights reserved.
//

#import "DCBaseSetViewController.h"
#import "LabelItemModel.h"

@class CLTagsModel;
@class NSAddLabelVC;
@protocol NSAddLabelVCDelegate <NSObject>
    
    /**
     返回标签展示页的所有标签(默认是点击保存按钮)
     @param tags 标签
     */
- (void)tagViewController:(NSAddLabelVC *)tagController tags:(NSArray<LabelItemModel *> *)tags;
    
    @end

@interface NSAddLabelVC : DCBaseSetViewController
    @property (weak, nonatomic) id<NSAddLabelVCDelegate> tagsDelegate;
    
    /**
     标签展示页默认显示标签
     */
    @property (nonatomic, strong) NSArray<LabelItemModel *> *tagsDisplayArray;
    
    /**
     最近标签页默认显示的标签
     */
    @property (nonatomic, strong) NSArray<CLTagsModel *> *tagsModelArray;
    
    /**
     最近标签页是否高亮展示页中相同的标签
     */
    @property (assign, nonatomic, getter=isHighlightTag) BOOL highlightTag;
    
    /**
     设置标签的圆角(不设置值则默认是控件高度的一半)
     */
    @property (assign, nonatomic) CGFloat cornerRadius;
    
    /**
     设置输入框中输入时标签的文字颜色(默认黑色)
     */
    @property (strong, nonatomic) UIColor *normalTextColor;
    
    /**
     设置输入框中输入时标签的边框颜色(默认灰色)
     */
    @property (strong, nonatomic) UIColor *textFieldBorderColor;
    
    /**
     限制单个标签最大输入的字符个数（默认是10）
     */
    @property (assign, nonatomic) NSInteger maxStringAmount;
    
    /**
     最多显示标签的行数(默认是3)
     */
    @property (assign, nonatomic) NSInteger maxRows;

@end

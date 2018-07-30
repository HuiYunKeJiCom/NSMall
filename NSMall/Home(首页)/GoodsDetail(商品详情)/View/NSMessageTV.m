//
//  NSMessageTV.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMessageTV.h"
#import "NSMessageTVCell.h"

@implementation NSMessageTV

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSMessageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSMessageTVCell"];
        
        if (!cell) {
            cell = [[NSMessageTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSMessageTVCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.data.count > indexPath.section) {
            NSMessageModel *infoModel = [self.data objectAtIndex:indexPath.section];
            cell.messageModel = infoModel;
            cell.delBtnClickBlock = ^{
                [self deleteCommentWithIndexPath:indexPath];
            };
            cell.headerClickBlock = ^{
                [self goToUserPageWithIndexPath:indexPath];
            };
        }
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return GetScaleWidth(95);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(10))];
    
    return sectionView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tbDelegate && [_tbDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [_tbDelegate didSelectRowAtIndexPath:indexPath];
    }
}

-(void)goToUserPageWithIndexPath:(NSIndexPath *)indexPath{
    if (_tbDelegate && [_tbDelegate respondsToSelector:@selector(goToUserPageWithIndexPath:)]) {
        [_tbDelegate goToUserPageWithIndexPath:indexPath];
    }
}

-(void)deleteCommentWithIndexPath:(NSIndexPath *)indexPath{
    if (_tbDelegate && [_tbDelegate respondsToSelector:@selector(deleteCommentWithIndexPath:)]) {
        [_tbDelegate deleteCommentWithIndexPath:indexPath];
    }
}


@end

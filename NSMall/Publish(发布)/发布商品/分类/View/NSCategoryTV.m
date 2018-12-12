//
//  NSCategoryTV.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/22.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCategoryTV.h"
#import "NSCategoryTVCell.h"

@interface NSCategoryTV()

@end

@implementation NSCategoryTV

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
    NSCategoryTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSCategoryTVCell"];
    
    if (!cell) {
        cell = [[NSCategoryTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSCategoryTVCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.arrowImgView.alpha = 0.0;
    if(self.data.count > indexPath.section){
        ADLMyInfoModel *infoModel = [self.data objectAtIndex:indexPath.section];
        cell.myInfoModel = infoModel;
    }    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return GetScaleWidth(43);
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

@end

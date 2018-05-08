//
//  NSGoodsTableView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/7.
//  Copyright © 2018年 www. All rights reserved.
//  发布商品

#import "NSGoodsTableView.h"
#import "NSInfoCustomCell.h"

@implementation NSGoodsTableView

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
    NSInfoCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSInfoCustomCell"];
    
    if (!cell) {
        cell = [[NSInfoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSInfoCustomCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ADLMyInfoModel *infoModel = [self.data objectAtIndex:indexPath.section];
    cell.myInfoModel = infoModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return GetScaleWidth(52);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0 || section == 1 || section == 4){
        return GetScaleWidth(10);
    }else{
        return 0;
    }
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

//
//  NSPersonInfoTableView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSPersonInfoTableView.h"
#import "NSInfoCustomCell.h"

@implementation NSPersonInfoTableView

#pragma mark -
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
        
        if (self.data.count > indexPath.section) {
            ADLMyInfoModel *infoModel = [self.data objectAtIndex:indexPath.section];
            cell.myInfoModel = infoModel;
        }
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        return 268*0.5;
    }else{
        return 144*0.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30*0.5)];
    
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

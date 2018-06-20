//
//  NSShopViewTV.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/15.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSShopViewTV.h"
#import "NSShopViewTVCell.h"

@implementation NSShopViewTV

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
        NSShopViewTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSShopViewTVCell"];
        
        if (!cell) {
            cell = [[NSShopViewTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NSShopViewTVCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.data.count > indexPath.section) {
            NSStoreModel *storeModel = [self.data objectAtIndex:indexPath.section];
            cell.storeModel = storeModel;
        }
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return GetScaleWidth(80);
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

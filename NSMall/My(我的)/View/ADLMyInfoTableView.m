//
//  ADLMyInfoTableView.m
//  Kart
//
//  Created by 朱鹏 on 17/3/9.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ADLMyInfoTableView.h"
#import "ADLMyInfoTableViewCell.h"
//#import "ADLMyInfoTableViewFooterCell.h"

@interface ADLMyInfoTableView ()

@end

@implementation ADLMyInfoTableView

#pragma mark -
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        ADLMyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADLMyInfoTableViewCell"];
        
        if (!cell) {
            cell = [[ADLMyInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ADLMyInfoTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.data.count > indexPath.section) {
            ADLMyInfoModel *infoModel = [self.data objectAtIndex:indexPath.section];
            cell.myInfoModel = infoModel;
        }
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 115*0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 0;
    }else{
        return 30*0.5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30*0.5)];
    
    return sectionView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0){
        return GetScaleWidth(90);
    }else if(section == 4){
        return 85;
    }
    else{
     return 0.01f;
    }
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_tbDelegate && [_tbDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [_tbDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - 查看 点击
- (void)viewBtnButtonClick {
    !_viewBtnClickBlock ? : _viewBtnClickBlock();
}

@end

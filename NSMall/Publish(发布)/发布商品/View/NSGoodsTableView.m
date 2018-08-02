//
//  NSGoodsTableView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/7.
//  Copyright © 2018年 www. All rights reserved.
//  发布商品

#import "NSGoodsTableView.h"
#import "NSInfoCustomCell.h"



@interface NSGoodsTableView()

@end

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
    if(indexPath.section == 3){
        cell.arrowImgView.alpha = 0.0;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return GetScaleWidth(43);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView.tag == 40){
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
    NSLog(@"View里面");
//    if(indexPath.section == 3){
//        [self addSpecViewWithIndexPath:indexPath];
//    }else{
    if (_tbDelegate && [_tbDelegate respondsToSelector:@selector(goodsTableView: didSelectRowAtIndexPath:)]) {
        [_tbDelegate goodsTableView:self didSelectRowAtIndexPath:indexPath];
        }
//    }
}

-(void)addSpecViewWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"增加规格");
    if (_tbDelegate && [_tbDelegate respondsToSelector:@selector(addSpecViewWithIndexPath:)]) {
        [_tbDelegate addSpecViewWithIndexPath:indexPath];
    }
}

-(void)setDict:(NSMutableDictionary *)dict{
    _dict = dict;
    [self reloadData];
}

//-(void)setIsShow:(BOOL)isShow{
//    _isShow = isShow;
//    [self reloadData];
//}


@end

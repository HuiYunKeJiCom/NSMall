//
//  NSSearchAddressVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSSearchAddressVC.h"
#import "HistorySearchVC.h"
#import "LLSearchVCConst.h"

@interface NSSearchAddressVC ()
@property(nonatomic,copy)NSString *searchKeyword;/* 搜索关键字 */
@end

@implementation NSSearchAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    
    [self creatSearchNaviBar];
    
}


- (void)creatSearchNaviBar{
    LLSearchNaviBarView *searchNaviBarView = [LLSearchNaviBarView new];
    searchNaviBarView.searbarPlaceHolder = @"请输入搜索关键词";
    
    
    @LLWeakObj(self);
    [searchNaviBarView showbackBtnWith:[UIImage imageNamed:@"top_left_arrow"] onClick:^(UIButton *btn) {
        @LLStrongObj(self);
        if (self.stringBlock) {
            self.stringBlock(self.searchKeyword);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    [searchNaviBarView setSearchBarBeignOnClickBlock:^{
        @LLStrongObj(self);
        
        HistorySearchVC *searShopVC = [HistorySearchVC new];
        
        
        @LLWeakObj(searShopVC);
        //(1)点击分类 (2)用户点击键盘"搜索"按钮  (3)点击历史搜索记录
        [searShopVC beginSearch:^(NaviBarSearchType searchType,NBSSearchShopCategoryViewCellP *categorytagP,UILabel *historyTagLabel,LLSearchBar *searchBar) {
            //            @LLStrongObj(searShopVC);
            //进入列表页面
            self.searchKeyword = searchBar.text;
            //这里已修改
            if (self.stringBlock) {
                self.stringBlock(searchBar.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        
        //执行即时搜索匹配
        NSArray *tempArray = nil;
        
        
        [searShopVC searchbarDidChange:^(NaviBarSearchType searchType, LLSearchBar *searchBar, NSString *searchText) {
            @LLStrongObj(searShopVC);
            
            //FIXME:这里模拟网络请求数据!!!
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                searShopVC.resultListArray = tempArray;
            });
        }];
        
        [self.navigationController presentViewController:searShopVC animated:nil completion:nil];
    }];
    
    [self.view addSubview:searchNaviBarView];
}

-(void)dealloc{
    NSLog(@"HistoryVC 页面销毁");
}

@end

//
//  TDUserCertifyDataConfirm.m
//  Trade
//
//  Created by FeiFan on 2017/8/31.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifyDataConfirm.h"


static NSString* const userCertifyConfirmText0 = @"诺一股等数字货币交易为7*24小时连续交易。请综合考虑自身的投资经历、财务状况、风险承受能力等因素，在充分了解诺一股等数字货币交易特性和风险的前提下，慎重、理性投资，避免因盲目投资而带来损失。";
static NSString* const userCertifyConfirmText1 = @"您承诺以上提供的所有证件、资料、信息均为本人合法所有，且真实有效。若在验证过程中发现证件、资料、信息为冒用、虚假、伪造，或存在此等风险的，OEX交易平台有权不经事先通知即冻结相关账户，并向公安机关举报。";
static NSString* const userCertifyConfirmText2 = @"根据\"反洗钱法\"及相关规定，OEX交易平台可能在注册、充值、交易、提现等过程中向您了解资金来源及资金流向，若您拒绝告知或虚假陈述，OEX交易平台有权不再另行通知即冻结您的账户。";




@interface TDUserCertifyDataConfirmNode : NSObject
+ (instancetype) nodeWithTitle:(NSString*)title text:(NSString*)text state:(TDUserDertifyConfirmState)state;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* text;
@property (nonatomic, assign) TDUserDertifyConfirmState state;
@end


@interface TDUserCertifyDataConfirm()
@property (nonatomic, strong) NSArray<TDUserCertifyDataConfirmNode*>* dataSource;
@end


@implementation TDUserCertifyDataConfirm



- (NSInteger)numberOfRows {
    return self.dataSource.count;
}

- (NSString*) titleForHeaderView {
    return KLocalizableStr(@"提交风险提示");
}
- (NSString*) titleForFooterView {
    return KLocalizableStr(@"选择“本人同意”即表明您已充分知悉上述风险，并自愿承担由此造成的一切后果。");
}

- (CGFloat) heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if(self.dataSource.count > indexPath.row){
        NSString* text = self.dataSource[indexPath.row].text;
        CGFloat width = kScreenWidth - 40;
        CGSize size = KTextSize(text, width, 13);
        NSString* title = self.dataSource[indexPath.row].title;
        return size.height + 14 + 5 + 10 + 14 + 20 + (title && title.length > 0 ? 20 : 0);
    }else{
        return 0.01f;
    }
    
}

- (NSString*) titleForRowAtIndexPath:(NSIndexPath*)indexPath {
    if(self.dataSource.count > indexPath.row){
        return self.dataSource[indexPath.row].title;
    }else{
        return @"";
    }
    
}

- (NSString*) textForRowAtIndexPath:(NSIndexPath*)indexPath {
    if(self.dataSource.count > indexPath.row){
        return self.dataSource[indexPath.row].text;
    }else{
        return @"";
    }
    
}

- (TDUserDertifyConfirmState) confirmStateForRowAtIndexPath:(NSIndexPath*)indexPath {
    if(self.dataSource.count > indexPath.row){
        return self.dataSource[indexPath.row].state;
    }else{
        return @"";
    }
    
}

- (void)updateConfirmState:(TDUserDertifyConfirmState)state atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSource.count) {
        self.dataSource[indexPath.row].state = state;
    }
}

# pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.allConfirmed = NO;
        [self binddingConfirms];
    }
    return self;
}

- (void) binddingConfirms {
    NSMutableArray* confirms = [NSMutableArray array];
    for (TDUserCertifyDataConfirmNode* node in self.dataSource) {
        [confirms addObject:RACObserve(node, state)];
    }
    RAC(self, allConfirmed) = [RACSignal combineLatest:confirms
        reduce:^id (NSNumber* state1, NSNumber* state2, NSNumber* state3){
            return @(state1.integerValue == TDUserDertifyConfirmStateYes && state2.integerValue == TDUserDertifyConfirmStateYes && state3.integerValue == TDUserDertifyConfirmStateYes);
    }];
}

# pragma mark - getter

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[[TDUserCertifyDataConfirmNode nodeWithTitle:KLocalizableStr(@"交易风险告知") text:KLocalizableStr(userCertifyConfirmText0) state:TDUserDertifyConfirmStateNone],
                        [TDUserCertifyDataConfirmNode nodeWithTitle:KLocalizableStr(@"法律责任告知") text:KLocalizableStr(userCertifyConfirmText1) state:TDUserDertifyConfirmStateNone],
                        [TDUserCertifyDataConfirmNode nodeWithTitle:nil text:userCertifyConfirmText2 state:TDUserDertifyConfirmStateNone]];
        
    }
    return _dataSource;
}

@end


@implementation TDUserCertifyDataConfirmNode

+ (instancetype)nodeWithTitle:(NSString *)title text:(NSString *)text state:(TDUserDertifyConfirmState)state {
    TDUserCertifyDataConfirmNode* node = [TDUserCertifyDataConfirmNode new];
    node.title = title;
    node.text = text;
    node.state = state;
    return node;
}

@end

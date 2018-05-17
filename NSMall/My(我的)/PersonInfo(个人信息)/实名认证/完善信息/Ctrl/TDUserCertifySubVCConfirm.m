//
//  TDUserCertifySubVCConfirm.m
//  Trade
//
//  Created by FeiFan on 2017/8/30.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifySubVCConfirm.h"
#import "TDUserCertifyCellConfirm.h"

@interface TDUserCertifyConfirmHeader : UIView
@property (nonatomic, strong) UILabel* titleLabel;
@end

@interface TDUserCertifyConfirmFooter : UIView
@property (nonatomic, strong) UILabel* titleLabel;
@end



@interface TDUserCertifySubVCConfirm () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* commitBtn;
@property (nonatomic, strong) TDUserCertifyDataConfirm* dataSource;
@end

@implementation TDUserCertifySubVCConfirm

# pragma mark - IBActions 

- (IBAction) clickedCommitBtn:(id)sender {
    if (self.touchEvent) {
        self.touchEvent();
    }
}

# pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfRows];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDUserCertifyCellConfirm* cellConfirm = [tableView dequeueReusableCellWithIdentifier:@"TDUserCertifyCellConfirm"];
    if (!cellConfirm) {
        cellConfirm = [[TDUserCertifyCellConfirm alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TDUserCertifyCellConfirm"];
    }
    cellConfirm.titleLabel.text = [self.dataSource titleForRowAtIndexPath:indexPath];
    cellConfirm.contentLabel.text = [self.dataSource textForRowAtIndexPath:indexPath];
    cellConfirm.state = [self.dataSource confirmStateForRowAtIndexPath:indexPath];
    cellConfirm.agreementBtn.tag = indexPath.row;
    cellConfirm.disagreementBtn.tag = indexPath.row;
    cellConfirm.lineView.hidden = indexPath.row == 0 ? NO : YES;
    // 绑定"同意"点击事件
    @weakify(self);
    [[[cellConfirm.agreementBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cellConfirm.rac_prepareForReuseSignal] subscribeNext:^(UIButton* btn) {
        @strongify(self);
        [self.dataSource updateConfirmState:TDUserDertifyConfirmStateYes atIndexPath:indexPath];
        TDUserCertifyCellConfirm* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.state = TDUserDertifyConfirmStateYes;
    }];
    // 绑定"不同意"点击事件
    [[[cellConfirm.disagreementBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cellConfirm.rac_prepareForReuseSignal] subscribeNext:^(UIButton* btn) {
        @strongify(self);
        [self.dataSource updateConfirmState:TDUserDertifyConfirmStateNo atIndexPath:indexPath];
        TDUserCertifyCellConfirm* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.state = TDUserDertifyConfirmStateNo;
    }];
    return cellConfirm;
}

# pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDatas];
    [self initializeViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initializeDatas {
    self.view.backgroundColor = KColorMainBackground;
    RAC(self.commitBtn, enabled) = RACObserve(self.dataSource, allConfirmed);
}

- (void) initializeViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitBtn];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetScaleWidth(25));
        make.right.mas_equalTo(GetScaleWidth(-25));
        make.bottom.mas_equalTo(GetScaleWidth(-20));
        make.height.mas_equalTo(44);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.commitBtn.mas_top).offset(GetScaleWidth(-20));
    }];
}

- (IBAction)clickBtn:(id)sender {
    if (self.touchEvent) {
        self.touchEvent();
    }
}

# pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = KColorMainBackground;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        TDUserCertifyConfirmHeader* headerV = [[TDUserCertifyConfirmHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        headerV.titleLabel.text = [self.dataSource titleForHeaderView];
        TDUserCertifyConfirmFooter* footerV = [[TDUserCertifyConfirmFooter alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        footerV.titleLabel.text = [self.dataSource titleForFooterView];
        _tableView.tableHeaderView = headerV;
        _tableView.tableFooterView = footerV;
    }
    return _tableView;
}

- (TDUserCertifyDataConfirm *)dataSource {
    if (!_dataSource) {
        _dataSource = [TDUserCertifyDataConfirm new];
    }
    return _dataSource;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [UIButton new];
        _commitBtn.backgroundColor = KColorMainOrange;
        _commitBtn.layer.cornerRadius = 5;
        [_commitBtn setTitle:KLocalizableStr(@"提交") forState:UIControlStateNormal];
        [_commitBtn setTitleColor:KBGCOLOR forState:UIControlStateNormal];
        [_commitBtn setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        [_commitBtn setTitleColor:kWhiteColor forState:UIControlStateDisabled];
        [_commitBtn addTarget:self action:@selector(clickedCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}
@end

/********** header view *********/
@implementation TDUserCertifyConfirmHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = UIBoldFontSize(15);
        _titleLabel.textColor = KColorTextContent;
    }
    return _titleLabel;
}

@end
/********** footer view *********/
@implementation TDUserCertifyConfirmFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = UISystemFontSize(14);
        _titleLabel.textColor = KColorTextContent;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}


@end

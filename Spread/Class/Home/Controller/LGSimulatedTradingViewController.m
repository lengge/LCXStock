//
//  LGSimulatedTradingViewController.m
//  Spread
//
//  Created by user on 17/5/31.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGSimulatedTradingViewController.h"
#import "LGTradeCell.h"
#import "LGTradeModel.h"
#import <YYModel.h>
#import "MJRefresh.h"
#import "LGHTTPRequestTool.h"

/*********************表格SectionHeader*********************/
@interface LGSectionHeader : UIView

@property (nonatomic, strong) UILabel *varietiesLabel;

@property (nonatomic, strong) UILabel *nowPriceLabel;

@property (nonatomic, strong) UILabel *ratioLabel;

@end

@implementation LGSectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        [self addSubview:self.varietiesLabel];
        [self addSubview:self.nowPriceLabel];
        [self addSubview:self.ratioLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    @weakify(self);
    [self.varietiesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weak_self);
    }];
    
    [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(weak_self);
        make.width.mas_equalTo(60);
    }];
    
    [self.nowPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weak_self.ratioLabel.mas_left).offset(-24);
        make.centerY.mas_equalTo(weak_self);
    }];
}

- (UILabel *)varietiesLabel {
    if (!_varietiesLabel) {
        _varietiesLabel = [UILabel new];
        _varietiesLabel.text = @"交易品种";
        _varietiesLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _varietiesLabel.font = [UIFont systemFontOfSize:14];
    }
    return _varietiesLabel;
}

- (UILabel *)nowPriceLabel {
    if (!_nowPriceLabel) {
        _nowPriceLabel = [UILabel new];
        _nowPriceLabel.text = @"最新价";
        _nowPriceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _nowPriceLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nowPriceLabel;
}

- (UILabel *)ratioLabel {
    if (!_ratioLabel) {
        _ratioLabel = [UILabel new];
        _ratioLabel.text = @"涨跌幅";
        _ratioLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _ratioLabel.font = [UIFont systemFontOfSize:14];
        _ratioLabel.textAlignment = NSTextAlignmentRight;
    }
    return _ratioLabel;
}

@end

/*********************模拟交易控制器*********************/
@interface LGSimulatedTradingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *varietiesArray;

@end

@implementation LGSimulatedTradingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"模拟交易";
    
    [self setupSubviews];
    // 加载交易品种
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [self loadTradeVarieties];
    
    @weakify(self);
    [self.tableView addHeaderWithCallback:^{
        [weak_self loadTradeVarieties];
    }];
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)loadTradeVarieties {
    NSString *urlStr = @"https://fd.qihuoniu.com/mktdata/contractdatalist.ashx?usertoken=X7KpjyUPIBv_FzZgb1RNvH4_G6OleTmYMe1-_Ra-pMJzp06uI-qOE6lLuM_qtsKa&version=9.9.9&packtype=775&proxyid=36&contracttypeid=2";
    [LGHTTPRequestTool GET:urlStr paramers:nil success:^(id respose) {
        //DDLogError(@"%@", respose);
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView headerEndRefreshing];
        if ([respose[@"status"] integerValue]) {
            _varietiesArray = [NSArray yy_modelArrayWithClass:[LGTradeModel class] json:respose[@"data"]];
            [self.tableView reloadData];
        } else {
            [MBHUDHelper showWarningWithText:respose[@"info"]];
        }
    } failure:^(NSError *error) {
        //DDLogError(@"%@", error);
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView headerEndRefreshing];
        [MBHUDHelper showWarningWithText:@"请检查网络连接后重试"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.varietiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGTradeCell *cell = [LGTradeCell cellWithTableView:tableView];
    
    cell.tradeModel = self.varietiesArray[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LGSectionHeader *header = [[LGSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 34)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor colorWithHexString:@"#e8e8e8"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return _tableView;
}

@end

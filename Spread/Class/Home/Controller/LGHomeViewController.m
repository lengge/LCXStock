//
//  LGHomeViewController.m
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGHomeViewController.h"
#import "SDCycleScrollView.h"
#import "LGHomeTableViewHeader.h"
#import "LGHomeSectionHeader.h"
#import "LGHTTPRequestTool.h"
#import "LGTradeModel.h"
#import "LGTradeCell.h"
#import "LGADModel.h"
#import <YYModel.h>
#import "GCDTimer.h"
#import "LGTool.h"
#import "MJRefresh.h"
#import "LGStockChartViewController.h"

#import "LGSimulatedTradingViewController.h"

#define KCycleScrollViewHeight 160
#define KTableHeaderTitleViewHeight 105

@interface LGHomeViewController ()<SDCycleScrollViewDelegate, LGHomeTableViewHeaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
    GCDTimer *_timer;
}

@property (nonatomic, strong) UIView *naviBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) LGHomeTableViewHeader *tableHeaderTitleView;

@property (nonatomic, strong) UIView *tableViewHeader;

@property (nonatomic, strong) NSArray *adArray;

@property (nonatomic, strong) NSArray *varietiesArray;

@end

@implementation LGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self setupSubviews];
    
    // 加载广告数据
    [self loadAdData];
    // 加载交易品种
    [MBProgressHUD showMessage:@"加载中..."];
    [self loadTradeVarieties];
    
    @weakify(self);
    [self.tableView addHeaderWithCallback:^{
        [weak_self loadAdData];
        [weak_self loadTradeVarieties];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    @weakify(self);
    _timer = [GCDTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^{
        [weak_self loadTradeVarieties];
    }];
}

#pragma mark - 关闭定时器
- (void)closeTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self closeTimer];
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBar];
}

- (void)loadAdData {
    NSString *urlStr = @"https://pay.qihuoniu.com/public/homeads.ashx?usertoken=&version=9.9.9&packtype=775&proxyid=36";
    [LGHTTPRequestTool GET:urlStr paramers:nil success:^(id respose) {
        //DDLogError(@"%@", respose);
        if ([respose[@"status"] integerValue]) {
            _adArray = [NSArray yy_modelArrayWithClass:[LGADModel class] json:respose[@"data"]];
            NSMutableArray *URLArray = [NSMutableArray array];
            [_adArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LGADModel *adModel = (LGADModel *)obj;
                [URLArray addObject:adModel.url];
            }];
            self.cycleScrollView.imageURLStringsGroup = URLArray;
        }
    } failure:^(NSError *error) {
        //DDLogError(@"%@", error);
    }];
}

- (void)loadTradeVarieties {
    NSString *urlStr = @"https://fd.qihuoniu.com/mktdata/contractdatalist.ashx?usertoken=X7KpjyUPIBv_FzZgb1RNvH4_G6OleTmYMe1-_Ra-pMJzp06uI-qOE6lLuM_qtsKa&version=9.9.9&packtype=775&proxyid=36&contracttypeid=2";
    [LGHTTPRequestTool GET:urlStr paramers:nil success:^(id respose) {
        //DDLogError(@"%@", respose);
        [MBProgressHUD hideHUD];
        [self.tableView headerEndRefreshing];
        if ([respose[@"status"] integerValue]) {
            _varietiesArray = [NSArray yy_modelArrayWithClass:[LGTradeModel class] json:respose[@"data"]];
            [self.tableView reloadData];
        } else {
            [MBHUDHelper showWarningWithText:respose[@"info"]];
        }
    } failure:^(NSError *error) {
        //DDLogError(@"%@", error);
        [MBProgressHUD hideHUD];
        [self.tableView headerEndRefreshing];
        [MBHUDHelper showWarningWithText:@"请检查网络连接后重试"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.varietiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGTradeCell *cell = [LGTradeCell cellWithTableView:tableView];
    
    cell.tradeModel = self.varietiesArray[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LGHomeSectionHeader *header = [[LGHomeSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LGTradeModel *model = self.varietiesArray[indexPath.row];
    LGStockChartViewController *stockChartVC = [[LGStockChartViewController alloc] init];
    stockChartVC.contractid = model.contractid;
    stockChartVC.title = model.symbolname;
    [self.navigationController pushViewController:stockChartVC animated:YES];
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        self.naviBar.alpha = 0.0;
    } else if (offsetY >= KCycleScrollViewHeight - HEIGHT_STATUSBAR - HEIGHT_NAVBAR) {
        self.naviBar.alpha = 1.0;
    } else {
        self.naviBar.alpha = offsetY / (KCycleScrollViewHeight - HEIGHT_STATUSBAR - HEIGHT_NAVBAR);
    }
}

#pragma mark - LGHomeTableViewHeaderDelegate
- (void)lg_header:(LGHomeTableViewHeader *)header buttonPressed:(UIButton *)button {
    switch (button.tag) {
        case 101:
        {
            // 模拟交易
            LGSimulatedTradingViewController *tradingVC = [[LGSimulatedTradingViewController alloc] init];
            [self.navigationController pushViewController:tradingVC animated:YES];
        }
            break;
        case 102:
        {
            // 新手学堂

        }
            break;
        case 103:
            // 客服咨询
            break;
            
        default:
            break;
    }
}

#pragma mark - 懒加载
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KCycleScrollViewHeight) imageURLStringsGroup:nil];
        _cycleScrollView.autoScrollTimeInterval = 3.0;
        _cycleScrollView.infiniteLoop = YES;
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.placeholderImage = nil;
    }
    return _cycleScrollView;
}

- (LGHomeTableViewHeader *)tableHeaderTitleView {
    if (!_tableHeaderTitleView) {
        _tableHeaderTitleView = [[LGHomeTableViewHeader alloc] initWithFrame:CGRectMake(0, KCycleScrollViewHeight, SCREEN_WIDTH, KTableHeaderTitleViewHeight)];
        _tableHeaderTitleView.delegate = self;
    }
    return _tableHeaderTitleView;
}

- (UIView *)tableViewHeader {
    if (!_tableViewHeader) {
        _tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KTableHeaderTitleViewHeight + KCycleScrollViewHeight)];
        [_tableViewHeader addSubview:self.cycleScrollView];
        [_tableViewHeader addSubview:self.tableHeaderTitleView];
    }
    return _tableViewHeader;
}

- (UIView *)naviBar {
    if (!_naviBar) {
        _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_STATUSBAR + HEIGHT_NAVBAR)];
        _naviBar.backgroundColor = [UIColor colorWithHexString:@"#212124"];
        _naviBar.alpha = 0.0;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"差价宝";
        titleLabel.textColor = [UIColor colorWithHexString:@"#d3bf8d"];
        titleLabel.font = [UIFont systemFontOfSize:18];
        CGSize titleSize = [LGTool rectOfString:titleLabel.text attributes:@{NSFontAttributeName:titleLabel.font}].size;
        titleLabel.frame = CGRectMake((SCREEN_WIDTH - titleSize.width) / 2.0, HEIGHT_STATUSBAR + (HEIGHT_NAVBAR - titleSize.height) / 2 , titleSize.width, titleSize.height);
        
        [_naviBar addSubview:titleLabel];
    }
    return _naviBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HEIGHT_TABBAR) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor colorWithHexString:@"#e8e8e8"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.tableHeaderView = self.tableViewHeader;
    }
    return _tableView;
}

- (void)dealloc {
    [self closeTimer];
}

@end

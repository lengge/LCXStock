//
//  LGStockChartViewController.m
//  Spread
//
//  Created by user on 17/6/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGStockChartViewController.h"
#import "LCXStockChartView.h"
#import "LCXTimeLineGroupModel.h"
#import "LGHTTPRequestTool.h"
#import "LCXKLineGroupModel.h"
#import "NSDate+Helper.h"
#import "LCXStockDetailModel.h"
#import "LGStockChartBuyToolBar.h"
#import "GCDTimer.h"
#import "LGTradeFormView.h"


@interface LGStockChartViewController ()<UITableViewDelegate, UITableViewDataSource, LCXStockChartViewDataSource, LGStockChartBuyToolBarDelegate>
{
    GCDTimer *_timer;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LCXStockChartView *stockChartView;

@property (nonatomic, strong) LGStockChartBuyToolBar *buyToolBar;

@property (nonatomic, strong) LGTradeFormView *tradeFormView;

/**
 分时线模型
 */
@property (nonatomic, strong) LCXTimeLineGroupModel *timeLineGroupModel;

/**
 一分钟模型
 */
@property (nonatomic, strong) LCXKLineGroupModel *oneMinuteGroupModel;

/**
 五分钟模型
 */
@property (nonatomic, strong) LCXKLineGroupModel *fiveMinuteGroupModel;

/**
 日K模型
 */
@property (nonatomic, strong) LCXKLineGroupModel *dayGroupModel;

@end

@implementation LGStockChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    // 加载即时股票数据
    [self loadRealTimeStockData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    @weakify(self);
    _timer = [GCDTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^{
        [weak_self loadRealTimeStockData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self closeTimer];
}

#pragma mark - 关闭定时器
- (void)closeTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)setupSubviews {
    self.tableView.tableHeaderView = self.stockChartView;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.buyToolBar];
    
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(weak_self.buyToolBar.mas_top).offset(0);
    }];
    
    [self.buyToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
}

- (void)loadRealTimeStockData {
    NSString *urlStr = [NSString stringWithFormat:@"https://fd.qihuoniu.com/mktdata/futuresshare.ashx?usertoken=X7KpjyUPIBv_FzZgb1RNvH4_G6OleTmYMe1-_Ra-pMJzp06uI-qOE6lLuM_qtsKa&version=9.9.9&packtype=775&proxyid=36&contractid=%@&count=1&ba=2&time=%@", self.contractid, [[NSDate date] stringWithFormat:@"yyyyMMddHHmm00"]];
    [LGHTTPRequestTool GET:urlStr paramers:nil success:^(id respose) {
        //DDLogInfo(@"%@", respose);
        if ([respose[@"status"] integerValue]) {
            LCXStockDetailModel *stockDetailModel = [LCXStockDetailModel yy_modelWithJSON:respose[@"data"]];
            self.stockChartView.stockDetailModel = stockDetailModel;
            self.buyToolBar.stockDetailModel = stockDetailModel;
            
            LCXTimeLineGroupModel *timeLineGroupModel = [LCXTimeLineGroupModel yy_modelWithJSON:respose[@"data"]];
            LCXTimeLineModel *curTimeLineModel = [timeLineGroupModel.timeModels firstObject];
            LCXTimeLineModel *lastTimeLineModel = [self.timeLineGroupModel.timeModels lastObject];
            if ([curTimeLineModel.currentTime integerValue] > [lastTimeLineModel.currentTime integerValue]) {
                NSMutableArray *timeLineModels = [self.timeLineGroupModel.timeModels mutableCopy];
                [timeLineModels addObject:curTimeLineModel];
                self.timeLineGroupModel.timeModels = timeLineModels;
                [self.stockChartView reloadData];
            }
        }
    } failure:^(NSError *error) {
        //DDLogError(@"%@", error);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

#pragma mark 分时线数据请求方法
- (void)event_timeLineRequestMethod {
    NSString *urlStr = [NSString stringWithFormat:@"https://fd.qihuoniu.com/mktdata/futuresshare.ashx?usertoken=X7KpjyUPIBv_FzZgb1RNvH4_G6OleTmYMe1-_Ra-pMJzp06uI-qOE6lLuM_qtsKa&version=9.9.9&packtype=775&proxyid=36&contractid=%@&count=1&ba=2&time=", self.contractid];
    [LGHTTPRequestTool GET:urlStr paramers:nil success:^(id respose) {
        if ([respose[@"status"] integerValue]) {
            LCXTimeLineGroupModel *timeLineGroupModel = [LCXTimeLineGroupModel yy_modelWithJSON:respose[@"data"]];
            //根据时间进行排序，倒序
            NSMutableArray *sortedTimeLineModels = [NSMutableArray array];
            [timeLineGroupModel.timeModels enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LCXTimeLineModel *timeLineModel = (LCXTimeLineModel *)obj;
                [sortedTimeLineModels addObject:timeLineModel];
            }];
            
            timeLineGroupModel.timeModels = sortedTimeLineModels;
            self.timeLineGroupModel = timeLineGroupModel;
            [self.stockChartView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - K线数据请求方法
- (void)event_kLineRequestWithType:(NSNumber *)type kLineType:(LCXStockChartKLineType)kLineType {
    NSString *urlStr = [NSString stringWithFormat:@"https://fd.qihuoniu.com/mktdata/futureskline.ashx?usertoken=X7KpjyUPIBv_FzZgb1RNvH4_G6OleTmYMe1-_Ra-pMJzp06uI-qOE6lLuM_qtsKa&version=9.9.9&packtype=775&proxyid=36&contractid=%@&count=200&type=%@", self.contractid, type];
    
    [LGHTTPRequestTool GET:urlStr paramers:nil success:^(id respose) {
        if ([respose[@"status"] integerValue]) {
            LCXKLineGroupModel *kLineGroupModel = [LCXKLineGroupModel yy_modelWithJSON:respose[@"data"]];
            
            //根据时间进行排序，倒序
            NSMutableArray *sortedKLineModels = [NSMutableArray array];
            [kLineGroupModel.kLineModels enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LCXKLineModel *kLineModel = (LCXKLineModel *)obj;
                [sortedKLineModels addObject:kLineModel];
            }];
            
            // 计算MA和找出需要画日期的线
            __block LCXKLineModel *comparingModel = [sortedKLineModels firstObject];
            [sortedKLineModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LCXKLineModel *kLineModel = (LCXKLineModel *)obj;
                
                //1.当前日期的收盘价等于第二天的收盘价，今天的收盘价等于现价
                if (idx + 1 < sortedKLineModels.count) {
                    LCXKLineModel *nextLineModel = sortedKLineModels[idx + 1];
                    kLineModel.preclose = nextLineModel.preclose;
                } else {
                    kLineModel.preclose = kLineModel.nowv;
                }
                //2.计算MA
                [kLineModel updateMA:sortedKLineModels];
                //3.找出需要画日期的线
                NSDate *compaingDate = [NSDate dateWithString:comparingModel.timestamp format:@"yyyyMMddHHmmss"];
                NSDate *objDate = [NSDate dateWithString:kLineModel.timestamp format:@"yyyyMMddHHmmss"];
                switch (kLineType) {
                    case LCXStockChartKLineTypeDay:
                    {
                        if ([compaingDate month] != [objDate month] ||
                            [compaingDate year] != [objDate year]) {
                            kLineModel.isDrawDate = YES;
                            comparingModel = kLineModel;
                        }
                    }
                        break;
                    case LCXStockChartKLineTypeOneMinute:
                    case LCXStockChartKLineTypeFiveMinute:
                    {
                        if ((idx + 1) % 20 == 0) {
                            kLineModel.isDrawDate = YES;
                            comparingModel = kLineModel;
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
            
            kLineGroupModel.kLineModels = sortedKLineModels;
            
            switch (kLineType) {
                case LCXStockChartKLineTypeDay:
                    self.dayGroupModel = kLineGroupModel;
                    break;
                case LCXStockChartKLineTypeOneMinute:
                    self.oneMinuteGroupModel = kLineGroupModel;
                    break;
                case LCXStockChartKLineTypeFiveMinute:
                    self.fiveMinuteGroupModel = kLineGroupModel;
                    break;
                    
                default:
                    break;
            }
            
            [self.stockChartView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - LCXStockChartViewDataSource
- (id)stockDatasWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            // 分时
            if (self.timeLineGroupModel.timeModels.count > 0) {
                return self.timeLineGroupModel;
            } else {
                [self event_timeLineRequestMethod];
            }
            break;
        case 1:
            // 1分钟
            if (self.oneMinuteGroupModel.kLineModels.count > 0) {
                self.stockChartView.kLineType = LCXStockChartKLineTypeOneMinute;
                return self.oneMinuteGroupModel;
            } else{
                [self event_kLineRequestWithType:@(1) kLineType:LCXStockChartKLineTypeOneMinute];
            }
            break;
        case 2:
            // 5分钟
            if (self.fiveMinuteGroupModel.kLineModels.count > 0) {
                self.stockChartView.kLineType = LCXStockChartKLineTypeFiveMinute;
                return self.fiveMinuteGroupModel;
            } else{
                [self event_kLineRequestWithType:@(2) kLineType:LCXStockChartKLineTypeFiveMinute];
            }
            break;
        case 3:
            // 日K
            if (self.dayGroupModel.kLineModels.count > 0) {
                self.stockChartView.kLineType = LCXStockChartKLineTypeDay;
                return self.dayGroupModel;
            } else{
                [self event_kLineRequestWithType:@(6) kLineType:LCXStockChartKLineTypeDay];
            }
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark - LGStockChartBuyToolBarDelegate
- (void)buyToolBar:(LGStockChartBuyToolBar *)buyToolBar buyButtonClicked:(UIButton *)button {
    switch (button.tag) {
        case 100:
            // 买涨
            self.tradeFormView.tradeFormType = LGTradeFormTypeIncrease;
            self.tradeFormView.hidden = NO;
            break;
        case -100:
            // 买跌
            self.tradeFormView.tradeFormType = LGTradeFormTypeDecrease;
            self.tradeFormView.hidden = NO;
            break;
            
        default:
            break;
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (LCXStockChartView *)stockChartView {
    if (!_stockChartView) {
        _stockChartView = [[LCXStockChartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 440)];
        _stockChartView.itemModels = @[
                                       [LCXStockChartViewItemModel itemModelWithTitle:@"分时" lineType:LCXStocLineTypeTimeLine],
                                       [LCXStockChartViewItemModel itemModelWithTitle:@"1分钟" lineType:LCXStocLineTypeKLine],
                                       [LCXStockChartViewItemModel itemModelWithTitle:@"5分钟" lineType:LCXStocLineTypeKLine],
                                       [LCXStockChartViewItemModel itemModelWithTitle:@"日K" lineType:LCXStocLineTypeKLine]
                                       ];
        _stockChartView.dataSource = self;
    }
    return _stockChartView;
}

- (LGStockChartBuyToolBar *)buyToolBar {
    if (!_buyToolBar) {
        _buyToolBar = [[LGStockChartBuyToolBar alloc] init];
        _buyToolBar.delegate = self;
    }
    return _buyToolBar;
}

- (LGTradeFormView *)tradeFormView {
    if (!_tradeFormView) {
        _tradeFormView = [[NSBundle mainBundle] loadNibNamed:@"LGTradeFormView" owner:nil options:nil].lastObject;
        _tradeFormView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HEIGHT_STATUSBAR - HEIGHT_NAVBAR);
        [self.view addSubview:_tradeFormView];
    }
    return _tradeFormView;
}

- (void)dealloc {
    [self closeTimer];
}

@end

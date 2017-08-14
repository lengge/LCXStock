//
//  LCXStockChartView.m
//  LCXStock
//
//  Created by user on 17/5/31.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXStockChartView.h"
#import "LCXTimeLineView.h"
#import "LCXKLineView.h"
#import "LCXStockDetailView.h"
#import "LCXStockSegmentView.h"
#import "LCXStockViewMaskView.h"

@interface LCXStockChartView ()<LCXStockSegmentViewDelegate, LCXStockLongPressProtocol>

@property (nonatomic, strong) LCXTimeLineView *timeLineView;

@property (nonatomic, strong) LCXKLineView *kLineView;

@property (nonatomic, strong) LCXStockDetailView *stockDetailView;

@property (nonatomic, strong) LCXStockSegmentView *segmentView;

@property (nonatomic, strong) LCXStockViewMaskView *maskView;

@property (nonatomic, assign, readwrite) NSInteger currentIndex;

@property (nonatomic, assign) LCXStocLineType lineType;

@end

@implementation LCXStockChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setItemModels:(NSArray *)itemModels {
    _itemModels = itemModels;
    
    if (itemModels) {
        NSMutableArray *items = [NSMutableArray array];
        for (LCXStockChartViewItemModel *item in itemModels) {
            [items addObject:item.title];
        }
        self.segmentView.items = items;
        LCXStockChartViewItemModel *firstItem = [itemModels firstObject];
        self.lineType = firstItem.lineType;
    }
    
    if (self.dataSource) {
        self.segmentView.selectedIndex = 0;
    }
}

- (void)setStockDetailModel:(LCXStockDetailModel *)stockDetailModel {
    _stockDetailModel = stockDetailModel;
    
    self.stockDetailView.detailModel = stockDetailModel;
}

- (void)setDataSource:(id<LCXStockChartViewDataSource>)dataSource {
    _dataSource = dataSource;
    if (self.itemModels) {
        self.segmentView.selectedIndex = 0;
    }
}

/**
 *  重新加载数据
 */
-(void)reloadData {
    self.segmentView.selectedIndex = self.segmentView.selectedIndex;
}

#pragma mark - LCXStockSegmentViewDelegate
- (void)stockSegmentView:(LCXStockSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index {
    self.currentIndex = index;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)]) {
        id stockData = [self.dataSource stockDatasWithIndex:index];
        
        if (!stockData) {
            return;
        }
        
        LCXStockChartViewItemModel *itemModel = self.itemModels[index];
        LCXStocLineType type = itemModel.lineType;
        if (type != self.lineType) {
            self.lineType = type;
            if (type == LCXStocLineTypeKLine) {
                self.kLineView.hidden = NO;
                self.timeLineView.hidden = YES;
            } else {
                self.timeLineView.hidden = NO;
                self.kLineView.hidden = YES;
            }
        }
        
        if (type == LCXStocLineTypeTimeLine) {
            NSAssert([stockData isKindOfClass:[LCXTimeLineGroupModel class]], @"数据必须是LCXTimeLineGroupModel类型!!!");
            LCXTimeLineGroupModel *groupTimeLineModel = (LCXTimeLineGroupModel *)stockData;
            
            self.timeLineView.timeLineGroupModel = groupTimeLineModel;
            [self.timeLineView reDraw];
        } else {
            NSAssert([stockData isKindOfClass:[LCXKLineGroupModel class]], @"数据必须是LCXKLineGroupModel类型!!!");

            LCXKLineGroupModel *kLineGroupModel = (LCXKLineGroupModel *)stockData;
            self.kLineView.kLineType = self.kLineType;
            self.kLineView.kLineGroupModel = kLineGroupModel;
            [self.kLineView reDraw];
        }
    }
}

#pragma mark - LCXStockLongPressProtocol
/**
 长按开始或者改变位置
 */
- (void)longPressBeganAndChangedWithLineModel:(id)lineModel lineType:(LCXStocLineType)lineType {
    if (lineModel == nil) {
        self.maskView.hidden = YES;
    }
    
    if (lineType == LCXStocLineTypeKLine) {
        self.maskView.kLineModel = lineModel;
        self.maskView.place = [self.kLineView.kLineGroupModel.place integerValue];
    } else {
        self.maskView.timeLineModel = lineModel;
        self.maskView.place = [self.timeLineView.timeLineGroupModel.place integerValue];
    }
    
    self.maskView.stockLineType = lineType;
    [self.maskView setNeedsDisplay];
    self.maskView.hidden = NO;
}
/**
 长按结束
 */
- (void)longPressEnd {
    self.maskView.hidden = YES;
}

#pragma mark - 懒加载
- (LCXStockDetailView *)stockDetailView {
    if (!_stockDetailView) {
        _stockDetailView = [[NSBundle mainBundle] loadNibNamed:@"LCXStockDetailView" owner:nil options:nil].lastObject;
        [self addSubview:_stockDetailView];
        [_stockDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(118);
        }];
    }
    return _stockDetailView;
}

- (LCXStockSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[LCXStockSegmentView alloc] init];
        _segmentView.delegate = self;
        [self addSubview:_segmentView];
        WS(weakSelf);
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.stockDetailView.mas_bottom).offset(10);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(weakSelf.width - 30);
            make.height.mas_equalTo(40);
        }];
    }
    return _segmentView;
}

- (LCXStockViewMaskView *)maskView {
    if (!_maskView) {
        _maskView = [LCXStockViewMaskView new];
        _maskView.hidden = YES;
        [self addSubview:_maskView];
        WS(weakSelf);
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf.segmentView);
        }];
    }
    return _maskView;
}

- (LCXTimeLineView *)timeLineView {
    if (!_timeLineView) {
        _timeLineView = [LCXTimeLineView new];
        _timeLineView.delegate = self;
        [self addSubview:_timeLineView];
        WS(weakSelf);
        [_timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.segmentView.mas_bottom).offset(LCXStockChartKLineSelectedDateHeight);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(260);
        }];
    }
    return _timeLineView;
}

- (LCXKLineView *)kLineView {
    if (!_kLineView) {
        _kLineView = [LCXKLineView new];
        _kLineView.hidden = YES;
        _kLineView.delegate = self;
        [self addSubview:_kLineView];
        WS(weakSelf);
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.segmentView.mas_bottom).offset(LCXStockChartKLineSelectedDateHeight);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(260);
        }];
    }
    return _kLineView;
}

@end

/************************ItemModel类************************/
@implementation LCXStockChartViewItemModel

+ (instancetype)itemModelWithTitle:(NSString *)title lineType:(LCXStocLineType)lineType {
    LCXStockChartViewItemModel *itemModel = [[LCXStockChartViewItemModel alloc] init];
    itemModel.title = title;
    itemModel.lineType = lineType;
    return itemModel;
}

@end

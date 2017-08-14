//
//  LGStockChartBuyToolBar.m
//  Spread
//
//  Created by user on 17/6/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGStockChartBuyToolBar.h"
#import "LCXStockDetailModel.h"

#define KLineWidth 120

@interface LGStockChartBuyToolBar ()

@property (nonatomic, strong) UIView *increaseLine;

@property (nonatomic, strong) UILabel *increaseCountLabel;

@property (nonatomic, strong) UIView *decreaseLine;

@property (nonatomic, strong) UILabel *decreaseCountLabel;

@property (nonatomic, strong) UILabel *tradeLabel;

@property (nonatomic, strong) UIButton *buyIncreaseButton;

@property (nonatomic, strong) UIButton *buyDecreaseButton;

@end

@implementation LGStockChartBuyToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        
        [self addSubview:self.increaseLine];
        [self addSubview:self.increaseCountLabel];
        [self addSubview:self.tradeLabel];
        [self addSubview:self.decreaseCountLabel];
        [self addSubview:self.decreaseLine];
        [self addSubview:self.buyIncreaseButton];
        [self addSubview:self.buyDecreaseButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    @weakify(self);
    [self.tradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weak_self);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(12);
    }];
    
    [self.increaseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weak_self.tradeLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(weak_self.tradeLabel);
    }];
    
    [self.increaseLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weak_self.increaseCountLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(weak_self.tradeLabel);
        make.width.mas_equalTo(0).priorityMedium();
        make.height.mas_equalTo(4);
    }];
    
    [self.decreaseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weak_self.tradeLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(weak_self.tradeLabel);
    }];
    
    [self.decreaseLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weak_self.decreaseCountLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(weak_self.tradeLabel);
        make.width.mas_equalTo(0).priorityMedium();
        make.height.mas_equalTo(4);
    }];
    
    [self.buyIncreaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weak_self.tradeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(weak_self.mas_centerX).offset(-22.5);
    }];
    
    [self.buyDecreaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weak_self.buyIncreaseButton);
        make.left.mas_equalTo(weak_self.mas_centerX).offset(22.5);
        make.right.mas_equalTo(-15);
    }];
    
    self.increaseLine.layer.cornerRadius = 2.f;
    self.increaseLine.layer.masksToBounds = YES;
    
    self.decreaseLine.layer.cornerRadius = 2.f;
    self.decreaseLine.layer.masksToBounds = YES;
}

- (void)setStockDetailModel:(LCXStockDetailModel *)stockDetailModel {
    _stockDetailModel = stockDetailModel;
    
    self.increaseCountLabel.text = stockDetailModel.bids;
    
    self.decreaseCountLabel.text = stockDetailModel.asks;
    
    [self.increaseLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([stockDetailModel.bids integerValue] > 5 ? [stockDetailModel.bids integerValue] : 5);
    }];
    
    [self.decreaseLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([stockDetailModel.asks integerValue] > 5 ? [stockDetailModel.asks integerValue] : 5);
    }];
}

- (void)buttonClicked:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyToolBar:buyButtonClicked:)]) {
        [self.delegate buyToolBar:self buyButtonClicked:button];
    }
}

- (UIView *)increaseLine {
    if (!_increaseLine) {
        _increaseLine = [UIView new];
        _increaseLine.backgroundColor = [UIColor colorWithHexString:@"#f14a51"];
    }
    return _increaseLine;
}

- (UIView *)decreaseLine {
    if (!_decreaseLine) {
        _decreaseLine = [UIView new];
        _decreaseLine.backgroundColor = [UIColor colorWithHexString:@"#00be7b"];
    }
    return _decreaseLine;
}

- (UILabel *)increaseCountLabel {
    if (!_increaseCountLabel) {
        _increaseCountLabel = [UILabel new];
        _increaseCountLabel.text = @"0";
        _increaseCountLabel.textColor = [UIColor colorWithHexString:@"#f14a51"];
        _increaseCountLabel.font = [UIFont systemFontOfSize:12];
    }
    return _increaseCountLabel;
}

- (UILabel *)decreaseCountLabel {
    if (!_decreaseCountLabel) {
        _decreaseCountLabel = [UILabel new];
        _decreaseCountLabel.text = @"0";
        _decreaseCountLabel.textColor = [UIColor colorWithHexString:@"#00be7b"];
        _decreaseCountLabel.font = [UIFont systemFontOfSize:12];
    }
    return _decreaseCountLabel;
}

- (UILabel *)tradeLabel {
    if (!_tradeLabel) {
        _tradeLabel = [UILabel new];
        _tradeLabel.text = @"买卖量";
        _tradeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _tradeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _tradeLabel;
}

- (UIButton *)buyIncreaseButton {
    if (!_buyIncreaseButton) {
        _buyIncreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyIncreaseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_buyIncreaseButton setTitle:@"买涨" forState:UIControlStateNormal];
        [_buyIncreaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyIncreaseButton setBackgroundImage:[UIImage imageNamed:@"details-button-red"] forState:UIControlStateNormal];
        _buyIncreaseButton.tag = 100;
        [_buyIncreaseButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyIncreaseButton;
}

- (UIButton *)buyDecreaseButton {
    if (!_buyDecreaseButton) {
        _buyDecreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyDecreaseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_buyDecreaseButton setTitle:@"买跌" forState:UIControlStateNormal];
        [_buyDecreaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyDecreaseButton setBackgroundImage:[UIImage imageNamed:@"details-button-green"] forState:UIControlStateNormal];
        _buyDecreaseButton.tag = -100;
        [_buyDecreaseButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyDecreaseButton;
}

@end

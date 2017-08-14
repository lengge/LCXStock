//
//  LCXStockSegmentView.m
//  LCXStock
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXStockSegmentView.h"
#import "UIColor+LCXStock.h"
#import "LCXStockMacro.h"

static NSInteger const LCXStockSegmentStartTag = 2000;
static CGFloat const LCXStockSegmentViewIndicatorViewHeight = 2;

@interface LCXStockSegmentView ()

/**
 当前选中的按钮
 */
@property (nonatomic, strong) UIButton *selectedButton;

/**
 标题下方指示器
 */
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation LCXStockSegmentView

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.backgroundColor = [UIColor segmentTitleColor];
        [self addSubview:_indicatorView];
        WS(weakSelf);
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(LCXStockSegmentViewIndicatorViewHeight);
            make.width.mas_equalTo(weakSelf.mas_width).multipliedBy(1.0f / self.items.count);
            make.centerX.mas_equalTo(weakSelf);
        }];
        [self layoutIfNeeded];
    }
    return _indicatorView;
}

- (instancetype)initWithItems:(NSArray *)items {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.items = items;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    }
    return self;
}

- (void)setItems:(NSArray *)items {
    _items = items;
    if (!self.items || self.items.count == 0) {
        return;
    }
    
    NSInteger idx = 0;
    UIButton *preButton = nil;
    WS(weakSelf);
    for (NSString *title in self.items) {
        UIButton *button = [self createButtonWithTitle:title tag:LCXStockSegmentStartTag + idx];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-LCXStockSegmentViewIndicatorViewHeight);
            make.width.mas_equalTo(weakSelf.mas_width).multipliedBy(1.0f / self.items.count);
            if (preButton) {
                make.left.mas_equalTo(preButton.mas_right);
            } else {
                make.left.mas_equalTo(0);
            }
        }];
        preButton = button;
        idx++;
    }
}

- (UIButton *)createButtonWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor segmentTitleColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.tag = tag;
    [button addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    UIButton *button = (UIButton *)[self viewWithTag:LCXStockSegmentStartTag + selectedIndex];
    NSAssert(button, @"Segment的按钮还没有初始化完毕!");
    [self event_segmentButtonClicked:button];
}

- (void)setSelectedButton:(UIButton *)selectedButton {
    if (_selectedButton == selectedButton) {
        return;
    }
    
    _selectedButton = selectedButton;
    _selectedIndex = selectedButton.tag - LCXStockSegmentStartTag;
    WS(weakSelf);
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(LCXStockSegmentViewIndicatorViewHeight);
        make.width.mas_equalTo(weakSelf.mas_width).multipliedBy(1.0f / self.items.count);
        make.centerX.mas_equalTo(selectedButton.mas_centerX);
    }];
    [UIView animateWithDuration:0.2f animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)event_segmentButtonClicked:(UIButton *)button {
    self.selectedButton = button;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stockSegmentView:clickSegmentButtonIndex:)]) {
        [self.delegate stockSegmentView:self clickSegmentButtonIndex:button.tag - LCXStockSegmentStartTag];
    }
}

@end

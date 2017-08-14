//
//  LCXStockSegmentView.h
//  LCXStock
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCXStockSegmentViewDelegate;
/************************选择器************************/
@interface LCXStockSegmentView : UIView

@property (nonatomic, weak) id<LCXStockSegmentViewDelegate>delegate;

@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, strong) NSArray *items;

/**
 初始化方法
 */
- (instancetype)initWithItems:(NSArray *)items;

@end


/************************选择器代理************************/
@protocol LCXStockSegmentViewDelegate <NSObject>

@optional
- (void)stockSegmentView:(LCXStockSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index;

@end

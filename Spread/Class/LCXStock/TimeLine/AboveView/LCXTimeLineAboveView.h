//
//  LCXTimeLineAboveView.h
//  LCXStock
//
//  Created by user on 17/5/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCXStockChartConstant.h"

@class LCXTimeLineGroupModel, LCXTimeLineModel;
@protocol LCXTimeLineAboveViewDelegate;
/************************分时线上面的view************************/
@interface LCXTimeLineAboveView : UIView

/**
 分时线的模型
 */
@property (nonatomic, strong) LCXTimeLineGroupModel *groupModel;

@property (nonatomic, weak) id<LCXTimeLineAboveViewDelegate>delegate;

/**
 画AboveView
 */
- (void)drawAboveView;

/**
 长按的时候根据原始的x的位置获得精确的X的位置
 */
- (CGPoint)getRightXPositionWithOriginXPosition:(CGFloat)originXPosition;

@end

/************************代理方法************************/
@protocol LCXTimeLineAboveViewDelegate <NSObject>

@optional
- (void)timeLineAboveView:(UIView *)timeLineAboveView positionModels:(NSArray *)positionModels;

- (void)timeLineAboveView:(UIView *)timeLineAboveView longPressTimeLineModel:(LCXTimeLineModel *)timeLineModel;

@end

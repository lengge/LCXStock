//
//  LCXLineAboveView.h
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCXKLineModel.h"
#import "LCXKLinePositionModel.h"
#import "LCXStockChartConstant.h"
#import "LCXKLineGroupModel.h"

@protocol LCXLineAboveViewDelegate;
/************************上面的图(K线/折线)************************/
@interface LCXLineAboveView : UIView

@property (nonatomic, strong) LCXKLineGroupModel *kLineGroupModel;

/**
 *  股票模型数组
 */
@property (nonatomic, strong) NSArray *kLineModels;

/**
 *  父view，该父view为UIScrollView
 */
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

/**
 *  K线类型
 */
@property (nonatomic, assign) LCXStockChartKLineType kLineType;

/**
 *  代理
 */
@property (nonatomic, weak) id<LCXLineAboveViewDelegate> delegate;

/**
 *  画AboveView上的所有图
 */
- (void)drawAboveView;

/**
 *  更新AboveView的宽度
 */
- (void)updateAboveViewWidth;

/**
 *  长按的时候根据原始的x的位置获得精确的X的位置
 */
- (CGPoint)getRightXPositionWithOriginXPosition:(CGFloat)originXPosition;

/**
 *  移除所有监听
 */
- (void)removeAllObserver;

@end


/************************HYKLineAboveView的代理方法************************/
@protocol LCXLineAboveViewDelegate <NSObject>

@optional
/**
 *  长按后展示手指按着的HYKLinePositionModel和HYKLineModel
 */
- (void)kLineAboveViewLongPressKLinePositionModel:(LCXKLinePositionModel *)kLinePositionModel kLineModel:(LCXKLineModel *)kLineModel;

/**
 *  当前AboveView中的最大股价和最小股价
 */
- (void)kLineAboveViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice;

/**
 *  当前需要绘制的K线模型数组
 */
- (void)kLineAboveViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels;

/**
 *  当前需要绘制的K线位置模型数组
 */
- (void)kLineAboveViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels;

/**
 *  当前需要绘制的K线的颜色数组
 */
- (void)kLineAboveViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors;

@end

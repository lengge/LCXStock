//
//  LCXKLineBelowView.h
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCXKLineBelowViewDelegate;
/************************下面的图(成交量/平均线)************************/
@interface LCXKLineBelowView : UIView

/**
 *  需要画出来的k线的模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineModels;

/**
 *  需要绘制的K线的X位置的数组
 */
@property (nonatomic, strong) NSArray *needDrawKLinePositionModels;

/**
 *  K线的颜色
 */
@property (nonatomic, strong) NSArray *kLineColors;

/**
 *  代理
 */
@property (nonatomic, weak) id<LCXKLineBelowViewDelegate> delegate;

/**
 *  绘制BelowView
 */
- (void)drawBelowView;

@end


/************************HYKLineBelowView的代理方法************************/
@protocol LCXKLineBelowViewDelegate <NSObject>

@optional
/**
 *  绘制的成交量中最大的成交量和最小的成交量
 */
- (void)kLineBelowViewCurrentMaxVolume:(CGFloat)maxVolume minVolume:(CGFloat)minVolume;

@end

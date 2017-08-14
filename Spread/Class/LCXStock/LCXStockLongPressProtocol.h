//
//  LCXStockLongPressProtocol.h
//  LCXStock
//
//  Created by user on 17/5/26.
//  Copyright © 2017年 user. All rights reserved.
//

#ifndef LCXStockLongPressProtocol_h
#define LCXStockLongPressProtocol_h


#endif /* LCXStockLongPressProtocol_h */

#import "LCXStockChartConstant.h"

@protocol LCXStockLongPressProtocol <NSObject>

@optional
/**
 长按开始或者改变位置
 */
- (void)longPressBeganAndChangedWithLineModel:(id)lineModel lineType:(LCXStocLineType)lineType;
/**
 长按结束
 */
- (void)longPressEnd;

@end

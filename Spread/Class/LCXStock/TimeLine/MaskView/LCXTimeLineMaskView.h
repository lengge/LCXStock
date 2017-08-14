//
//  LCXTimeLineMaskView.h
//  LCXStock
//
//  Created by user on 17/5/26.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCXTimeLineModel.h"

@interface LCXTimeLineMaskView : UIView

/**
 分时线模型
 */
@property (nonatomic, strong) LCXTimeLineModel *timeLineModel;

/**
 当前选中位置
 */
@property (nonatomic, assign) CGPoint timeLinePosition;

- (void)drawMaskView;

@end

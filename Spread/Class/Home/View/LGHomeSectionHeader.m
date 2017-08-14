//
//  LGHomeSectionHeader.m
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGHomeSectionHeader.h"
#import "LGTool.h"

const CGFloat LGHomeSectionHeaderTopMargin = 5;

@interface LGHomeSectionHeader ()

@end

@implementation LGHomeSectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画背景
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, LGHomeSectionHeaderTopMargin, rect.size.width, rect.size.height - LGHomeSectionHeaderTopMargin));
    // 画线区域
    CGFloat lineWidth = 3.0f;
    CGFloat lineHeight = 20.0f;
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"fa6268"].CGColor);
    CGContextFillRect(context, CGRectMake(0, (rect.size.height - lineHeight - LGHomeSectionHeaderTopMargin) / 2 + LGHomeSectionHeaderTopMargin, lineWidth, lineHeight));
    // 画文字
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]};
    NSString *drawText = @"交易品种";
    CGSize textSize = [LGTool rectOfString:drawText attributes:attributes].size;
    [drawText drawAtPoint:CGPointMake(lineWidth + 12, (rect.size.height - textSize.height - LGHomeSectionHeaderTopMargin) / 2 + LGHomeSectionHeaderTopMargin) withAttributes:attributes];
}

@end

//
//  LGTradeCell.h
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGTradeModel;
@interface LGTradeCell : UITableViewCell

@property (nonatomic, strong) LGTradeModel *tradeModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

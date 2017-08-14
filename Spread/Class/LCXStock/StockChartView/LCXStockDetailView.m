//
//  LCXStockDetailView.m
//  LCXStock
//
//  Created by user on 17/5/31.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXStockDetailView.h"
#import "LCXStockDetailModel.h"

@interface LCXStockDetailView ()

@property (weak, nonatomic) IBOutlet UILabel *symbolnameLabel;

@property (weak, nonatomic) IBOutlet UILabel *tradestatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *updownLabel;

@property (weak, nonatomic) IBOutlet UILabel *updownrateLabel;

@property (weak, nonatomic) IBOutlet UILabel *highpLabel;

@property (weak, nonatomic) IBOutlet UILabel *lowpLabel;

@property (weak, nonatomic) IBOutlet UILabel *openpLabel;

@property (weak, nonatomic) IBOutlet UILabel *precloseLabel;

/**
 涨速
 */
@property (weak, nonatomic) IBOutlet UILabel *changespeedLabel;

/**
 波动
 */
@property (weak, nonatomic) IBOutlet UILabel *fluctuateLabel;

@end

@implementation LCXStockDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setDetailModel:(LCXStockDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.symbolnameLabel.text = [NSString stringWithFormat:@"%@%@%@", detailModel.symbolname, detailModel.symbol, detailModel.lasttradingdate];
    
    self.tradestatusLabel.text = detailModel.tradestatustext;
    
    self.highpLabel.text = detailModel.highp;
    
    self.lowpLabel.text = detailModel.lowp;
    
    self.fluctuateLabel.text = detailModel.fluctuate;
    
    self.openpLabel.text = detailModel.openp;
    
    self.precloseLabel.text = detailModel.preclose;
    
    self.changespeedLabel.text = detailModel.changespeed;
    
    self.nowPriceLabel.text = detailModel.nowv;
    
    self.updownLabel.text = detailModel.updown;
    
    self.updownrateLabel.text = detailModel.updownrate;
    
    if ([detailModel.updownrate floatValue] > 0) {
        self.nowPriceLabel.textColor = [UIColor colorWithHexString:@"#f15353"];
        self.updownLabel.textColor = [UIColor colorWithHexString:@"#f15353"];
        self.updownrateLabel.textColor = [UIColor colorWithHexString:@"#f15353"];
    } else if ([detailModel.updownrate floatValue] < 0) {
        self.nowPriceLabel.textColor = [UIColor colorWithHexString:@"#00be7b"];
        self.updownLabel.textColor = [UIColor colorWithHexString:@"#00be7b"];
        self.updownrateLabel.textColor = [UIColor colorWithHexString:@"#00be7b"];
    } else {
        self.nowPriceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.updownLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.updownrateLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
}

@end

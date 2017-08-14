//
//  LGTradeCell.m
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGTradeCell.h"
#import "LGTradeModel.h"

@interface LGTradeCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *statusIcon;

@property (nonatomic, strong) UILabel *summaryLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *ratioLabel;

@property (nonatomic, strong) UIImageView *backImage;

@end

@implementation LGTradeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"LGTradeCell";
    LGTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LGTradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self.contentView addSubview:self.backImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.statusIcon];
        [self.contentView addSubview:self.summaryLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.ratioLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    @weakify(self);
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(18);
    }];
    
    [self.statusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weak_self.nameLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(weak_self.nameLabel);
    }];
    
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weak_self.nameLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(weak_self.nameLabel);
        make.height.mas_equalTo(12);
    }];
    
    [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(weak_self);
        make.width.mas_equalTo(60);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weak_self.ratioLabel.mas_left).offset(-24);
        make.centerY.mas_equalTo(weak_self);
    }];
}

- (void)setTradeModel:(LGTradeModel *)tradeModel {
    _tradeModel = tradeModel;
    
    if ([tradeModel.updownrate floatValue] > 0.f) {
        self.priceLabel.textColor = [UIColor colorWithHexString:@"#fa6268"];
        self.ratioLabel.textColor = [UIColor colorWithHexString:@"#fa6268"];
        self.backImage.image = [UIImage imageNamed:@"beats-rose"];
    } else if ([tradeModel.updownrate floatValue] < 0.f) {
        self.priceLabel.textColor = [UIColor colorWithHexString:@"#1dbd7d"];
        self.ratioLabel.textColor = [UIColor colorWithHexString:@"#1dbd7d"];
        self.backImage.image = [UIImage imageNamed:@"beats"];
    } else {
        self.priceLabel.textColor = [UIColor colorWithHexString:@"#444444"];
        self.ratioLabel.textColor = [UIColor colorWithHexString:@"#444444"];
        self.backImage.image = [UIImage new];
    }
    
    if ([self.priceLabel.text floatValue] != [tradeModel.nowv floatValue] ||
        [self.ratioLabel.text floatValue] != [tradeModel.updownrate floatValue]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backImage.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.backImage.alpha = 0.0;
            }];
        }];
    }
    
    self.nameLabel.text = tradeModel.symbolname;
    
    self.summaryLabel.text = tradeModel.introduce;
    
    self.priceLabel.text = tradeModel.nowv;
    
    self.ratioLabel.text = tradeModel.updownrate;
    
    if ([tradeModel.openstatus integerValue] == 1) {
        self.statusIcon.image = [UIImage imageNamed:@"Trading in"];
    } else {
        self.statusIcon.image = [UIImage imageNamed:@"not open"];
    }
}

#pragma mark - 懒加载
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (UIImageView *)statusIcon {
    if (!_statusIcon) {
        _statusIcon = [UIImageView new];
    }
    return _statusIcon;
}

- (UILabel *)summaryLabel {
    if (!_summaryLabel) {
        _summaryLabel = [UILabel new];
        _summaryLabel.font = [UIFont systemFontOfSize:12];
        _summaryLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _summaryLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont systemFontOfSize:17];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    }
    return _priceLabel;
}

- (UILabel *)ratioLabel {
    if (!_ratioLabel) {
        _ratioLabel = [UILabel new];
        _ratioLabel.font = [UIFont systemFontOfSize:17];
        _ratioLabel.textColor = [UIColor colorWithHexString:@"#444444"];
        _ratioLabel.textAlignment = NSTextAlignmentRight;
    }
    return _ratioLabel;
}

- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [UIImageView new];
        _backImage.alpha = 0.0;
    }
    return _backImage;
}

@end

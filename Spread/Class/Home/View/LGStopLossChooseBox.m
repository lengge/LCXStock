//
//  LGStopLossChooseBox.m
//  Spread
//
//  Created by user on 17/6/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGStopLossChooseBox.h"

/******************************选择框Cell******************************/
@interface LGStopLossChooseBoxCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

@implementation LGStopLossChooseBoxCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"LGStopLossChooseBoxCell";
    LGStopLossChooseBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LGStopLossChooseBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

@end


/******************************选择框******************************/
@interface LGStopLossChooseBox ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LGStopLossChooseBox

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weak_self);
        make.height.mas_equalTo(160);
        make.width.mas_equalTo(weak_self.mas_width).multipliedBy(0.7);
    }];
    
    self.tableView.layer.cornerRadius = 15;
    self.tableView.layer.masksToBounds = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

- (void)setStopLoss:(CGFloat)stopLoss {
    _stopLoss = stopLoss;
    
    for (NSInteger i = 1; i < 5 ; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"%.2f", stopLoss * i]];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGStopLossChooseBoxCell *cell = [LGStopLossChooseBoxCell cellWithTableView:tableView];
    
    cell.contentLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *stopLoss = self.dataArray[indexPath.row];
    if (self.selectedStopLossBlock) {
        self.selectedStopLossBlock(stopLoss);
    }
    
    [self removeFromSuperview];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorColor = [UIColor colorWithHexString:@"#e5e5e5"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end

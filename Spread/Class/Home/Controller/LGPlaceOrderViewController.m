//
//  LGPlaceOrderViewController.m
//  Spread
//
//  Created by user on 17/6/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGPlaceOrderViewController.h"
#import <UIImage+YYAdd.h>
#import "LGStopLossChooseBox.h"

@interface LGPlaceOrderViewController ()

@property (nonatomic, strong) UIView *IndicatorView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *toolBar;

@property (weak, nonatomic) IBOutlet UIButton *buyIncreaseButton;

@property (weak, nonatomic) IBOutlet UIButton *buyDecreaseButton;

@property (nonatomic, weak) UIButton *lastSelBuyButton;

@property (weak, nonatomic) IBOutlet UIButton *oneButton;

@property (weak, nonatomic) IBOutlet UIButton *twoButton;

@property (weak, nonatomic) IBOutlet UIButton *threeButton;

@property (weak, nonatomic) IBOutlet UIButton *fourButton;

@property (weak, nonatomic) IBOutlet UIButton *fiveButton;

@property (nonatomic, weak) UIButton *lastSelButton;

@property (weak, nonatomic) IBOutlet UILabel *stopLossLabel;

@property (nonatomic, strong) LGStopLossChooseBox *stopLossChooseBox;

@end

@implementation LGPlaceOrderViewController

- (instancetype)init {
    return [[UIStoryboard storyboardWithName:@"LGHomeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"LGPlaceOrderViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    self.scrollView.alwaysBounceVertical = YES;
    
    self.toolBar.layer.borderColor = [UIColor colorWithHexString:@"#e8e8e8"].CGColor;
    self.toolBar.layer.borderWidth = 0.5f;
    
    [self.toolBar addSubview:self.IndicatorView];
    @weakify(self);
    [self.IndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(40);
        make.centerX.mas_equalTo(weak_self.buyIncreaseButton);
    }];
    
    [self.oneButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.oneButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4d64ab"]] forState:UIControlStateSelected];
    self.oneButton.layer.cornerRadius = 2.f;
    self.oneButton.layer.masksToBounds = YES;
    self.oneButton.layer.borderColor = [UIColor colorWithHexString:@"#4d64ab"].CGColor;
    self.oneButton.layer.borderWidth = 0.5;
    
    [self.twoButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.twoButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4d64ab"]] forState:UIControlStateSelected];
    self.twoButton.layer.cornerRadius = 2.f;
    self.twoButton.layer.masksToBounds = YES;
    self.twoButton.layer.borderColor = [UIColor colorWithHexString:@"#4d64ab"].CGColor;
    self.twoButton.layer.borderWidth = 0.5;
    
    [self.threeButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.threeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4d64ab"]] forState:UIControlStateSelected];
    self.threeButton.layer.cornerRadius = 2.f;
    self.threeButton.layer.masksToBounds = YES;
    self.threeButton.layer.borderColor = [UIColor colorWithHexString:@"#4d64ab"].CGColor;
    self.threeButton.layer.borderWidth = 0.5;
    
    [self.fourButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.fourButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4d64ab"]] forState:UIControlStateSelected];
    self.fourButton.layer.cornerRadius = 2.f;
    self.fourButton.layer.masksToBounds = YES;
    self.fourButton.layer.borderColor = [UIColor colorWithHexString:@"#4d64ab"].CGColor;
    self.fourButton.layer.borderWidth = 0.5;
    
    [self.fiveButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.fiveButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4d64ab"]] forState:UIControlStateSelected];
    self.fiveButton.layer.cornerRadius = 2.f;
    self.fiveButton.layer.masksToBounds = YES;
    self.fiveButton.layer.borderColor = [UIColor colorWithHexString:@"#4d64ab"].CGColor;
    self.fiveButton.layer.borderWidth = 0.5;
}

- (IBAction)buyButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (self.lastSelBuyButton == button) {
        return;
    }
    
    button.selected = YES;
    self.lastSelBuyButton.selected = NO;
    self.lastSelBuyButton = button;
    
    [self.IndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(40);
        make.centerX.mas_equalTo(button);
    }];
    
    switch (button.tag) {
        case 2001:
            // 买涨
            break;
        case 2002:
            // 买跌
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置交易数量按钮
- (IBAction)handButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.lastSelButton == button) {
        return;
    }
    
    button.selected = YES;
    self.lastSelButton.selected = NO;
    self.lastSelButton = button;
    
    switch (button.tag) {
        case 3001:
            
            break;
        case 3002:
            
            break;
        case 3003:
            
            break;
        case 3004:
            
            break;
        case 3005:
            
            break;
            
        default:
            break;
    }
}

- (IBAction)helpButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1001:
            // 止盈帮助
            [self showAlertTitle:@"为什么要设置止盈?" message:@"既然是盈利，让利润更大一些不是更好么？但是我们要知道，交易中未平持仓产生的浮动盈利并不算真正的盈利，只有平仓结算才是真正获利，所以在达到自己的投资盈利目标的基础上，合理的设置止盈点位，保障自己投资的盈利也是很重要的。"];
            break;
        case 1002:
            // 止损帮助
            [self showAlertTitle:@"为什么要设置止损?" message:@"为什么要设置止损？止损是指在交易方向与市场走势相悖、导致亏损出现时，在一定范围内设置平仓触发指令，指令触发时以市场成交，以避免出现无法控制的损失情况。止损的作用是自我保护，\"刹车装置\"保存实力，提高资金利用率。"];
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置止损按钮
- (IBAction)stopLossChooseButtonClicked:(id)sender {
    self.stopLossChooseBox.stopLoss = [self.stopLossLabel.text floatValue];
    [kKeyWindow addSubview:self.stopLossChooseBox];
}

- (void)showAlertTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    if ([alert valueForKey:@"attributedTitle"]) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:alert.title];
        NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]};
        [attString addAttributes:attrs range:NSMakeRange(0, attString.length)];
        [alert setValue:attString forKey:@"attributedTitle"];
    }
    if ([alert valueForKey:@"attributedMessage"]) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:alert.title];
        NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]};
        [attString addAttributes:attrs range:NSMakeRange(0, attString.length)];
        [alert setValue:attString forKey:@"attributedMessage"];
    }
    if ([cancelAction valueForKey:@"titleTextColor"]) {
        [cancelAction setValue:[UIColor colorWithHexString:@"#007aff"] forKey:@"titleTextColor"];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIView *)IndicatorView {
    if (!_IndicatorView) {
        _IndicatorView = [UIView new];
        _IndicatorView.backgroundColor = [UIColor colorWithHexString:@"#4d64ab"];
    }
    return _IndicatorView;
}

- (LGStopLossChooseBox *)stopLossChooseBox {
    if (!_stopLossChooseBox) {
        _stopLossChooseBox = [[LGStopLossChooseBox alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        @weakify(self);
        _stopLossChooseBox.selectedStopLossBlock = ^(NSString *stopLoss) {
            weak_self.stopLossLabel.text = stopLoss;
        };
    }
    return _stopLossChooseBox;
}

@end

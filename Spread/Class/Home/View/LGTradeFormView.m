//
//  LGTradeFormView.m
//  Spread
//
//  Created by user on 17/6/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGTradeFormView.h"
#import <UIImage+YYAdd.h>
#import "UIView+LGAdd.h"
#import "LGPlaceOrderViewController.h"

@interface LGTradeFormView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *oneButton;

@property (weak, nonatomic) IBOutlet UIButton *twoButton;

@property (weak, nonatomic) IBOutlet UIButton *threeButton;

@property (weak, nonatomic) IBOutlet UIButton *fourButton;

@property (weak, nonatomic) IBOutlet UIButton *fiveButton;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *profitLossLabel;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, weak) UIButton *lastSelButton;

@end

@implementation LGTradeFormView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#444444" alpha:0.3];
    
    [self layoutIfNeeded];
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
    
    self.confirmButton.layer.cornerRadius = 2.f;
    self.confirmButton.layer.masksToBounds = YES;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"交易费用175.00+保证金1500.00="];
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]};
    [attrString setAttributes:attrs range:NSMakeRange(0, [attrString length])];
    
    attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]};
    NSAttributedString *appendStr = [[NSAttributedString alloc] initWithString:@"合计1675.00" attributes:attrs];
    [attrString appendAttributedString:appendStr];
    
    self.amountLabel.attributedText = attrString;
    
    attrString = [[NSMutableAttributedString alloc] initWithString:@"盈利2100.00止盈 亏损1050.00止损"];
    attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]};
    [attrString setAttributes:attrs range:NSMakeRange(0, [attrString length])];
    NSRange range = [[attrString string] rangeOfString:@"2100.00"];
    attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#f14a51"]};
    [attrString setAttributes:attrs range:range];
    
    range = [[attrString string] rangeOfString:@"1050.00"];
    attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#00be7b"]};
    [attrString setAttributes:attrs range:range];
    
    self.profitLossLabel.attributedText = attrString;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.bottomView];
    if (point.y < 0) {
        self.hidden = YES;
    }
}

- (void)setTradeFormType:(LGTradeFormType)tradeFormType {
    _tradeFormType = tradeFormType;
    
    if (tradeFormType == LGTradeFormTypeIncrease) {
        self.confirmButton.backgroundColor = [UIColor colorWithHexString:@"#f14a51"];
        [self.confirmButton setTitle:@"确定买涨" forState:UIControlStateNormal];
    } else if (tradeFormType == LGTradeFormTypeDecrease) {
        self.confirmButton.backgroundColor = [UIColor colorWithHexString:@"#00be7b"];
        [self.confirmButton setTitle:@"确定买跌" forState:UIControlStateNormal];
    }
}

- (void)showAlertTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBHUDHelper showWarningWithText:@"下单成功"];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    if ([alert valueForKey:@"attributedTitle"]) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:alert.title];
        NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]};
        [attString addAttributes:attrs range:NSMakeRange(0, attString.length)];
        [alert setValue:attString forKey:@"attributedTitle"];
    }
    if ([cancelAction valueForKey:@"titleTextColor"]) {
        [cancelAction setValue:[UIColor colorWithHexString:@"#007aff"] forKey:@"titleTextColor"];
    }
    if ([confirmAction valueForKey:@"titleTextColor"]) {
        [confirmAction setValue:[UIColor colorWithHexString:@"#007aff"] forKey:@"titleTextColor"];
    }
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)closeButtonClicked:(id)sender {
    self.hidden = YES;
}

- (IBAction)fullButtonClicked:(id)sender {
    LGPlaceOrderViewController *placeOrderVC = [[LGPlaceOrderViewController alloc] init];
    placeOrderVC.title = @"下单";
    [self.viewController.navigationController pushViewController:placeOrderVC animated:YES];
}

- (IBAction)confirmButtonClicked:(id)sender {
    [self showAlertTitle:@"确定买涨1手美元指数DX1706"];
}

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

@end

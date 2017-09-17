//
//  MEXExchangeView.m
//  MoneyExchange
//
//  Created by Max on 15/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXExchangeView.h"
#import "MEXMoney.h"
#import "MEXMoneyAccount.h"

@interface MEXExchangeView()
@property (nonatomic) UITextField* amountField;
@property (nonatomic) UILabel* rateLabel;
@property (nonatomic) UILabel* currencyLabel;
@property (nonatomic) UILabel* currentBalanceLabel;
@property (nonatomic) UILabel* resultBalanceLabel;
@end

@implementation MEXExchangeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    
    self.amountField = [UITextField new];
    [self addSubview:self.amountField];
    
    [self.amountField addTarget:self action:@selector(amountValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.amountField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.amountField.textAlignment = NSTextAlignmentCenter;
    self.amountField.borderStyle = UITextBorderStyleNone;
    self.amountField.keyboardType = UIKeyboardTypeNumberPad;
    self.amountField.textColor = [UIColor whiteColor];
    self.amountField.font = [UIFont systemFontOfSize:24.0];
    
    self.amountField.borderStyle = UITextBorderStyleNone;
    self.amountField.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *border = [UIView new];
    border.translatesAutoresizingMaskIntoConstraints = NO;
    border.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [self addSubview:border];
    
    NSLayoutConstraint* centerX = [NSLayoutConstraint constraintWithItem:self.amountField
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint* centerY = [NSLayoutConstraint constraintWithItem:self.amountField
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:-4];
    
    NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:self.amountField
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:120];
    
    NSLayoutConstraint* borderCenter = [NSLayoutConstraint constraintWithItem:border
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint* borderTop = [NSLayoutConstraint constraintWithItem:border
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.amountField
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1
                                                                    constant:0];
    
    NSLayoutConstraint* borderWidth = [NSLayoutConstraint constraintWithItem:border
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.amountField
                                                             attribute:NSLayoutAttributeWidth
                                                                  multiplier:1
                                                                    constant:0];
    
    NSLayoutConstraint* borderHeight = [NSLayoutConstraint constraintWithItem:border
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1
                                                                    constant:1.2];
    
    [NSLayoutConstraint activateConstraints:@[centerX, centerY, width, borderCenter, borderTop, borderWidth, borderHeight]];
    
    [self addCurrentBalance];
    
    [self addResultBalance];
    
    [self addRate];
    
    self.currencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, self.bounds.size.width, 21)];
    self.currencyLabel.textAlignment = NSTextAlignmentCenter;
    self.currencyLabel.textColor = [UIColor whiteColor];
    self.currencyLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [self addSubview:self.currencyLabel];
}

- (void)addCurrentBalance {
    
    UILabel* youHaveLabel = [UILabel new];
    youHaveLabel.text = NSLocalizedString(@"You have", @"Exchange screen - you have");
    youHaveLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    youHaveLabel.translatesAutoresizingMaskIntoConstraints = NO;
    youHaveLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:youHaveLabel];
    
    self.currentBalanceLabel = [UILabel new];
    self.currentBalanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.currentBalanceLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    self.currentBalanceLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.currentBalanceLabel];
    
    NSLayoutConstraint* leading = [NSLayoutConstraint constraintWithItem:self.currentBalanceLabel
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeftMargin
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint* trailing = [NSLayoutConstraint constraintWithItem:self.currentBalanceLabel
                                                               attribute:NSLayoutAttributeRightMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.amountField
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint* centerY = [NSLayoutConstraint constraintWithItem:self.amountField
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.currentBalanceLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint* youHaveLeft = [NSLayoutConstraint constraintWithItem:youHaveLabel
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.currentBalanceLabel
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1
                                                                    constant:0];
    
    NSLayoutConstraint* youHaveBottom = [NSLayoutConstraint constraintWithItem:self.currentBalanceLabel
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:youHaveLabel
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1
                                                                    constant:0];
    
    [NSLayoutConstraint activateConstraints:@[leading, trailing, centerY, youHaveLeft, youHaveBottom]];
}

- (void)addResultBalance {
    self.resultBalanceLabel = [UILabel new];
    self.resultBalanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultBalanceLabel.textColor = [UIColor whiteColor];
    self.resultBalanceLabel.alpha = 0.6;
    self.resultBalanceLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:self.resultBalanceLabel];
    
    NSLayoutConstraint* leading = [NSLayoutConstraint constraintWithItem:self.amountField
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.resultBalanceLabel
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint* trailing = [NSLayoutConstraint constraintWithItem:self.resultBalanceLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeRightMargin
                                                               multiplier:1
                                                                 constant:0];
    
    NSLayoutConstraint* centerY = [NSLayoutConstraint constraintWithItem:self.amountField
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.resultBalanceLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0];
    
    [NSLayoutConstraint activateConstraints:@[leading, trailing, centerY]];
}

- (void)addRate {
    self.rateLabel = [UILabel new];
    self.rateLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    self.rateLabel.font = [UIFont systemFontOfSize:10.0];
    self.rateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.rateLabel];
    
    NSLayoutConstraint* centerX = [NSLayoutConstraint constraintWithItem:self.amountField
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.rateLabel
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:self.rateLabel
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.amountField
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:8];
    
    [NSLayoutConstraint activateConstraints:@[centerX, top]];
}

- (void)amountValueDidChange:(UITextField*)field {
    MEXMoney* money = [MEXMoney fromString:field.text];
    if(self.valueDidChange) {
        self.valueDidChange(money);
    }
}

- (void)setAmount:(MEXMoney *)amount {
    self.amountField.text = [amount stringValue];
    if (self.account && amount) {
        NSString* result = [NSString stringWithFormat:@" = %@", [[self.account.balance add:amount] stringValue]];
        self.resultBalanceLabel.text = result;
    }
}

- (MEXMoney*)amount {
    return [MEXMoney fromString:self.amountField.text];
}

- (void)setRate:(MEXExchangeRate *)rate {
    self.rateLabel.text = [NSString stringWithFormat:@"1 %@ = %@ %@", rate.numerator.ISOCode, rate.denominator.ISOCode, rate.ratio];
}

- (void)setAccount:(MEXMoneyAccount *)account {
    _account = account;
    self.currencyLabel.text = account.currency.ISOCode;
    self.currentBalanceLabel.text = [account.balance stringValue];
}

- (BOOL)becomeFirstResponder {
    return [self.amountField becomeFirstResponder];
}
@end

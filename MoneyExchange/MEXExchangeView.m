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
@property (nonatomic) UITextField* amountFieldFake;
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
    
    [self addAmountFieldFake:YES];
    [self addAmountFieldFake:NO];
    
    [self addCurrentBalance];
    
    [self addResultBalance];
    
    [self addRate];
    
    self.currencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, self.bounds.size.width, 21)];
    self.currencyLabel.textAlignment = NSTextAlignmentCenter;
    self.currencyLabel.textColor = [UIColor whiteColor];
    self.currencyLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [self addSubview:self.currencyLabel];
}

- (UITextField*)addAmountFieldFake:(BOOL)isFake {
    UITextField* field = [UITextField new];
    if (isFake) {
        self.amountFieldFake = field;
        field.userInteractionEnabled = NO;
    } else {
        self.amountField = field;
    }
    
    [self addSubview:field];
    
    [field addTarget:self action:@selector(amountValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.placeholder = @"0";
    field.textAlignment = NSTextAlignmentCenter;
    field.borderStyle = UITextBorderStyleNone;
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.textColor = [UIColor whiteColor];
    field.font = [UIFont systemFontOfSize:24.0];
    
    field.borderStyle = UITextBorderStyleNone;
    field.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *border = [UIView new];
    border.translatesAutoresizingMaskIntoConstraints = NO;
    border.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [self addSubview:border];
    
    NSLayoutConstraint* centerX = [NSLayoutConstraint constraintWithItem:field
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint* centerY = [NSLayoutConstraint constraintWithItem:field
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:-4];
    
    NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:field
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
                                                                    toItem:field
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:0];
    
    NSLayoutConstraint* borderWidth = [NSLayoutConstraint constraintWithItem:border
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:field
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
    
    return field;
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
    MEXMoney* money = [self amount];
    if(self.valueDidChange) {
        self.valueDidChange(money);
    }
    [self updateUILabelsFor:money];
}

- (void)setAmount:(MEXMoney *)amount {
    [self updateUILabelsFor:amount];
    if (!amount || [amount isZero]) {
        return;
    }
    
    self.amountField.text = [amount stringValue];
}

- (void)updateUILabelsFor:(MEXMoney*)amount {
    if (self.account && amount && ![amount isZero]) {
        MEXMoney* preview;
        if (MEXExchangeViewTypeSource == self.type) {
            preview = [self.account.balance subtract:amount];
        } else {
            preview = [self.account.balance add:amount];
        }
        NSString* result = [NSString stringWithFormat:@" = %@", [preview stringValue]];
        self.resultBalanceLabel.text = result;
        
        NSString* sign = MEXExchangeViewTypeSource == self.type ? @"-   " : @"+   ";
        
        NSMutableAttributedString* signText = [[NSMutableAttributedString alloc] initWithString:sign attributes:@{}];
        
        NSDictionary<NSAttributedStringKey,id>* hiddenAttributes = @{
                                                               NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:0],
                                                               };
        NSAttributedString* hiddenString = [[NSMutableAttributedString alloc] initWithString:[amount stringValue]
                                                                                   attributes:hiddenAttributes];
        
        [signText appendAttributedString:hiddenString];
        self.amountFieldFake.attributedText = signText;
    } else {
        self.amountField.text = @"";
        self.resultBalanceLabel.text = @"";
        self.amountFieldFake.text = @"";
    }
}

- (MEXMoney*)amount {
    @try {
        return [MEXMoney fromString:self.amountField.text];
    } @catch (NSException* exception) {
        return [MEXMoney zero];
    }
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

//
//  MEXExchangeRowView.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXExchangeRowView.h"

@interface MEXExchangeRowView()
@property (nonatomic) UITextField* amountField;
@property (nonatomic) UILabel* rateLabel;
@end

@implementation MEXExchangeRowView


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    
    self.amountField = [UITextField new];
    [self addSubview:self.amountField];
    
    
    [self.amountField addTarget:self action:@selector(amountValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.amountField.borderStyle = UITextBorderStyleLine;
    self.amountField.keyboardType = UIKeyboardTypeNumberPad;
    self.amountField.textColor = [UIColor whiteColor];
    self.amountField.font = [UIFont systemFontOfSize:24.0];
    
    
    self.amountField.translatesAutoresizingMaskIntoConstraints = NO;
    
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
                                                                constant:0];
    
    NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:self.amountField
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1 constant:200];
    
    [NSLayoutConstraint activateConstraints:@[centerX, centerY, width]];
    
    self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
    self.rateLabel.textColor = [UIColor whiteColor];
    self.rateLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:self.rateLabel];
}


- (void)amountValueDidChange:(UITextField*)field {
    MEXMoney* money = [MEXMoney fromString:field.text];
    
    if ([self.delegate respondsToSelector:@selector(exchangeView:didChangeValue:)]) {
        [self.delegate exchangeView:self didChangeValue:money];
    }
}

- (void)setAmount:(MEXMoney *)amount {
    self.amountField.text = [amount stringValue];
}

-(void)setRate:(MEXExchangeRate *)rate {
    self.rateLabel.text = [NSString stringWithFormat:@"1 %@ = %@ %@", rate.numerator.ISOCode, rate.denominator.ISOCode, rate.ratio];
}
@end

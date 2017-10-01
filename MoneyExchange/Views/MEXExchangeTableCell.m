//
//  MEXExchangeTableCell.m
//  MoneyExchange
//
//  Created by Max on 22/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXExchangeTableCell.h"
#import "MEXCurrency.h"

@interface MEXExchangeTableCell() <UITextFieldDelegate>
@property (nonatomic, readwrite) MEXAmountTextField* amountField;
@property (nonatomic, readwrite) UILabel* currencyLabel;
@property (nonatomic, readwrite) UILabel* amountLabel;
@property (nonatomic, readwrite) MEXCurrency* currency;
@end

@implementation MEXExchangeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.currencyLabel = [self viewWithTag:1];
    self.amountField = [self viewWithTag:2];
    self.amountLabel = [self viewWithTag:3];
    
    self.amountField.delegate = self;
    [self.amountLabel setHidden:NO];
    [self.amountField setHidden:YES];
    
    [self.amountField addTarget:self action:@selector(amountDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:128.0 / 255.0 blue:255.0 / 255.0 alpha:0.1];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.parentTable selectRowAtIndexPath:self.indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)setAmount:(MEXMoney *)amount {
    self.amountField.text = [amount stringValue];
    [self displayFormattedValue];
}

- (void)setCurrency:(MEXCurrency *)currency {
    self.amountField.currency = currency;
    _currency = currency;
    
    self.currencyLabel.text = [NSString stringWithFormat:@"%@ %@", currency.flag, currency.ISOCode];
}

- (BOOL)becomeFirstResponder {
    return [self.amountField becomeFirstResponder];
}

- (void)amountDidChange:(UITextField*)field {
    [self displayFormattedValue];
}

- (void)displayFormattedValue {
    MEXMoney* amount = self.amountField.amount;
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
//    [formatter setCurrencyCode:self.currency.ISOCode];
    [formatter setCurrencySymbol:self.currency.sign];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSString* formatted = [formatter stringFromNumber:amount.value];
    
    self.amountLabel.text = formatted;
}

@end

//
//  MEXExchangeTableCell.m
//  MoneyExchange
//
//  Created by Max on 22/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXExchangeTableCell.h"

@interface MEXExchangeTableCell() <UITextFieldDelegate>
@property (nonatomic, readwrite) MEXAmountTextField* amountField;
@property (nonatomic, readwrite) UILabel* currencyLabel;
@end

@implementation MEXExchangeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.currencyLabel = [self viewWithTag:1];
    self.amountField = [self viewWithTag:2];
    self.amountField.delegate = self;
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

@end

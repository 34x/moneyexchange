//
//  MEXExchangeTableCell.m
//  MoneyExchange
//
//  Created by Max on 22/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXExchangeTableCell.h"

@interface MEXExchangeTableCell()
@property (nonatomic, readwrite) MEXAmountTextField* amountField;
@property (nonatomic, readwrite) UILabel* currencyLabel;
@end

@implementation MEXExchangeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.currencyLabel = [self viewWithTag:1];
    self.amountField = [self viewWithTag:2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:128.0 / 255.0 blue:255.0 / 255.0 alpha:0.2];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end

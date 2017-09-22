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
}

@end

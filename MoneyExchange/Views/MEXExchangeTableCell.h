//
//  MEXExchangeTableCell.h
//  MoneyExchange
//
//  Created by Max on 22/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEXAmountTextField.h"

@class MEXCurrency;

@interface MEXExchangeTableCell : UITableViewCell
@property (nonatomic, readonly) MEXAmountTextField* amountField;
@property (nonatomic, readonly) UILabel* currencyLabel;
@property (nonatomic, weak) UITableView* parentTable;
@property (nonatomic, weak) NSIndexPath* indexPath;

- (void) setAmount:(MEXMoney*)amount;
- (void) setCurrency:(MEXCurrency*)currency;
@end

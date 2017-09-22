//
//  MEXAmountTextField.h
//  MoneyExchange
//
//  Created by Max on 22/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEXMoney.h"
#import "MEXCurrency.h"

@interface MEXAmountTextField : UITextField
@property (nonatomic) MEXMoney* amount;
@property (nonatomic) MEXCurrency* currency;
@end

//
//  MEXExchangeView.h
//  MoneyExchange
//
//  Created by Max on 15/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEXMoney.h"
#import "MEXExchangeRate.h"

@class MEXMoneyAccount;

@interface MEXExchangeView : UIView
@property (nonatomic) void (^valueDidChange)(MEXMoney*);
@property (nonatomic) MEXMoney* amount;
@property (nonatomic) MEXMoneyAccount* account;

- (void)setRate:(MEXExchangeRate*)rate;
@end

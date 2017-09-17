//
//  MEXExchange.h
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEXMoneyAccount.h"
#import "MEXExchangeRate.h"
#import "MEXMoney.h"

typedef enum : NSUInteger {
    MEXExchangeAmountInSourceCurrency,
    MEXExchangeAmountInDestinationCurrency,
} MEXExchangeAmountType;

@interface MEXExchange : NSObject
@property (nonatomic, readonly) MEXExchangeAmountType amountType;
@property (nonatomic, readonly) MEXMoney* amount;
@property (nonatomic, readonly) MEXExchangeRate* rate;
@property (nonatomic, readonly) MEXMoney* result;
@property (nonatomic, readonly) MEXMoneyAccount* fromAccount;
@property (nonatomic, readonly) MEXMoneyAccount* toAccount;

+ (instancetype) exchangeFrom:(MEXMoneyAccount*)from
                           to:(MEXMoneyAccount*)to
                       amount:(MEXMoney*)amount
                     rate:(MEXExchangeRate*)rate
                   amountType:(MEXExchangeAmountType)amountType;

- (MEXMoney*) targetSubtract;
- (MEXMoney*) targetAdd;

@end

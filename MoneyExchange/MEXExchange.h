//
//  MEXExchange.h
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEXMoneyAccount.h"
#import "MEXMoney.h"

typedef enum : NSUInteger {
    MEXExchangeAmountTypeSource,
    MEXExchangeAmountTypeDestination,
} MEXExchangeAmountType;

@interface MEXExchange : NSObject
@property (nonatomic, readonly) MEXExchangeAmountType amountType;
@property (nonatomic, readonly) MEXMoney* amount;

+ (instancetype) exchangeFrom:(MEXMoneyAccount*)from
                           to:(MEXMoneyAccount*)to
                       amount:(MEXMoney*)amount;

+ (instancetype) exchangeFrom:(MEXMoneyAccount*)from
                           to:(MEXMoneyAccount*)to
                       amount:(MEXMoney*)amount
                   amountType:(MEXExchangeAmountType)amountType;
@end

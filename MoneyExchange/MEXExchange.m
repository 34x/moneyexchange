//
//  MEXExchange.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXExchange.h"

@interface MEXExchange()
@property (nonatomic, readwrite) MEXExchangeAmountType amountType;
@property (nonatomic, readwrite) MEXMoney* amount;
@property (nonatomic, readwrite) MEXExchangeRate* rate;
@property (nonatomic, readwrite) MEXMoney* result;
@property (nonatomic, readwrite) MEXMoneyAccount* fromAccount;
@property (nonatomic, readwrite) MEXMoneyAccount* toAccount;
@end

@implementation MEXExchange

+ (instancetype)exchangeFrom:(MEXMoneyAccount *)from
                          to:(MEXMoneyAccount *)to
                      amount:(MEXMoney*)amount
                        rate:(MEXExchangeRate*)rate
                  amountType:(MEXExchangeAmountType)amountType {

    MEXExchange* exchange = [MEXExchange new];
    exchange.fromAccount = from;
    exchange.toAccount = to;
    exchange.amount = amount;
    exchange.amountType = amountType;
    exchange.rate = rate;
    
    MEXMoney* exchangedAmount;
    if (amountType == MEXExchangeAmountInSourceCurrency) {
        exchangedAmount = [rate exchangeForward:amount];
    } else {
        exchangedAmount = [rate exchangeBackward:amount];
    }
    
    exchange.result = exchangedAmount;
    
    return exchange;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<MEXExchange: %@ -> %@ with amount %@, rate %@, type '%@'>",
            self.fromAccount,
            self.toAccount,
            [self.amount stringValue],
            self.rate, MEXExchangeAmountInSourceCurrency == self.amountType ? @"amount in source" : @"amount in destination"];
}

@end

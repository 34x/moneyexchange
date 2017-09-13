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
@end

@implementation MEXExchange

+ (instancetype)exchangeFrom:(MEXMoneyAccount *)from
                          to:(MEXMoneyAccount *)to
                      amount:(MEXMoney*)amount
                        rate:(MEXExchangeRate*)rate
                  amountType:(MEXExchangeAmountType)amountType {

    MEXExchange* exchange = [MEXExchange new];
    
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

@end

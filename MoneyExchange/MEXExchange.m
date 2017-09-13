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

@end

@implementation MEXExchange
+ (instancetype)exchangeFrom:(MEXMoneyAccount *)from
                          to:(MEXMoneyAccount *)to
                      amount:(MEXMoney *)amount
                  amountType:(MEXExchangeAmountType)amountType {

    MEXExchange* exchange = [MEXExchange new];
    
    exchange.amount = amount;
    exchange.amountType = amountType;
    
    return exchange;
}

@end

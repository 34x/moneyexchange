//
//  MEXExchangeResult.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXExchangeResult.h"

@interface MEXExchangeResult ()
@property (nonatomic, readwrite) MEXMoney* sourceAmount;
@property (nonatomic, readwrite) MEXMoney* destinationAmount;
@property (nonatomic, readwrite) MEXExchange* exchange;
@end

@implementation MEXExchangeResult
+ (instancetype) resultWithSourceAmount:(MEXMoney *)sourceAmount
          destinationAmount:(MEXMoney *)destinationAmount
                   exchange:(MEXExchange *)exchange {

    MEXExchangeResult* result = [MEXExchangeResult new];
    
    result.sourceAmount = sourceAmount;
    result.destinationAmount = destinationAmount;
    result.exchange = exchange;
    
    return result;
}
@end

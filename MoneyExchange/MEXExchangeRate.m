//
//  MEXExchangeRate.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXExchangeRate.h"

@interface MEXExchangeRate ()
@property (nonatomic, readwrite) MEXCurrency* numerator;
@property (nonatomic, readwrite) MEXCurrency* denominator;
@property (nonatomic, readwrite) NSNumber* ratio;
@end

@implementation MEXExchangeRate
+ (instancetype) rateWith:(MEXCurrency *)numerator
                     over:(MEXCurrency *)denominator
                withRatio:(NSNumber *)ratio {
    
    MEXExchangeRate* rate = [MEXExchangeRate new];
    rate.numerator = numerator;
    rate.denominator = denominator;
    rate.ratio = ratio;
    
    return rate;
}


- (MEXMoney*)exchangeForward:(MEXMoney *)amount {
    return [amount multiplyBy:self.ratio];
}

- (MEXMoney*)exchangeBackward:(MEXMoney *)amount {
    return [amount divideBy:self.ratio];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<MEXExchangeRate: %@ 1 = %@ %@>", self.numerator.ISOCode, self.denominator.ISOCode, self.ratio];
}

@end

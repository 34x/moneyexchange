//
//  MEXExchangeRate.h
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEXCurrency.h"
#import "MEXMoney.h"

@interface MEXExchangeRate : NSObject
@property (nonatomic, readonly) MEXCurrency* numerator;
@property (nonatomic, readonly) MEXCurrency* denominator;
@property (nonatomic, readonly) NSDecimalNumber* ratio;

+ (instancetype) rateWith:(MEXCurrency*)numerator over:(MEXCurrency*)denominator withRatio:(NSNumber*)ratio;

- (MEXMoney*)exchangeForward:(MEXMoney*)amount;
- (MEXMoney*)exchangeBackward:(MEXMoney*)amount;

@end

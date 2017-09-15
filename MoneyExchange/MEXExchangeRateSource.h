//
//  MEXExchangeRateSource.h
//  MoneyExchange
//
//  Created by Max on 14/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEXExchangeRate.h"
#import "MEXCurrency.h"

@interface MEXExchangeRateSource : NSObject
@property (nonatomic) NSTimeInterval updatePeriod;

- (MEXExchangeRate*) getRateFromCurrency:(MEXCurrency*)from toCurrency:(MEXCurrency*)to;
@end

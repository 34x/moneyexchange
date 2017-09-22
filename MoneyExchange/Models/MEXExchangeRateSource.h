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

@protocol MEXExchangeRateSourceDelegate <NSObject>

@optional
- (void)rateSourceRatesDidLoad:(NSError*) error;

@end

@interface MEXExchangeRateSource : NSObject
@property (nonatomic, readonly) BOOL isReady;
@property (nonatomic) id<MEXExchangeRateSourceDelegate> delegate;
@property (nonatomic) NSTimeInterval updatePeriod;

- (MEXExchangeRate*) getRateFromCurrency:(MEXCurrency*)from toCurrency:(MEXCurrency*)to;
- (MEXMoney*)exchangeFromCurrency:(MEXCurrency*)from toCurrency:(MEXCurrency*)to amount:(MEXMoney*)amount;
@end

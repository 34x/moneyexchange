//
//  MEXMoneyAccount.h
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEXCurrency.h"
#import "MEXMoney.h"

@interface MEXMoneyAccount : NSObject
@property (nonatomic, readonly) MEXCurrency* currency;
@property (nonatomic, readonly) MEXMoney* balance;

+ (instancetype) accountWithCurrency:(MEXCurrency*)currency andBalance:(MEXMoney*)amount;

- (void) subtract:(MEXMoney*)amount completion:(void (^)(id result, NSError* error))completion;
- (void) add:(MEXMoney*)amount completion:(void (^)(id result, NSError* error))completion;

- (BOOL) isEqualToAccount:(MEXMoneyAccount*)account;
@end

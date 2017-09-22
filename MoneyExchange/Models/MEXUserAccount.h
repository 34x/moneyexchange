//
//  MEXAccount.h
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEXExchange.h"
#import "MEXExchangeResult.h"
#import "MEXMoneyAccount.h"

FOUNDATION_EXPORT NSString* const MEXUserAccountDomain;

typedef enum : NSUInteger {
    MEXUserAccountExchangeNoSource,
    MEXUserAccountExchangeNoDestination,
    MEXUserAccountExchangeNoAmount,
    MEXUserAccountExchangeZeroAmount,
    MEXUserAccountExchangeNotEnoughBalance,
    MEXUserAccountExchangeSameAccount,
} MEXUserAccountExchangeError;

@interface MEXUserAccount : NSObject

- (void)exchange:(MEXExchange*)exchangeObject
      completion:(void (^)(MEXExchangeResult*, NSError*))completion;

- (void)getMoneyAccountList:(void (^)(NSArray<MEXMoneyAccount*>*, NSError*))completion;

- (void)commit:(void (^)(NSError*))completion;
- (void)rollback:(void (^)(NSError*))completion;

@end

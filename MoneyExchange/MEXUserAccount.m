//
//  MEXAccount.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXUserAccount.h"

NSString* const MEXUserAccountDomain = @"MEXUserAccountDomain";

@implementation MEXUserAccount

- (void)rollback:(void (^)(NSError *))completion {
    if (completion) {
        completion(nil);
    }
}

- (void)commit:(void (^)(NSError *))completion {
    if (completion) {
        completion(nil);
    }
}

- (void)exchange:(MEXExchange *)exchangeObject completion:(void (^)(MEXExchangeResult*, NSError *))completion {
    
    if (!completion) {
        completion = ^(MEXExchangeResult* result, NSError* error){};
    }
    
    MEXMoneyAccount* source = exchangeObject.fromAccount;
    MEXMoneyAccount* destination = exchangeObject.toAccount;
    
    if(!source) {
        completion(nil, [self errorWith:MEXUserAccountExchangeNoSource andDescription:@"Source account not provided"]);
        return;
    }
    
    if(!destination) {
        completion(nil, [self errorWith:MEXUserAccountExchangeNoDestination andDescription:@"Destination account not provided"]);
        return;
    }
    
    if(!exchangeObject.amount) {
        completion(nil, [self errorWith:MEXUserAccountExchangeNoAmount andDescription:@"Exchange amount not provided"]);
        return;
    }
    
    if ([exchangeObject.amount isZero]) {
        completion(nil, [self errorWith:MEXUserAccountExchangeZeroAmount andDescription:@"Add something to exchange"]);
        return;
    }
    
    NSComparisonResult comparison = [source.balance compare:exchangeObject.amount];
    
    if (NSOrderedAscending == comparison) {
        if(completion) {
            completion(nil, [self errorWith:MEXUserAccountExchangeNotEnoughBalance andDescription:@"Not enough balance"]);
        }
        return;
    }
    
    MEXExchangeResult* result = [MEXExchangeResult resultWithSourceAmount:exchangeObject.amount
                                                        destinationAmount:exchangeObject.result
                                                                 exchange:exchangeObject];
    
    if(completion) {
        completion(result, nil);
    }
}

- (void)getMoneyAccountList:(void (^)(NSArray<MEXMoneyAccount *> *, NSError *))completion {
    if(completion) {
        completion(@[], nil);
    }
}

- (NSError*)errorWith:(MEXUserAccountExchangeError)code andDescription:(NSString*)description {
    return [NSError errorWithDomain:MEXUserAccountDomain
                               code:code
                           userInfo:@{
                                      NSLocalizedDescriptionKey: NSLocalizedString(description, @"Model UserAccount"),
                                      }];
}
@end

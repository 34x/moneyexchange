//
//  MEXAccount.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXUserAccount.h"

NSString* const MEXUserAccountDomain = @"MEXUserAccountDomain";

@interface MEXUserAccount()
@property NSMutableArray* queue;
@end

@implementation MEXUserAccount

- (instancetype)init {
    self = [super init];
    if (self) {
        self.queue = [NSMutableArray new];
    }
    return self;
}

- (void)rollback:(void (^)(NSError *))completion {
    self.queue = [NSMutableArray new];
    if (completion) {
        completion(nil);
    }
}

- (void)commit:(void (^)(NSError *))completion {
    MEXExchange* exchange = [self.queue firstObject];
    MEXMoneyAccount* source = exchange.fromAccount;
    MEXMoneyAccount* destination = exchange.toAccount;
    
    [source subtract:[exchange targetSubtract] completion:^(id result, NSError *error) {
        [destination add:[exchange targetAdd] completion:^(id result, NSError *error) {
            if (completion) {
                completion(nil);
            }
        }];
    }];
    
    
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
    
    if ([source isEqualToAccount:destination]) {
        completion(nil, [self errorWith:MEXUserAccountExchangeSameAccount andDescription:@"1 = 1"]);
        return;
    }
    
    NSComparisonResult comparison = [source.balance compare:[exchangeObject targetSubtract]];
    
    if (NSOrderedAscending == comparison) {
        if(completion) {
            completion(nil, [self errorWith:MEXUserAccountExchangeNotEnoughBalance andDescription:@"Not enough balance"]);
        }
        return;
    }
    
    [self.queue addObject:exchangeObject];
#warning TODO: that's akwward, need to be changed to something more clear and simple
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

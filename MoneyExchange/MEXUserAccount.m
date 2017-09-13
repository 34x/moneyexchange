//
//  MEXAccount.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXUserAccount.h"

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

@end

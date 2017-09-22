//
//  MEXMoneyAccount.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXMoneyAccount.h"

@interface MEXMoneyAccount()
@property (nonatomic, readwrite) MEXCurrency* currency;
@property (nonatomic, readwrite) MEXMoney* balance;
@end

@implementation MEXMoneyAccount
+ (instancetype) accountWithCurrency:(MEXCurrency*)currency andBalance:(MEXMoney*)amount {
    MEXMoneyAccount* account = [MEXMoneyAccount new];
    account.currency = currency;
    account.balance = amount;
    
    return account;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"<MEXMoneyAccount: %@, balance: %@>", self.currency.ISOCode, [self.balance stringValue]];
}

- (void) subtract:(MEXMoney *)amount completion:(void (^)(id, NSError *))completion {
    self.balance = [self.balance subtract:amount];
    if (completion) {
        completion(nil, nil);
    }
}

- (void) add:(MEXMoney *)amount completion:(void (^)(id, NSError *))completion {
    self.balance = [self.balance add:amount];
    if (completion) {
        completion(nil, nil);
    }
}

- (BOOL) isEqualToAccount:(MEXMoneyAccount *)account {
    // Of cource it's not the way of real checking :)
    return [self.currency isEqualToCurrency:account.currency] && NSOrderedSame == [self.balance compare:account.balance];
}

@end

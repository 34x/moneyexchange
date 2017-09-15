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
+(instancetype)accountWithCurrency:(MEXCurrency*)currency andBalance:(MEXMoney*)amount {
    MEXMoneyAccount* account = [MEXMoneyAccount new];
    account.currency = currency;
    account.balance = amount;
    
    return account;
}
@end

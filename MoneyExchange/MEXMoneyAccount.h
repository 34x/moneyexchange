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
@property (nonatomic) MEXCurrency* currency;
@property (nonatomic, readonly) MEXMoney* balance;

-(void)deduct:(MEXMoney*)amount completion:(void (^)(id result, NSError*))completion;
-(void)add:(MEXMoney*)amount completion:(void (^)(id result, NSError*))completion;

@end

//
//  MEXAccount.h
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEXExchange.h"
#import "MEXMoneyAccount.h"

@interface MEXUserAccount : NSObject
+ (instancetype) accountForUser:(NSString*)userID;

- (void)exchange:(MEXExchange*)exchangeObject
      completion:(void (^)(id result, NSError* error))completion;

- (void)getMoneyAccountList:(void (^)(NSArray<MEXMoneyAccount*>*, NSError*))completion;

- (void)commit:(void (^)(NSError*))completion;
- (void)rollback:(void (^)(NSError*))completion;

@end

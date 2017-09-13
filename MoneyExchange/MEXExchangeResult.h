//
//  MEXExchangeResult.h
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEXMoney.h"
#import "MEXExchange.h"

@interface MEXExchangeResult : NSObject
@property (nonatomic, readonly) MEXMoney* sourceAmount;
@property (nonatomic, readonly) MEXMoney* destinationAmount;
@property (nonatomic, readonly) MEXExchange* exchange;

+ (instancetype)resultWithSourceAmount:(MEXMoney*)sourceAmount
         destinationAmount:(MEXMoney*)destinationAmount
                  exchange:(MEXExchange*)exchange;
@end

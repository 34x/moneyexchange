//
//  MEXCurrency.h
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEXCurrency : NSObject
/* Currency ISO 4217 code */
@property (nonatomic, readonly) NSString* ISOCode;
@property (nonatomic, readonly) NSString* sign;

+ (instancetype)currencyWithISOCode:(NSString*)code;

- (BOOL)isEqualToCurrency:(MEXCurrency*)other;
@end

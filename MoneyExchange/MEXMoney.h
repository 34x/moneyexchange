//
//  MEXMoney.h
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEXMoney : NSObject
+ (instancetype) fromDouble:(double)value;

/*
 This method accepts money string. @"42" will be 42€ and 42.50 will be 42€ 50cents. 
 */
+ (instancetype) fromString:(NSString*)value;
/*
 This method assumes that amount is given with cent precision, so 4200 amount will be 42 € 00 cents.
 */
+ (instancetype) fromInteger:(NSInteger)value;
/*
 This method assumes that amount is given with custom precision, for example 2 means cents precision and 4 means 1/100 of cent precision.
 */
+ (instancetype) fromInteger:(NSInteger)value withPrecision:(NSInteger)precision;

- (NSString*) stringValue;
@end

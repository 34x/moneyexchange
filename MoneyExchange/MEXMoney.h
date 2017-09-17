//
//  MEXMoney.h
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEXMoney : NSObject
@property (nonatomic, readonly) NSDecimalNumber* value;

+ (instancetype) fromDouble:(double)value;

/*
 This method accepts money string. @"42" will be 42€ and 42.50 will be 42€ 50cents. 
 */
+ (instancetype) fromString:(NSString*)value;

+ (instancetype) fromNumber:(NSNumber*)value;

+ (instancetype) fromDecimalNumber:(NSDecimalNumber*)value;

- (NSString*) stringValue;

- (MEXMoney*)multiplyBy:(NSNumber*)factor;
- (MEXMoney*)divideBy:(NSNumber*)denominator;

- (MEXMoney*)add:(MEXMoney*)plus;
- (MEXMoney*)subtract:(MEXMoney*)minus;

- (BOOL)isZero;
@end

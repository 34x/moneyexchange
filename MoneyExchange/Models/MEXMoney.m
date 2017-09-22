//
//  MEXMoney.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXMoney.h"

@interface MEXMoney ()
@property (nonatomic, readwrite) NSDecimalNumber* value;
@end

@implementation MEXMoney
+ (instancetype) fromString:(NSString *)value {
    
    MEXMoney* money = [MEXMoney new];
    
    money.value = [NSDecimalNumber decimalNumberWithString:value];
    
    if ([money.value isEqualToNumber:[NSDecimalNumber notANumber]]) {
        
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"Money string '%@' is parsed to NaN", value] userInfo:nil];
    }
    
    return money;
}

+ (instancetype) fromNumber:(NSNumber *)value {
    MEXMoney* money = [MEXMoney new];
    money.value = [NSDecimalNumber decimalNumberWithDecimal:[value decimalValue]];
    return money;
}

+ (instancetype) fromDecimalNumber:(NSDecimalNumber *)value {
    MEXMoney* money = [MEXMoney new];
    money.value = value;
    return money;
}

+ (instancetype) fromDouble:(double)value {
    NSNumber* number = [NSNumber numberWithDouble:value];
    
    return [MEXMoney fromNumber:number];
}

+ (instancetype) zero {
    return [MEXMoney fromNumber:@(0)];
}

+ (NSDecimalNumber*)round:(NSDecimalNumber*)value {
    NSDecimalNumberHandler *rounder = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                             scale:4
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:NO];
    return [value decimalNumberByRoundingAccordingToBehavior:rounder];
}


- (NSString*)stringValue {
    if (self.value) {
        return [NSString stringWithFormat:@"%@", [MEXMoney round:self.value]];
    }
    
    return @"";
}

- (MEXMoney*)multiplyBy:(NSNumber*)factor {
    
    NSDecimalNumber* decimalFactor = [NSDecimalNumber decimalNumberWithDecimal:[factor decimalValue]];
    
    if ([self.value isEqualToNumber:[NSDecimalNumber notANumber]]
        || [decimalFactor isEqualToNumber:[NSDecimalNumber notANumber]]) {
        return nil;
    }
    
    NSDecimalNumber* result = [self.value decimalNumberByMultiplyingBy:decimalFactor];
    
    return [MEXMoney fromDecimalNumber:[MEXMoney round:result]];
}

- (MEXMoney*)divideBy:(NSNumber*)denominator {
    NSDecimalNumber* decimalDenominator = [NSDecimalNumber decimalNumberWithDecimal:[denominator decimalValue]];
    
    if ([self.value isEqualToNumber:[NSDecimalNumber notANumber]]
        || [decimalDenominator isEqualToNumber:[NSDecimalNumber notANumber]]) {
        return nil;
    }
    
    NSDecimalNumber* result = [self.value decimalNumberByDividingBy:decimalDenominator];
    
    return [MEXMoney fromDecimalNumber:[MEXMoney round:result]];
}

- (MEXMoney*)add:(MEXMoney*)plus {
    return [MEXMoney fromDecimalNumber:[self.value decimalNumberByAdding:plus.value]];
}

- (MEXMoney*)subtract:(MEXMoney*)minus {
    return [MEXMoney fromDecimalNumber:[self.value decimalNumberBySubtracting:minus.value]];
}


- (NSString*)description {
    return [NSString stringWithFormat:@"<MEXMoney: %@>", self.value];
}

- (BOOL)isZero {
    return [[NSDecimalNumber decimalNumberWithString:@"0"] isEqualToNumber:self.value];
}

- (NSComparisonResult)compare:(MEXMoney *)amount {
    return [self.value compare:amount.value];
}

@end

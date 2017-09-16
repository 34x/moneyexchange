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
    @try {
        money.value = [NSDecimalNumber decimalNumberWithString:value];
    } @catch (NSException *exception) {
     
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


- (NSString*)stringValue {
    if (self.value) {
        return [NSString stringWithFormat:@"%@", self.value];
    }
    
    return @"";
}

- (NSDecimalNumber*)round:(NSDecimalNumber*)value {
    NSDecimalNumberHandler *rounder = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                             scale:4
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:NO];
    
    return [value decimalNumberByRoundingAccordingToBehavior:rounder];
}


- (MEXMoney*)multiplyBy:(NSNumber*)factor {
    
    NSDecimalNumber* decimalFactor = [NSDecimalNumber decimalNumberWithDecimal:[factor decimalValue]];
    
    if ([self.value isEqualToNumber:[NSDecimalNumber notANumber]]
        || [decimalFactor isEqualToNumber:[NSDecimalNumber notANumber]]) {
        return nil;
    }
    
    NSDecimalNumber* result = [self.value decimalNumberByMultiplyingBy:decimalFactor];
    
    return [MEXMoney fromDecimalNumber:[self round:result]];
}

- (MEXMoney*)divideBy:(NSNumber*)denominator {
    NSDecimalNumber* decimalDenominator = [NSDecimalNumber decimalNumberWithDecimal:[denominator decimalValue]];
    
    if ([self.value isEqualToNumber:[NSDecimalNumber notANumber]]
        || [decimalDenominator isEqualToNumber:[NSDecimalNumber notANumber]]) {
        return nil;
    }
    
    NSDecimalNumber* result = [self.value decimalNumberByDividingBy:decimalDenominator];
    
    return [MEXMoney fromDecimalNumber:[self round:result]];
}

- (MEXMoney*)add:(MEXMoney*)plus {
    return [MEXMoney fromDecimalNumber:[self.value decimalNumberByAdding:plus.value]];
}

- (MEXMoney*)subtract:(MEXMoney*)minus {
    return [MEXMoney fromDecimalNumber:[self.value decimalNumberBySubtracting:minus.value]];
}

@end

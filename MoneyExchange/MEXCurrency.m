//
//  MEXCurrency.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXCurrency.h"

@interface MEXCurrency()
@property (nonatomic, readwrite) NSString* ISOCode;
@end

@implementation MEXCurrency

+ (instancetype)currencyWithISOCode:(NSString*)code {
    MEXCurrency *currency = [MEXCurrency new];
    
    currency.ISOCode = code;
    
    return currency;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<MEXCurrency: %@>", self.ISOCode];
}

- (BOOL)isEqualToCurrency:(MEXCurrency*)other {
    return [self.ISOCode isEqualToString:other.ISOCode];
}

- (NSString*) sign {
    if ([@"EUR" isEqualToString:self.ISOCode]) {
        return @"€";
    } else if ([@"GBP" isEqualToString:self.ISOCode]) {
        return @"£";
    } else if ([@"USD" isEqualToString:self.ISOCode]) {
        return @"$";
    }
    
    return @"";
    
}
@end

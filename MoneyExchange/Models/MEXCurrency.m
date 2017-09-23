//
//  MEXCurrency.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXCurrency.h"

@interface MEXCurrency() <NSCoding>
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
    return [[MEXCurrency currencyDataForCode:self.ISOCode] objectForKey:@"sign"];
}

- (NSString*)flag {
    return [[MEXCurrency currencyDataForCode:self.ISOCode] objectForKey:@"flag"];
}

+ (NSDictionary*)currenciesData {
    return @{
             @"EUR": @{@"sign": @"€", @"flag": @"🇪🇺"},
             @"RUB": @{@"sign": @"₽", @"flag": @"🇷🇺"},
             @"GBP": @{@"sign": @"£", @"flag": @"🇬🇧"},
             @"USD": @{@"sign": @"$", @"flag": @"🇺🇸"},
             };
}

+ (NSDictionary*)currencyDataForCode:(NSString*)code {
    NSDictionary* data = [[self currenciesData] objectForKey:code];
    if (data) {
        return data;
    }
    
    return @{@"sign": @"", @"flag": @""};
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.ISOCode forKey:@"ISOCode"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    MEXCurrency* currency = [MEXCurrency currencyWithISOCode:[aDecoder decodeObjectForKey:@"ISOCode"]];
    return currency;
}

@end

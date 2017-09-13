//
//  MEXMoney.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXMoney.h"

@interface MEXMoney ()
@property (nonatomic) NSNumber* value;
@end

@implementation MEXMoney
+ (instancetype) fromString:(NSString *)value {
    
    MEXMoney* money = [MEXMoney new];
    
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    money.value = [formatter numberFromString:value];
    
    return money;
}

- (NSString*)stringValue {
    if (self.value) {
        return [NSString stringWithFormat:@"%@", self.value];
    }
    
    return @"";
}
@end

//
//  MoneyExchangeTests.m
//  MoneyExchangeTests
//
//  Created by Max on 17/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MEXMoney.h"

@interface MoneyExchangeTests : XCTestCase

@end

@implementation MoneyExchangeTests

- (void) testFromString {
    XCTAssertEqualObjects([NSDecimalNumber zero], [MEXMoney fromString:@"0"].value);
    XCTAssertEqualObjects([NSDecimalNumber zero], [MEXMoney fromString:@"0.0"].value);
    
    XCTAssertThrows([MEXMoney fromString:@""]);
    
}

@end

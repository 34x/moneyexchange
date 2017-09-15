//
//  MEXExchangeRateSource.m
//  MoneyExchange
//
//  Created by Max on 14/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXExchangeRateSource.h"
#import "MEXCurrency.h"
#import "MEXExchangeRate.h"

@interface MEXExchangeRateSource() <NSXMLParserDelegate>
@property (nonatomic) NSTimer* currentTimer;
@property (nonatomic) NSURLSessionDataTask* currentTask;
@property (nonatomic) NSMutableDictionary* ratesBuffer;
@property (nonatomic) NSDictionary* rates;
@property (nonatomic) NSString* defaultCurrencyCode;
@end


@implementation MEXExchangeRateSource
- (instancetype)init {
    self = [super init];
    if (self) {
        self.updatePeriod = 30.0;
        self.defaultCurrencyCode = @"EUR";
    }
    return self;
}

- (void)setUpdatePeriod:(NSTimeInterval)updatePeriod {
    _updatePeriod = updatePeriod;
    
    [self.currentTimer invalidate];
    self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:updatePeriod
                                                         target:self
                                                       selector:@selector(updateRates)
                                                       userInfo:nil
                                                        repeats:YES];
    
    [self.currentTimer fire];
}

- (void)updateRates {
    NSURL* url = [NSURL URLWithString:@"https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"];
    
    MEXExchangeRateSource* __weak weakSelf = self;
    
    if (self.currentTask && self.currentTask.state == NSURLSessionTaskStateRunning) {
        // do not update if we have slow internet. Wait for finishing previous one.
        return;
    }
    
    self.currentTask = [[NSURLSession sharedSession]
                                  dataTaskWithURL: url
                                  completionHandler:^(
                                                      NSData * _Nullable data,
                                                      NSURLResponse * _Nullable response,
                                                      NSError * _Nullable error) {
                                      
                                      NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                                      parser.delegate = weakSelf;
                                      
                                      weakSelf.ratesBuffer = [NSMutableDictionary new];
                                      
                                      BOOL result = [parser parse];
                                      if(result) {
                                          weakSelf.rates = [NSDictionary dictionaryWithDictionary:weakSelf.ratesBuffer];
                                      }
                                      
    }];
    
    [self.currentTask resume];
}

-(MEXExchangeRate*) getRateFromCurrency:(MEXCurrency *)from toCurrency:(MEXCurrency *)to {
    
    if ([from isEqualToCurrency:to]) {
        return [MEXExchangeRate rateWith:from over:to withRatio:@(1.0)];
    }
    
    if ([from.ISOCode isEqualToString:self.defaultCurrencyCode]) {
        return [self.rates objectForKey:to.ISOCode];
    }
    
        
    return nil;
}

#pragma mark XML parser delegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    NSString* currency = [attributeDict objectForKey:@"currency"];
    NSString* currencyRateString = [attributeDict objectForKey:@"rate"];
    
    if (![elementName isEqualToString:@"Cube"]
        || !currency
        || !currencyRateString
    ) {
        return;
    }
    
    
    MEXCurrency* baseCurrency = [MEXCurrency currencyWithISOCode:self.defaultCurrencyCode];
    MEXCurrency* otherCurrency = [MEXCurrency currencyWithISOCode:currency];
    
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber* currencyRate = [formatter numberFromString:currencyRateString];
    
    MEXExchangeRate* rate = [MEXExchangeRate rateWith:baseCurrency over:otherCurrency withRatio:currencyRate];
    
    [self.ratesBuffer setObject:rate forKey:otherCurrency.ISOCode];
}

@end

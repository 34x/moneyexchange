//
//  MEXExchangeRateSource.m
//  MoneyExchange
//
//  Created by Max on 14/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEXExchangeRateSource.h"
#import "MEXCurrency.h"
#import "MEXExchangeRate.h"

@interface MEXExchangeRateSource() <NSXMLParserDelegate>
@property (nonatomic, readwrite) BOOL isReady;
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
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    self.currentTask = [[NSURLSession sharedSession]
                                  dataTaskWithURL: url
                                  completionHandler:^(
                                                      NSData * _Nullable data,
                                                      NSURLResponse * _Nullable response,
                                                      NSError * _Nullable error) {
                                      
                                      if (error) {
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              if([weakSelf.delegate respondsToSelector:@selector(rateSourceRatesDidLoad:)]) {
                                                  [weakSelf.delegate rateSourceRatesDidLoad:error];
                                              }
                                              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                          }];
                                          return;
                                      }
                                      
                                      NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                                      parser.delegate = weakSelf;
                                      
                                      weakSelf.ratesBuffer = [NSMutableDictionary new];
                                      
                                      
                                      BOOL result = [parser parse];
                                      
                                      
                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                          NSError* parseError;
                                          if(result) {
                                              weakSelf.rates = [NSDictionary dictionaryWithDictionary:weakSelf.ratesBuffer];
                                              NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                          } else {
                                              parseError = [NSError errorWithDomain:@"MEXExchangeSource" code:1 userInfo:nil];
                                          }
                                          
                                          if([weakSelf.delegate respondsToSelector:@selector(rateSourceRatesDidLoad:)]) {
                                              [weakSelf.delegate rateSourceRatesDidLoad:parseError];
                                          }
                                          
                                          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                      }];
                                      
                                      
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
    
    if ([to.ISOCode isEqualToString:self.defaultCurrencyCode]) {
        MEXExchangeRate* reverseExchange = [self.rates objectForKey:from.ISOCode];
        NSNumber* reverseRatio = [NSNumber numberWithDouble:1.0 / [reverseExchange.ratio doubleValue]];
        
        return [MEXExchangeRate rateWith:from over:to withRatio:reverseRatio];
    }
    
    MEXExchangeRate* fromRate = [self.rates objectForKey:from.ISOCode];
    MEXExchangeRate* toRate = [self.rates objectForKey:to.ISOCode];
    
    NSDecimalNumber* ratio = [[[NSDecimalNumber decimalNumberWithString:@"1.0"]
                               decimalNumberByDividingBy:fromRate.ratio]
                              decimalNumberByMultiplyingBy:toRate.ratio];
    
    return [MEXExchangeRate rateWith:from over:to withRatio:ratio];
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
    
    NSDecimalNumber* currencyRate = [NSDecimalNumber decimalNumberWithString:currencyRateString];
    
    if ([currencyRate isEqualToNumber:[NSDecimalNumber zero]]) {
#warning TODO: add appropriate reporting or just silently skip such cases
        NSLog(@"Currency rate is 0, probably need to check source");
        return;
    }
    
    MEXExchangeRate* rate = [MEXExchangeRate rateWith:baseCurrency over:otherCurrency withRatio:currencyRate];
    
    [self.ratesBuffer setObject:rate forKey:otherCurrency.ISOCode];
}

@end

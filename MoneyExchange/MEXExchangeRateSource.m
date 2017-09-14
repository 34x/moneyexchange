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

@end


@implementation MEXExchangeRateSource
- (instancetype)init {
    self = [super init];
    if (self) {
        self.updatePeriod = 30.0;
    }
    return self;
}

- (void)setUpdatePeriod:(NSTimeInterval)updatePeriod {
    _updatePeriod = updatePeriod;
    
    NSLog(@"? %f", updatePeriod);
    [self.currentTimer invalidate];
    self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:updatePeriod
                                                         target:self
                                                       selector:@selector(updateRates)
                                                       userInfo:nil
                                                        repeats:YES];
    
    [self.currentTimer fire];
}

- (void)updateRates {
    NSLog(@"??");
    NSURL* url = [NSURL URLWithString:@"https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"];
    
    MEXExchangeRateSource* __weak weakSelf = self;
    
    if (self.currentTask.state == NSURLSessionTaskStateRunning) {
        // do not update if we have slow internet. Wait for finishing previous one.
        return;
    }
    self.currentTask = [[NSURLSession sharedSession]
                                  dataTaskWithURL: url
                                  completionHandler:^(
                                                      NSData * _Nullable data,
                                                      NSURLResponse * _Nullable response,
                                                      NSError * _Nullable error) {
                                      
                                      NSLog(@"Error %@", error);
                                      NSLog(@"Data %li", data.length);
                                      
                                      NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                                      parser.delegate = weakSelf;
                                      
                                      weakSelf.ratesBuffer = [NSMutableDictionary new];
                                      
                                      BOOL result = [parser parse];
                                      NSLog(@"parse result %i", result);
                                      NSLog(@"Rate: %@", weakSelf.ratesBuffer);
                                      
    }];
    
    [self.currentTask resume];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    NSString* currency = [attributeDict objectForKey:@"currency"];
    NSString* currencyRateString = [attributeDict objectForKey:@"rate"];
    
    if (![elementName isEqualToString:@"Cube"]
        || !currency
        || !currencyRateString
    ) {
        return;
    }
    
    
    MEXCurrency* eur = [MEXCurrency currencyWithISOCode:@"EUR"];
    MEXCurrency* otherCurrency = [MEXCurrency currencyWithISOCode:currency];
    
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber* currencyRate = [formatter numberFromString:currencyRateString];
    
    MEXExchangeRate* rate = [MEXExchangeRate rateWith:eur over:otherCurrency withRatio:currencyRate];
    
    [self.ratesBuffer setObject:rate forKey:otherCurrency.ISOCode];
}

@end

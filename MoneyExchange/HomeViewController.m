//
//  ViewController.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "HomeViewController.h"
#import "MEXExchangeRowView.h"
#import "MEXUserAccount.h"
#import "MEXMoneyAccount.h"
#import "MEXExchangeRateSource.h"


@interface HomeViewController () <MEXExchangeRowViewDelegate>
@property (weak, nonatomic) IBOutlet MEXExchangeRowView *exchangeRowSource;
@property (weak, nonatomic) IBOutlet MEXExchangeRowView *exchangeRowDestination;

@property (nonatomic) MEXUserAccount* userAccount;
@property (nonatomic) MEXMoneyAccount* sourceAccount;
@property (nonatomic) MEXMoneyAccount* destinationAccount;

@property (nonatomic) MEXExchangeRateSource* rateSource;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.exchangeRowSource.delegate = self;
    self.exchangeRowDestination.delegate = self;
    
    self.userAccount = [MEXUserAccount new];
    
    self.rateSource = [MEXExchangeRateSource new];
    
//    self.sourceAccount = [MEXMoneyAccount accountWithCurrency:[MEXCurrency currencyWithISOCode:@"EUR"] andBalance:[MEXMoney fromString:@"100.0"]];
    
//    self.destinationAccount = [MEXMoneyAccount accountWithCurrency:[MEXCurrency currencyWithISOCode:@"GBP"] andBalance:[MEXMoney fromString:@"100.0"]];
    
    NSArray* accounts = @[
                          [MEXMoneyAccount accountWithCurrency:[MEXCurrency currencyWithISOCode:@"EUR"] andBalance:[MEXMoney fromString:@"100.00"]],
                          [MEXMoneyAccount accountWithCurrency:[MEXCurrency currencyWithISOCode:@"GBP"] andBalance:[MEXMoney fromString:@"100.00"]],
                          [MEXMoneyAccount accountWithCurrency:[MEXCurrency currencyWithISOCode:@"USD"] andBalance:[MEXMoney fromString:@"100.00"]],
                          ];
    
    self.exchangeRowSource.accounts = accounts;
    self.exchangeRowDestination.accounts = accounts;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exchangeView:(MEXExchangeRowView *)view didChangeValue:(MEXMoney *)value {
    MEXExchangeRowView* target = self.exchangeRowDestination;
    MEXExchangeAmountType exchangeType = MEXExchangeAmountInSourceCurrency;
    
    if (view == self.exchangeRowDestination) {
        target = self.exchangeRowSource;
        exchangeType = MEXExchangeAmountInDestinationCurrency;
    }
    
    
    MEXExchangeRate* rate = [self.rateSource getRateFromCurrency:self.sourceAccount.currency
                                                      toCurrency:self.destinationAccount.currency];
    NSLog(@"Rate %@", rate);
    if (!rate) {
        return;
    }
    
    [self.exchangeRowDestination setRate:rate];
    
    [self.userAccount rollback:^(NSError* error) {
        MEXExchange* exchange = [MEXExchange exchangeFrom:self.sourceAccount
                                                       to:self.destinationAccount
                                                   amount:value
                                                     rate:rate
                                               amountType:exchangeType];

        [target setAmount:exchange.result];
    }];
}

- (void)exchangeView:(MEXExchangeRowView *)view didChangeAccount:(MEXMoneyAccount *)account {
    if (view == self.exchangeRowSource) {
        self.sourceAccount = account;
    } else {
        self.destinationAccount = account;
    }
}


@end

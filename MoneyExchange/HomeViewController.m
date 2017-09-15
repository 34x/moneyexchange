//
//  ViewController.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "HomeViewController.h"
#import "MEXExchangeView.h"
#import "MEXExchangeRowView.h"
#import "MEXUserAccount.h"
#import "MEXMoneyAccount.h"
#import "MEXExchangeRateSource.h"


@interface HomeViewController () <MEXExchangeRowViewDelegate>
@property (weak, nonatomic) IBOutlet MEXExchangeRowView *exchangeRowSource;
@property (weak, nonatomic) IBOutlet MEXExchangeRowView *exchangeRowDestination;

@property (nonatomic) MEXExchangeView* sourceView;
@property (nonatomic) MEXExchangeView* destinationView;

@property (nonatomic) MEXUserAccount* userAccount;
@property (nonatomic) MEXMoneyAccount* sourceAccount;
@property (nonatomic) MEXMoneyAccount* destinationAccount;

@property (nonatomic) MEXExchangeRateSource* rateSource;
@property (nonatomic) MEXMoney* lastSourceAmount;
@property (nonatomic) MEXMoney* lastDestinationAmount;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.exchangeRowSource.delegate = self;
    self.exchangeRowDestination.delegate = self;
    
    self.userAccount = [MEXUserAccount new];
    
    self.rateSource = [MEXExchangeRateSource new];
    
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
    
    MEXMoneyAccount* sourceAccount = self.sourceView.account;
    MEXMoneyAccount* destinationAccount = self.destinationView.account;
    
    MEXExchangeRate* rate = [self.rateSource getRateFromCurrency:sourceAccount.currency
                                                      toCurrency:destinationAccount.currency];
    
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


- (void)exchangeView:(MEXExchangeRowView *)view didChangeExchangeView:(MEXExchangeView *)exchangeView {
    if (view == self.exchangeRowSource) {
        self.sourceView = exchangeView;
        [self exchangeView:self.exchangeRowDestination didChangeValue:self.destinationView.amount];
    } else {
        self.destinationView = exchangeView;
        [self exchangeView:self.exchangeRowSource didChangeValue:self.sourceView.amount];
    }
}

@end

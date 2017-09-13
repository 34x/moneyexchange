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

@interface HomeViewController () <MEXExchangeRowViewDelegate>
@property (weak, nonatomic) IBOutlet MEXExchangeRowView *exchangeRowSource;
@property (weak, nonatomic) IBOutlet MEXExchangeRowView *exchangeRowDestination;

@property (nonatomic) MEXUserAccount* userAccount;
@property (nonatomic) MEXMoneyAccount* sourceAccount;
@property (nonatomic) MEXMoneyAccount* destinationAccount;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.exchangeRowSource.delegate = self;
    self.exchangeRowDestination.delegate = self;
    
    self.userAccount = [MEXUserAccount new];
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
    
    MEXExchangeRate* rate = [MEXExchangeRate rateWith:self.sourceAccount.currency
                                                 over:self.destinationAccount.currency
                                            withRatio:@(2.0)];
    
    [self.userAccount rollback:^(NSError* error) {
        MEXExchange* exchange = [MEXExchange exchangeFrom:self.sourceAccount
                                                       to:self.destinationAccount
                                                   amount:value
                                                     rate:rate
                                               amountType:exchangeType];

        [target setAmount:exchange.result];
    }];

}


@end

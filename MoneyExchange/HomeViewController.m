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


@interface HomeViewController () <MEXExchangeRowViewDelegate, MEXExchangeRateSourceDelegate>
@property (weak, nonatomic) IBOutlet MEXExchangeRowView *exchangeRowSource;
@property (weak, nonatomic) IBOutlet MEXExchangeRowView *exchangeRowDestination;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;
@property (weak, nonatomic) IBOutlet UIView *loadingSplash;

@property (nonatomic) MEXExchangeRowView* lastUsedExchangeRow;

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
    self.exchangeRowSource.type = MEXExchangeViewTypeSource;
    self.exchangeRowDestination.type = MEXExchangeViewTypeDestination;
    
    self.userAccount = [MEXUserAccount new];
    
    self.rateSource = [MEXExchangeRateSource new];
    self.rateSource.delegate = self;
    
    NSArray* accounts = @[
                          [MEXMoneyAccount accountWithCurrency:[MEXCurrency currencyWithISOCode:@"EUR"] andBalance:[MEXMoney fromString:@"100.00"]],
                          [MEXMoneyAccount accountWithCurrency:[MEXCurrency currencyWithISOCode:@"GBP"] andBalance:[MEXMoney fromString:@"100.00"]],
                          [MEXMoneyAccount accountWithCurrency:[MEXCurrency currencyWithISOCode:@"USD"] andBalance:[MEXMoney fromString:@"100.00"]],
                          ];
    
    self.exchangeRowSource.accounts = accounts;
    self.exchangeRowDestination.accounts = accounts;

    [self setOverallScreenEnable:NO withMessage:NSLocalizedString(@"Loading rates", @"ExchangeScreen.exchangeButton")];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.exchangeRowSource becomeFirstResponder];
}

- (void)exchangeView:(MEXExchangeRowView *)view didChangeValue:(MEXMoney *)value {
    self.lastUsedExchangeRow = view;
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
        [self setExchangeEnable:NO andMessage:NSLocalizedString(@"No exchange rate", @"ExchangeScreen.exchangeButton")];
        return;
    }
    
    [self.exchangeRowDestination setRate:rate];
    MEXExchange* exchange = [MEXExchange exchangeFrom:sourceAccount
                                                   to:destinationAccount
                                               amount:value
                                                 rate:rate
                                           amountType:exchangeType];
    
    [self.userAccount rollback:^(NSError* rollbackError) {
        [self.userAccount exchange:exchange completion:^(MEXExchangeResult *result, NSError *error) {
            // Just interface update
            [target setAmount:exchange.result];
            if (error) {
                [self setExchangeEnable:NO andMessage:error.localizedDescription];
                return;
            }
            
            [self setExchangeEnable:YES andMessage:nil];
            
        }];
        
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

- (void)setOverallScreenEnable:(BOOL)enable withMessage:(NSString*)message{
    if (self.loadingSplash.isHidden == enable) {
        return;
    }
    
    self.loadingSplash.alpha = enable ? 0.8 : 0;
    
    [self.loadingSplash setHidden:NO];
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.loadingSplash.alpha = enable ? 0 : 0.8;
                     }
                     completion:^(BOOL finished) {
                         [self.loadingSplash setHidden: enable ? YES : NO];
                     }];
    self.exchangeRowSource.userInteractionEnabled = enable;
    self.exchangeRowDestination.userInteractionEnabled = enable;
    
    [self setExchangeEnable:enable andMessage:message];
}

- (void)setExchangeEnable:(BOOL)enable andMessage:(NSString*)message {
    
    if (!message) {
        message = NSLocalizedString(enable ? @"Exchange" : @"Exchange not available", @"ExchangeScreen.exchangeButton");
    }
    
    self.exchangeButton.enabled = enable;
    [self.exchangeButton setTitle:message forState:UIControlStateNormal];
    
    self.exchangeButton.layer.borderColor = [self.exchangeButton currentTitleColor].CGColor;
    self.exchangeButton.layer.borderWidth = 1.0;
    self.exchangeButton.layer.cornerRadius = 12.0;
    self.exchangeButton.layer.masksToBounds = YES;
}

- (IBAction)exchangeAction:(id)sender {
    [self.userAccount commit:^(NSError *error) {
        [self resetForm];
    }];
}

- (IBAction)cancelAction:(id)sender {
    [self.userAccount rollback:^(NSError *error) {
        [self resetForm];
    }];
}

- (void) resetForm {
    [self.lastUsedExchangeRow setAmount:[MEXMoney zero]];
    [self exchangeView:self.lastUsedExchangeRow didChangeValue:[MEXMoney zero]];
}

#pragma mark source delegate

- (void)rateSourceRatesDidLoad:(NSError *)error {
    if (!error) {
        
        [self setOverallScreenEnable:YES withMessage:nil];
        
        MEXMoney* amount;
        if (self.lastUsedExchangeRow == self.exchangeRowSource) {
            amount = self.sourceView.amount;
        } else {
            amount = self.destinationView.amount;
        }
        
        [self exchangeView:self.lastUsedExchangeRow didChangeValue:amount];
        
    } else {
        [self setOverallScreenEnable:NO withMessage:NSLocalizedString(@"Error while getting currency rates", @"ExchangeScreen.exchangeButton")];
    }
}

@end

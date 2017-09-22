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
#import "MEXAmountTextField.h"


@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) MEXExchangeRowView* lastUsedExchangeRow;

@property (nonatomic) MEXExchangeView* sourceView;
@property (nonatomic) MEXExchangeView* destinationView;

@property (nonatomic) MEXUserAccount* userAccount;
@property (nonatomic) MEXMoneyAccount* sourceAccount;
@property (nonatomic) MEXMoneyAccount* destinationAccount;

@property (nonatomic) MEXExchangeRateSource* rateSource;
@property (nonatomic) MEXMoney* lastSourceAmount;
@property (nonatomic) MEXMoney* lastDestinationAmount;

@property (nonatomic) NSArray* currencies;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.userAccount = [MEXUserAccount new];
    
    self.rateSource = [MEXExchangeRateSource new];
    
    self.currencies = @[
                        [MEXCurrency currencyWithISOCode:@"EUR"],
                        [MEXCurrency currencyWithISOCode:@"RUB"],
                        [MEXCurrency currencyWithISOCode:@"GBP"],
                        [MEXCurrency currencyWithISOCode:@"USD"],
                        ];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) resetForm {
    [self.lastUsedExchangeRow setAmount:[MEXMoney zero]];
}

#pragma mark source delegate

- (void)rateSourceRatesDidLoad:(NSError *)error {
    
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel* currencyLabel = [cell viewWithTag:1];
    MEXAmountTextField* amountInput = [cell viewWithTag:2];
    
    MEXCurrency* currency = self.currencies[indexPath.row];
    currencyLabel.text = currency.ISOCode;
    amountInput.text = @"0.00";
    amountInput.currency = currency;
    
    [amountInput addTarget:self action:@selector(amountDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // should be here to not interfer with getting subviews
    cell.tag = indexPath.row;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currencies.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MEXAmountTextField class]]) {
            [obj becomeFirstResponder];
            *stop = YES;
        }
    }];
}

- (void)amountDidChange:(MEXAmountTextField*)field {
    NSLog(@"Field: %@ %@", field.amount, field.currency);
}

@end

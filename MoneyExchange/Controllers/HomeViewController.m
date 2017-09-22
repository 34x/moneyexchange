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
#import "MEXExchangeTableCell.h"


@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *exchangeTable;

@property (nonatomic) MEXExchangeRowView* lastUsedExchangeRow;

@property (nonatomic) MEXExchangeView* sourceView;
@property (nonatomic) MEXExchangeView* destinationView;

@property (nonatomic) MEXUserAccount* userAccount;
@property (nonatomic) MEXMoneyAccount* sourceAccount;
@property (nonatomic) MEXMoneyAccount* destinationAccount;

@property (nonatomic) MEXExchangeRateSource* rateSource;
@property (nonatomic) MEXMoney* lastSourceAmount;
@property (nonatomic) MEXMoney* lastDestinationAmount;

@property (nonatomic) NSArray<MEXCurrency*>* currencies;
@property (nonatomic) NSArray<MEXMoney*>* amounts;
@property (nonatomic) UILabel* lastUpdateLabel;
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
    
    UIView* tableBackground = [UIView new];
    self.lastUpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32.0, [UIScreen mainScreen].bounds.size.width,
                                                                     42.0)];
    
    [tableBackground addSubview:self.lastUpdateLabel];
    self.exchangeTable.backgroundView = tableBackground;
    
    [self updateLastUpdateLabel];
    [self addObserver:self forKeyPath:@"rateSource.lastUpdate" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)updateLastUpdateLabel {
    UILabel* updateLabel = self.lastUpdateLabel;
    if (self.rateSource.lastUpdate) {
        updateLabel.text = [NSString stringWithFormat:@"Last updated at %@", self.rateSource.lastUpdate];
    } else {
        updateLabel.text = @"Updating...";
    }
    updateLabel.textAlignment = NSTextAlignmentCenter;
    updateLabel.font = [UIFont systemFontOfSize:12.0];
    updateLabel.textColor = [UIColor grayColor];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self updateLastUpdateLabel];
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
    MEXExchangeTableCell* cell = (MEXExchangeTableCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.tag = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel* currencyLabel = cell.currencyLabel;
    MEXAmountTextField* amountInput = cell.amountField;
    
    MEXCurrency* currency = self.currencies[indexPath.row];
    currencyLabel.text = currency.ISOCode;
    
    if (self.amounts.count > indexPath.row) {
        amountInput.text = [self.amounts[indexPath.row] stringValue];
    } else {
        amountInput.text = @"";
    }
    amountInput.currency = currency;
    
    [amountInput addTarget:self action:@selector(amountDidChange:) forControlEvents:UIControlEventEditingChanged];
    
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
    
    MEXCurrency* currentCurrency = field.currency;
    MEXMoney* currentAmount = field.amount;
    __block NSMutableArray* sections = [NSMutableArray new];
    NSMutableArray* amounts = [NSMutableArray new];
    
    [self.currencies enumerateObjectsUsingBlock:^(MEXCurrency* _Nonnull currency, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([currentCurrency isEqualToCurrency:currency]) {
            [amounts addObject:currentAmount];
            return;
        }
        
        NSIndexPath* path = [NSIndexPath indexPathForRow:idx inSection:0];
        [sections addObject:path];
        [amounts addObject:[self.rateSource exchangeFromCurrency:currentCurrency toCurrency:currency amount:currentAmount]];
    }];
    self.amounts = amounts;
    [self.exchangeTable reloadRowsAtIndexPaths:sections withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end

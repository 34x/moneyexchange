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


@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, MEXExchangeRateSourceDelegate>
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
@property (nonatomic) NSDateFormatter* dateFormatter;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.userAccount = [MEXUserAccount new];
    
    self.rateSource = [MEXExchangeRateSource new];
    self.rateSource.delegate = self;
    
    self.currencies = @[
                        [MEXCurrency currencyWithISOCode:@"EUR"],
                        [MEXCurrency currencyWithISOCode:@"RUB"],
                        [MEXCurrency currencyWithISOCode:@"GBP"],
                        [MEXCurrency currencyWithISOCode:@"USD"],
                        ];
    
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    [self.dateFormatter setLocale: [NSLocale currentLocale]];
    
    UIView* tableBackground = [UIView new];
    self.lastUpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32.0, [UIScreen mainScreen].bounds.size.width,
                                                                     42.0)];
    
    [tableBackground addSubview:self.lastUpdateLabel];
    self.exchangeTable.backgroundView = tableBackground;
    
    [self updateLastUpdateLabel];
    [self addObserver:self forKeyPath:@"rateSource.lastUpdate" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)updateLastUpdateLabel {
    UILabel* updateLabel = self.lastUpdateLabel;
    if (self.rateSource.lastUpdate) {
        updateLabel.text = [NSString stringWithFormat:@"Last updated at %@", [self.dateFormatter stringFromDate:self.rateSource.lastUpdate]];
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
    NSIndexPath* selectedPath = self.exchangeTable.indexPathForSelectedRow;
    MEXExchangeTableCell* cell = [self.exchangeTable cellForRowAtIndexPath:selectedPath];
    if (nil == cell) {
        return;
    }
    [self amountDidChange:cell.amountField];
}

#pragma mark table view delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MEXExchangeTableCell* cell = (MEXExchangeTableCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.parentTable = tableView;
    cell.indexPath = indexPath;
    cell.tag = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MEXAmountTextField* amountInput = cell.amountField;
    
    MEXCurrency* currency = self.currencies[indexPath.row];
    [cell setCurrency:currency];
    
    if (self.amounts.count > indexPath.row) {
        [cell setAmount:self.amounts[indexPath.row]];
    } else {
        [cell setAmount:[MEXMoney zero]];
    }
    amountInput.currency = currency;
    
    [amountInput addTarget:self action:@selector(amountDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currencies.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MEXExchangeTableCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell becomeFirstResponder];
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
        MEXMoney* amount = [self.rateSource exchangeFromCurrency:currentCurrency toCurrency:currency amount:currentAmount];
        [amounts addObject:amount];
    }];
    self.amounts = amounts;
    [self.exchangeTable reloadRowsAtIndexPaths:sections withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < -20) {
        self.lastUpdateLabel.alpha = 1.0;
    } else {
        self.lastUpdateLabel.alpha = 0.0;
    }
}

#pragma mark keyboard handling

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.exchangeTable.contentInset = contentInsets;
    self.exchangeTable.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.exchangeTable.contentInset = contentInsets;
    self.exchangeTable.scrollIndicatorInsets = contentInsets;
}

@end

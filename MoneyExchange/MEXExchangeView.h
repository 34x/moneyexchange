//
//  MEXExchangeView.h
//  MoneyExchange
//
//  Created by Max on 15/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEXMoney.h"
#import "MEXExchangeRate.h"

@interface MEXExchangeView : UIView
@property (nonatomic) void (^valueDidChange)(MEXMoney*);

- (void)setAmount:(MEXMoney*)amount;
- (void)setRate:(MEXExchangeRate*)rate;
@end

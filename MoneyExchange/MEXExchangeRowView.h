//
//  MEXExchangeRowView.h
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEXMoney.h"
#import "MEXExchangeRate.h"

@class MEXExchangeRowView;

@protocol MEXExchangeRowViewDelegate <NSObject>

@optional
-(void)exchangeView:(MEXExchangeRowView*)view didChangeValue:(MEXMoney*)value;

@end

@interface MEXExchangeRowView : UIView
@property (nonatomic) id<MEXExchangeRowViewDelegate> delegate;
- (void)setAmount:(MEXMoney*)amount;
- (void)setRate:(MEXExchangeRate*)rate;
@end

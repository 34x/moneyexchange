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

@class MEXExchangeRowView, MEXMoneyAccount, MEXExchangeView;

typedef enum : NSUInteger {
    MEXExchangeViewTypeSource,
    MEXExchangeViewTypeDestination,
} MEXExchangeViewType;

@protocol MEXExchangeRowViewDelegate <NSObject>

@optional
-(void)exchangeView:(MEXExchangeRowView*)view didChangeValue:(MEXMoney*)value;
-(void)exchangeView:(MEXExchangeRowView*)view didChangeExchangeView:(MEXExchangeView*)exchangeView;

@end

@interface MEXExchangeRowView : UIView
@property (nonatomic) NSArray<MEXMoneyAccount*>* accounts;
@property (nonatomic) id<MEXExchangeRowViewDelegate> delegate;
@property (nonatomic) MEXExchangeViewType type;

- (void)setAmount:(MEXMoney*)amount;
- (void)setRate:(MEXExchangeRate*)rate;
@end

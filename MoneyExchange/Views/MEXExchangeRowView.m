//
//  MEXExchangeRowView.m
//  MoneyExchange
//
//  Created by Max on 13/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXExchangeRowView.h"
#import "InfinityScroll.h"
#import "MEXExchangeView.h"
#import "MEXMoneyAccount.h"

@interface MEXExchangeRowView() <InfinityScrollDelegate>
@property (nonatomic) UIPageControl* pageControl;
@property (nonatomic) MEXExchangeView* currentAccount;
@end

@implementation MEXExchangeRowView


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.type = MEXExchangeViewTypeSource;
    
    InfinityScroll* scroll = [[InfinityScroll alloc] initWithFrame:self.bounds];
    scroll.infinityDelegate = self;
    scroll.prefetchSize = 3;
    [self addSubview:scroll];
    
    
    CGFloat pageControlHeight = 16;
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - pageControlHeight, self.frame.size.width, pageControlHeight)];
    
    self.pageControl.numberOfPages = 3;
    [self.pageControl setCurrentPage: 1];
    self.pageControl.alpha = 0.6;
    self.pageControl.enabled = NO;
    [self addSubview:self.pageControl];
}

- (void)amountValueDidChange:(MEXMoney*)amount {
    if ([self.delegate respondsToSelector:@selector(exchangeView:didChangeValue:)]) {
        [self.delegate exchangeView:self didChangeValue:amount];
    }
}

- (void)setAmount:(MEXMoney *)amount {
    [self.currentAccount setAmount:amount];
}

- (void)setRate:(MEXExchangeRate *)rate {
    [self.currentAccount setRate:rate];
}

- (void)setAccounts:(NSArray<MEXMoneyAccount*>*)accounts {
    _accounts = accounts;
    
    self.pageControl.numberOfPages = accounts.count;
}

- (BOOL)becomeFirstResponder {
    return [self.currentAccount becomeFirstResponder];
}

- (BOOL)isFirstResponder {
    return self.currentAccount.isFirstResponder;
}

#pragma mark InfinityScroll delegate

-(NSInteger)pageFromPath:(NSIndexPath*)path {
    return labs(path.section) % self.accounts.count;
}

- (UIView*) infinityScrollViewForIndexPath:(NSIndexPath *)indexPath {
    NSInteger page = [self pageFromPath:indexPath];
    
    MEXExchangeView* exchangeView = [[MEXExchangeView alloc] initWithFrame:self.bounds];
    
    exchangeView.type = self.type;
    [exchangeView setAccount:[self.accounts objectAtIndex:page]];
    
    MEXExchangeRowView* __weak weakSelf = self;
    exchangeView.valueDidChange = ^(MEXMoney* amount){
        [weakSelf amountValueDidChange:amount];
    };
    
    return exchangeView;
}

- (void) infinityScrollDidShowView:(UIView *)view atPath:(NSIndexPath *)indexPath {
    MEXExchangeView* exchangeView = (MEXExchangeView*)view;
    // Keep input focus for the same row while changing accounts
    // and keep the same amount
    if(self.currentAccount.isFirstResponder) {
        [view becomeFirstResponder];
        [exchangeView setAmount:self.currentAccount.amount];
    }
    
    self.currentAccount = exchangeView;
    
    NSInteger page = [self pageFromPath:indexPath];
    [self.pageControl setCurrentPage:page];
    
    if ([self.delegate respondsToSelector:@selector(exchangeView:didChangeExchangeView:)]) {
        [self.delegate exchangeView:self didChangeExchangeView:self.currentAccount];
    }
}
@end

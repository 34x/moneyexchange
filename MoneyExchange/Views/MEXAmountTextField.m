//
//  MEXAmountTextField.m
//  MoneyExchange
//
//  Created by Max on 22/09/2017.
//  Copyright © 2017 34x. All rights reserved.
//

#import "MEXAmountTextField.h"

@implementation MEXAmountTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (MEXMoney*)amount {
    @try {
        return [MEXMoney fromString:self.text];
    } @catch (NSException* exception) {
        return [MEXMoney zero];
    }
}

- (BOOL)becomeFirstResponder {
    BOOL result = [super becomeFirstResponder];
    
    self.selectedTextRange = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    
    return result;
}

@end

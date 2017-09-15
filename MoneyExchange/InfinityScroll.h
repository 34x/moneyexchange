//
//  InfinityScroll.h
//  InfinityScroll
//
//  Created by Max on 09.05.17.
//  Copyright © 2017 34x. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfinityScrollDelegate <NSObject>

@optional

- (UIView* _Nullable) infinityScrollViewForIndexPath:(NSIndexPath*_Nonnull)indexPath;
- (void) infinityScrollDidShowView:(UIView*)view atPath:(NSIndexPath* _Nonnull)indexPath;

@end

@interface InfinityScroll : UIScrollView
@property (nonatomic, weak) id <InfinityScrollDelegate> _Nullable infinityDelegate;
@property (nonatomic) NSInteger prefetchSize;
@end

//
//  InfinityScroll.m
//  InfinityScroll
//
//  Created by Max on 09.05.17.
//  Copyright © 2017 34x. All rights reserved.
//

#import "InfinityScroll.h"

@interface InfinityScroll()
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

@end

typedef enum : NSUInteger {
    ScrollNone,
    ScrollHorisontal,
    ScrollVertical,
} ScrollDirection;

@implementation InfinityScroll {
    ScrollDirection scrollDirection;
    NSMutableDictionary *cells;
    NSMutableDictionary *cellsInternal;
    BOOL reinit;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
    
    cells = [NSMutableDictionary new];
    
    reinit = YES;
    self.prefetchSize = 5;
}

-(CGPoint)offset {

    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;

    CGFloat x = (contentSize.width - boundsSize.width * 2.0);
    CGFloat y = (contentSize.height - boundsSize.height * 2.0);

    CGPoint offset = CGPointMake(x, y);

    return offset;
}


-(void)addSubview:(UIView *)view {
    [self makeCenterIfRequired];
    
    CGPoint centerOffset = [self offset];
    CGPoint viewCenter = view.center;

    viewCenter.x += centerOffset.x + self.x;
    viewCenter.y += centerOffset.y + self.y;

    view.center = viewCenter;
//    NSLog(@"ADD with LEFT CORNER::: %@", NSStringFromCGPoint(view.frame.origin));

    [super addSubview:view];
}

- (void)makeCenterIfRequired {

    CGPoint currentOffset = [self contentOffset];
//    CGSize contentSize = [self contentSize];

    CGPoint centerOffset = [self offset];

    
//    CGFloat distanceFromCenterHorisontal = fabs(currentOffset.x - centerOffset.x);
//    CGFloat distanceFromCenterVertical = fabs(currentOffset.y - centerOffset.y);
//    CGFloat distanceToUpdate = fmin(contentSize.width / 4.0, contentSize.height / 4.0);
    
    CGFloat distanceToUpdateX = self.bounds.size.width * 2.0;
    CGFloat distanceToUpdateY = self.bounds.size.height * 2.0;
//    NSLog(@"DIST: %.2f %.2f %.2f", fabs(currentOffset.x), distanceToUpdate, centerOffset.x);
//    NSLog(@"Updating %li subviews", self.subviews.count);
    
    BOOL isMoved = NO;
    
    if (0.0 == currentOffset.x || currentOffset.x == distanceToUpdateX) {
        self.contentOffset = CGPointMake(centerOffset.x, self.contentOffset.y);
        
        CGFloat offsetX = centerOffset.x - currentOffset.x;
        
        self.x += offsetX;
        
        for (UIView *subView in self.subviews) {
            CGPoint center = [self convertPoint:subView.center toView:self];
            center.x += offsetX;

            subView.center = [self convertPoint:center toView:self];
        }

        isMoved = YES;
    }
    
    if (0.0 == currentOffset.y || currentOffset.y == distanceToUpdateY) {
        self.contentOffset = CGPointMake(self.contentOffset.x, centerOffset.y);
        
        CGFloat offsetY = centerOffset.y - currentOffset.y;
        
        self.y += offsetY;
        
        
        for (UIView *subView in self.subviews) {
            CGPoint center = [self convertPoint:subView.center toView:self];
            center.y += offsetY;
            
            subView.center = [self convertPoint:center toView:self];
        }

        isMoved = YES;
    }
    
    if (isMoved) {
        [self cleanUp];
        int x = floor(self.x / self.bounds.size.width)  * -1;
        int y = floor(self.y / self.bounds.size.height) * -1;
        
        [self renderItemsAt:x y:y];
        
        if ([self.infinityDelegate respondsToSelector:@selector(infinityScrollDidShowView:atPath:)]) {
            NSIndexPath* path = [NSIndexPath indexPathForRow:y inSection:x];
            [self.infinityDelegate infinityScrollDidShowView:cells[path] atPath:path];
        }
    }
    
}

-(void)renderItemsAt:(NSInteger)x y:(NSInteger)y {
    NSInteger delta = floor(self.prefetchSize / 2.0);
    
    for (NSInteger xi = -delta; xi < delta + 1; xi ++) {
        for (NSInteger yi = -delta; yi < delta + 1; yi++) {
            [self renderViewAt:[NSIndexPath indexPathForRow:y + yi inSection:x + xi]];
        }
    }

}

-(void)cleanUp {
    CGSize distance = CGSizeMake(self.contentSize.width * 2.0, self.contentSize.height * 2.0);
    
    
    
    [cells enumerateKeysAndObjectsUsingBlock:^(NSIndexPath*  _Nonnull key, UIView*  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSLog(@"View center: %@", NSStringFromCGPoint(obj.center));
        CGFloat distanceX = fabs(obj.center.x);
        CGFloat distanceY = fabs(obj.center.y);
        if (distance.width < distanceX || distance.height < distanceY) {
            
//            NSLog(@"Removing cell at %lix%li, x%.2f y%.2f distance: %@", key.section, key.row, distanceX, distanceY, NSStringFromCGSize(distance));
            
            [cells removeObjectForKey:key];
            [obj removeFromSuperview];
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (reinit) {
        CGSize size = CGSizeMake(self.bounds.size.width * 3.0, self.bounds.size.height * 3.0);
        self.contentSize = size;
//        NSLog(@"SIZE: %@", NSStringFromCGSize(size));
        // to get initial offset correct
        self.x = 0;
        self.y = 0;

        self.contentOffset = [self offset];
        scrollDirection = ScrollNone;
        reinit = NO;
        
        [self renderItemsAt:0 y:0];
        
        if ([self.infinityDelegate respondsToSelector:@selector(infinityScrollDidShowView:atPath:)]) {
            NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.infinityDelegate infinityScrollDidShowView:cells[path] atPath:path];
        }
    }

    [self lockDirection];
    
    
    
    [self makeCenterIfRequired];
}


-(void)lockDirection {
    if (!self.pagingEnabled) {
        return;
    }
    
    CGPoint point = [self offset];
    CGFloat lockFactor = 1.0;


    CGFloat offsetX = fabs(point.x - self.contentOffset.x);
    CGFloat offsetY = fabs(point.y - self.contentOffset.y);

    if (offsetX > offsetY && offsetX > lockFactor) {
        scrollDirection = ScrollHorisontal;
    } else if (offsetY > offsetX && offsetY > lockFactor) {
        scrollDirection = ScrollVertical;
    } else {
        scrollDirection = ScrollNone;
    }

    if (ScrollHorisontal == scrollDirection) {
        self.contentOffset = CGPointMake(self.contentOffset.x, point.y);
    } else if (ScrollVertical == scrollDirection) {
        self.contentOffset = CGPointMake(point.x, self.contentOffset.y);
    }
}

-(void)renderViewAt:(NSIndexPath*)indexPath {
    if (![self.infinityDelegate respondsToSelector:@selector(infinityScrollViewForIndexPath:)]) {
        return;
    }

    UIView *view = cells[indexPath];
    if (!view) {
        view =[self.infinityDelegate infinityScrollViewForIndexPath:indexPath];
        cells[indexPath] = view;
        
        CGPoint corner = view.frame.origin;
        
        corner.x += (indexPath.section) * self.bounds.size.width;
        corner.y += (indexPath.row) * self.bounds.size.height;
        
        view.frame = CGRectMake(corner.x, corner.y, view.frame.size.width, view.frame.size.height);
        
        [self addSubview:view];
    }

    if (!view) {
        NSLog(@"No view :(");
        return;
    }
}

-(void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    [super setContentOffset:contentOffset animated:animated];
    [self makeCenterIfRequired];
}

@end

//
//  CBStoreHouseRefreshControl.m
//  CBStoreHouseRefreshControl
//
//  Created by coolbeet on 10/30/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import "CBStoreHouseRefreshControl.h"
#import "BarItem.h"

static const CGFloat kloadingIndividualAnimationTiming = 0.8;
static const CGFloat kbarDarkAlpha = 0.4;
static const CGFloat kloadingTimingOffset = 0.1;
static const CGFloat kdisappearDuration = 1.2;
static const CGFloat krelativeHeightFactor = 2.f/5.f;

typedef enum {
    CBStoreHouseRefreshControlStateIdle = 0,
    CBStoreHouseRefreshControlStateRefreshing = 1,
    CBStoreHouseRefreshControlStateDisappearing = 2
} CBStoreHouseRefreshControlState;

NSString *const startPointKey = @"startPoints";
NSString *const endPointKey = @"endPoints";
NSString *const xKey = @"x";
NSString *const yKey = @"y";

@interface CBStoreHouseRefreshControl () <UIScrollViewDelegate>

@property (nonatomic) CBStoreHouseRefreshControlState state;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *barItems;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) id target;
@property (nonatomic) SEL action;

@property (nonatomic) CGFloat dropHeight;
@property (nonatomic) CGFloat originalTopContentInset;
@property (nonatomic) CGFloat disappearProgress;
@property (nonatomic) CGFloat internalAnimationFactor;
@property (nonatomic) int horizontalRandomness;
@property (nonatomic) BOOL reverseLoadingAnimation;

@end

@implementation CBStoreHouseRefreshControl

+ (CBStoreHouseRefreshControl*)attachToScrollView:(UIScrollView *)scrollView
                    target:(id)target
             refreshAction:(SEL)refreshAction
                     plist:(NSString *)plist
{
    return [CBStoreHouseRefreshControl attachToScrollView:scrollView
                                                   target:target
                                            refreshAction:refreshAction
                                                    plist:plist
                                                    color:[UIColor whiteColor]
                                                lineWidth:2
                                               dropHeight:80
                                                    scale:1
                                     horizontalRandomness:150
                                  reverseLoadingAnimation:NO
                                  internalAnimationFactor:0.7];
}

+ (CBStoreHouseRefreshControl*)attachToScrollView:(UIScrollView *)scrollView
                                           target:(id)target
                                    refreshAction:(SEL)refreshAction
                                            plist:(NSString *)plist
                                            color:(UIColor*)color
                                        lineWidth:(CGFloat)lineWidth
                                       dropHeight:(CGFloat)dropHeight
                                            scale:(CGFloat)scale
                             horizontalRandomness:(CGFloat)horizontalRandomness
                          reverseLoadingAnimation:(BOOL)reverseLoadingAnimation
                          internalAnimationFactor:(CGFloat)internalAnimationFactor
{
    CBStoreHouseRefreshControl *refreshControl = [[CBStoreHouseRefreshControl alloc] init];
    refreshControl.dropHeight = dropHeight;
    refreshControl.horizontalRandomness = horizontalRandomness;
    refreshControl.scrollView = scrollView;
    refreshControl.target = target;
    refreshControl.action = refreshAction;
    refreshControl.reverseLoadingAnimation = reverseLoadingAnimation;
    refreshControl.internalAnimationFactor = internalAnimationFactor;
    [scrollView addSubview:refreshControl];
    
    // Calculate frame according to points max width and height
    CGFloat width = 0;
    CGFloat height = 0;
    NSDictionary *rootDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plist ofType:@"plist"]];
    NSArray *startPoints = [rootDictionary objectForKey:startPointKey];
    NSArray *endPoints = [rootDictionary objectForKey:endPointKey];
    for (int i=0; i<startPoints.count; i++) {
        
        CGPoint startPoint = CGPointFromString(startPoints[i]);
        CGPoint endPoint = CGPointFromString(endPoints[i]);
        
        if (startPoint.x > width) width = startPoint.x;
        if (endPoint.x > width) width = endPoint.x;
        if (startPoint.y > height) height = startPoint.y;
        if (endPoint.y > height) height = endPoint.y;
    }
    refreshControl.frame = CGRectMake(0, 0, width, height);

    // Create bar items
    NSMutableArray *mutableBarItems = [[NSMutableArray alloc] init];
    for (int i=0; i<startPoints.count; i++) {
        
        CGPoint startPoint = CGPointFromString(startPoints[i]);
        CGPoint endPoint = CGPointFromString(endPoints[i]);

        BarItem *barItem = [[BarItem alloc] initWithFrame:refreshControl.frame startPoint:startPoint endPoint:endPoint color:color lineWidth:lineWidth];
        barItem.tag = i;
        barItem.backgroundColor=[UIColor clearColor];
        barItem.alpha = 0;
        [mutableBarItems addObject:barItem];
        [refreshControl addSubview:barItem];
        
        [barItem setHorizontalRandomness:refreshControl.horizontalRandomness dropHeight:refreshControl.dropHeight];
    }
    
    refreshControl.barItems = [NSArray arrayWithArray:mutableBarItems];
    refreshControl.frame = CGRectMake(0, 0, width, height);
    refreshControl.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 0);
    for (BarItem *barItem in refreshControl.barItems) {
        [barItem setupWithFrame:refreshControl.frame];
    }

    refreshControl.transform = CGAffineTransformMakeScale(scale, scale);
    return refreshControl;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll
{
    if (self.originalTopContentInset == 0) self.originalTopContentInset = self.scrollView.contentInset.top;
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.realContentOffsetY*krelativeHeightFactor);
    if (self.state == CBStoreHouseRefreshControlStateIdle)
        [self updateBarItemsWithProgress:self.animationProgress];
}

- (void)scrollViewDidEndDragging
{
    if (self.state == CBStoreHouseRefreshControlStateIdle && self.realContentOffsetY < -self.dropHeight) {

        if (self.animationProgress == 1) self.state = CBStoreHouseRefreshControlStateRefreshing;
        
        if (self.state == CBStoreHouseRefreshControlStateRefreshing) {
            
            UIEdgeInsets newInsets = self.scrollView.contentInset;
            newInsets.top = self.originalTopContentInset + self.dropHeight;
            CGPoint contentOffset = self.scrollView.contentOffset;
            
            [UIView animateWithDuration:0 animations:^(void) {
                self.scrollView.contentInset = newInsets;
                self.scrollView.contentOffset = contentOffset;
            }];
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            if ([self.target respondsToSelector:self.action])
                [self.target performSelector:self.action withObject:self];
            
            #pragma clang diagnostic pop
            
            [self startLoadingAnimation];
        }
    }
}

#pragma mark Private Methods

- (CGFloat)animationProgress
{
    return MIN(1.f, MAX(0, fabsf(self.realContentOffsetY)/self.dropHeight));
}

- (CGFloat)realContentOffsetY
{
    return self.scrollView.contentOffset.y + self.originalTopContentInset;
}

- (void)updateBarItemsWithProgress:(CGFloat)progress
{
    for (BarItem *barItem in self.barItems) {
        NSInteger index = [self.barItems indexOfObject:barItem];
        CGFloat startPadding = (1 - self.internalAnimationFactor) / self.barItems.count * index;
        CGFloat endPadding = 1 - self.internalAnimationFactor - startPadding;
        
        if (progress == 1 || progress >= 1 - endPadding) {
            barItem.transform = CGAffineTransformIdentity;
            barItem.alpha = kbarDarkAlpha;
        }
        else if (progress == 0) {
            [barItem setHorizontalRandomness:self.horizontalRandomness dropHeight:self.dropHeight];
        }
        else {
            CGFloat realProgress;
            if (progress <= startPadding)
                realProgress = 0;
            else
                realProgress = MIN(1, (progress - startPadding)/self.internalAnimationFactor);
            barItem.transform = CGAffineTransformMakeTranslation(barItem.translationX*(1-realProgress), -self.dropHeight*(1-realProgress));
            barItem.transform = CGAffineTransformRotate(barItem.transform, M_PI*(realProgress));
            barItem.transform = CGAffineTransformScale(barItem.transform, realProgress, realProgress);
            barItem.alpha = realProgress * kbarDarkAlpha;
        }
    }
}

- (void)startLoadingAnimation
{
    if (self.reverseLoadingAnimation) {
        int count = (int)self.barItems.count;
        for (int i= count-1; i>=0; i--) {
            BarItem *barItem = [self.barItems objectAtIndex:i];
            [self performSelector:@selector(barItemAnimation:) withObject:barItem afterDelay:(self.barItems.count-i-1)*kloadingTimingOffset inModes:@[NSRunLoopCommonModes]];
        }
    }
    else {
        for (int i=0; i<self.barItems.count; i++) {
            BarItem *barItem = [self.barItems objectAtIndex:i];
            [self performSelector:@selector(barItemAnimation:) withObject:barItem afterDelay:i*kloadingTimingOffset inModes:@[NSRunLoopCommonModes]];
        }
    }
}

- (void)barItemAnimation:(BarItem*)barItem
{
    if (self.state == CBStoreHouseRefreshControlStateRefreshing) {
        barItem.alpha = 1;
        [barItem.layer removeAllAnimations];
        [UIView animateWithDuration:kloadingIndividualAnimationTiming animations:^{
            barItem.alpha = kbarDarkAlpha;
        } completion:^(BOOL finished) {
            
        }];
        
        BOOL isLastOne;
        if (self.reverseLoadingAnimation)
            isLastOne = barItem.tag == 0;
        else
            isLastOne = barItem.tag == self.barItems.count-1;
            
        if (isLastOne && self.state == CBStoreHouseRefreshControlStateRefreshing) {
            [self startLoadingAnimation];
        }
    }
}

- (void)updateDisappearAnimation
{
    if (self.disappearProgress >= 0 && self.disappearProgress <= 1) {
        self.disappearProgress -= 1/60.f/kdisappearDuration;
        //60.f means this method get called 60 times per second
        [self updateBarItemsWithProgress:self.disappearProgress];
    }
}

#pragma mark Public Methods

- (void)finishingLoading
{
    self.state = CBStoreHouseRefreshControlStateDisappearing;
    UIEdgeInsets newInsets = self.scrollView.contentInset;
    newInsets.top = self.originalTopContentInset;
    [UIView animateWithDuration:kdisappearDuration animations:^(void) {
        self.scrollView.contentInset = newInsets;
    } completion:^(BOOL finished) {
        self.state = CBStoreHouseRefreshControlStateIdle;
        [self.displayLink invalidate];
        self.disappearProgress = 1;
    }];

    for (BarItem *barItem in self.barItems) {
        [barItem.layer removeAllAnimations];
        barItem.alpha = kbarDarkAlpha;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisappearAnimation)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.disappearProgress = 1;
}

@end

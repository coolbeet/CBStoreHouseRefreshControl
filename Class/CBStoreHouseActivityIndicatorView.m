//
//  CBStoreHouseActivityIndicatorView.m
//  CBStoreHouseRefreshControl
//
//  Created by Dal Rupnik on 18/02/15.
//  Copyright (c) 2015 Suyu Zhang. All rights reserved.
//

#import "CBStoreHouseRefreshControl.h"
#import "CBStoreHouseActivityIndicatorView.h"

#import "BarItem.h"

@interface CBStoreHouseActivityIndicatorView ()

@property (nonatomic, copy) NSArray* startPoints;
@property (nonatomic, copy) NSArray* endPoints;

@property (nonatomic, strong) NSArray *barItems;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat internalAnimationFactor;

@property (nonatomic, assign, getter = isLoaded) BOOL loaded;

/*!
 *  Tells if we are building the bars, or separating
 */
@property (nonatomic, assign, getter = isLoadingAnimationIn) BOOL loadingAnimationIn;

@end

@implementation CBStoreHouseActivityIndicatorView

- (void)setAnimating:(BOOL)animating
{
    _animating = animating;
    
    [self load];
    
    if (animating == YES)
    {
        if (self.hasLoadingAnimation)
        {
            self.loadingAnimationIn = YES;
            [self startLoadingAnimation];
        }
        else
        {
            [self updateBarItemsWithProgress:1.0];
            [self startIndeterminateAnimation];
        }
    }
    else
    {
        if (self.hasLoadingAnimation)
        {
            self.loadingAnimationIn = NO;
            [self startLoadingAnimation];
        }
    }
}

- (instancetype)initWithStartPoints:(NSArray *)startPoints endPoints:(NSArray *)endPoints;
{
    self = [super initWithFrame:CGRectZero];
    
    if (self)
    {
        self.color = [UIColor whiteColor];
        self.lineWidth = 2;
        self.animationHeight = 80;
        self.scale = 1;
        self.horizontalRandomness = 150;
        self.reverseLoadingAnimation = NO;
        self.internalAnimationFactor = 0.7;
        self.loadingAnimationDuration = 1.2;
        self.startPoints = startPoints;
        self.endPoints = endPoints;
    }
    
    return self;
}

- (NSDictionary *)loadPointsFromPlist:(NSString *)plist
{
    NSDictionary *rootDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plist ofType:@"plist"]];
    NSArray *startPoints = [rootDictionary objectForKey:startPointKey];
    NSArray *endPoints = [rootDictionary objectForKey:endPointKey];
    
    return @{ startPointKey : startPoints, endPointKey : endPoints };
}

- (instancetype)initWithPlist:(NSString *)plist
{
    NSDictionary* points = [self loadPointsFromPlist:plist];
    
    return [self initWithStartPoints:points[startPointKey] endPoints:points[endPointKey]];
}

- (void)setStartPoints:(NSArray *)startPoints endPoints:(NSArray *)endPoints
{
    self.startPoints = startPoints;
    self.endPoints = endPoints;
}

- (void)load
{
    if (self.isLoaded)
    {
        return;
    }
    
    self.loaded = YES;
    
    //
    // Calculate frame according to points max width and height
    //
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    for (int i = 0; i < self.startPoints.count; i++)
    {
        CGPoint startPoint = [self pointFromObject:self.startPoints[i]];
        CGPoint endPoint = [self pointFromObject:self.endPoints[i]];
        
        if (startPoint.x > width)
        {
            width = startPoint.x;
        }
        if (endPoint.x > width)
        {
            width = endPoint.x;
        }
        if (startPoint.y > height)
        {
            height = startPoint.y;
        }
        if (endPoint.y > height)
        {
            height = endPoint.y;
        }
    }

    CGRect bounds = CGRectMake(0, 0, width, height);
    
    // Create bar items
    NSMutableArray *mutableBarItems = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.startPoints.count; i++)
    {
        
        CGPoint startPoint = [self pointFromObject:self.startPoints[i]];
        CGPoint endPoint = [self pointFromObject:self.endPoints[i]];
        
        BarItem *barItem = [[BarItem alloc] initWithFrame:bounds startPoint:startPoint endPoint:endPoint color:self.color lineWidth:self.lineWidth];
        barItem.tag = i;
        barItem.backgroundColor = [UIColor clearColor];
        barItem.alpha = 0.0;
        
        [mutableBarItems addObject:barItem];
        [self addSubview:barItem];
        
        [barItem setHorizontalRandomness:self.horizontalRandomness dropHeight:self.animationHeight];
    }
    
    self.barItems = [mutableBarItems copy];

    for (BarItem *barItem in self.barItems)
    {
        [barItem setupWithFrame:bounds];
    }
    
    self.transform = CGAffineTransformMakeScale (self.scale, self.scale);
}


#pragma mark Private Methods

- (CGPoint)pointFromObject:(id)object
{
    if ([object isKindOfClass:[NSString class]])
    {
        return CGPointFromString(object);
    }
    else if ([object isKindOfClass:[NSValue class]])
    {
        NSValue* value = object;
        
        return [value CGPointValue];
    }
    
    return CGPointZero;
}

- (void)updateBarItemsWithProgress:(CGFloat)progress
{
    for (BarItem *barItem in self.barItems)
    {
        NSInteger index = [self.barItems indexOfObject:barItem];
        CGFloat startPadding = (1 - self.internalAnimationFactor) / self.barItems.count * index;
        CGFloat endPadding = 1 - self.internalAnimationFactor - startPadding;
        
        if (progress == 1 || progress >= 1 - endPadding)
        {
            barItem.transform = CGAffineTransformIdentity;
            barItem.alpha = kbarDarkAlpha;
        }
        else if (progress == 0)
        {
            [barItem setHorizontalRandomness:self.horizontalRandomness dropHeight:self.animationHeight];
        }
        else
        {
            CGFloat realProgress;
            
            if (progress <= startPadding)
            {
                realProgress = 0;
            }
            else
            {
                realProgress = MIN(1, (progress - startPadding)/self.internalAnimationFactor);
            }
            
            barItem.transform = CGAffineTransformMakeTranslation(barItem.translationX * (1 - realProgress), -self.animationHeight * (1 - realProgress));
            barItem.transform = CGAffineTransformRotate(barItem.transform, M_PI*(realProgress));
            barItem.transform = CGAffineTransformScale(barItem.transform, realProgress, realProgress);
            barItem.alpha = realProgress * kbarDarkAlpha;
        }
    }
}

- (void)startIndeterminateAnimation
{
    if (self.progress > 0.0 && self.progress < 1.0)
    {
        //NSLog(@"Prog: %f", self.progress);
        
        return;
    }
    
    if (self.reverseLoadingAnimation)
    {
        int count = (int)self.barItems.count;
        
        for (int i = count - 1; i >= 0; i--)
        {
            BarItem *barItem = [self.barItems objectAtIndex:i];
            [self performSelector:@selector(barItemAnimation:) withObject:barItem afterDelay:(self.barItems.count - i - 1) * kloadingTimingOffset inModes:@[NSRunLoopCommonModes]];
        }
    }
    else
    {
        for (int i = 0; i < self.barItems.count; i++)
        {
            BarItem *barItem = [self.barItems objectAtIndex:i];
            
            [self performSelector:@selector(barItemAnimation:) withObject:barItem afterDelay:i * kloadingTimingOffset inModes:@[ NSRunLoopCommonModes ]];
        }
    }
}

- (void)barItemAnimation:(BarItem*)barItem
{
    if (self.progress > 0.0 && self.progress < 1.0)
    {
        //NSLog(@"Prog: %f", self.progress);
        
        return;
    }
    
    barItem.alpha = 1;
    [barItem.layer removeAllAnimations];
    [UIView animateWithDuration:kloadingIndividualAnimationTiming animations:^
    {
        barItem.alpha = kbarDarkAlpha;
    } completion:nil];
    
    BOOL isLastOne;
    
    if (self.reverseLoadingAnimation)
    {
        isLastOne = barItem.tag == 0;
    }
    else
    {
        isLastOne = barItem.tag == self.barItems.count - 1;
    }
    
    if (isLastOne && self.animating)
    {
        [self startIndeterminateAnimation];
    }
}

- (void)updateLoadingAnimation
{
    if (self.progress >= 0 && self.progress <= 1)
    {
        NSTimeInterval step = 1.0 / 60.f / self.loadingAnimationDuration;
        
        if (self.isLoadingAnimationIn)
        {
            self.progress += step;
        }
        else
        {
            self.progress -= step;
        }
        
        //60.f means this method get called 60 times per second
        [self updateBarItemsWithProgress:self.progress];
    }
}

- (void)startLoadingAnimation
{
    //BOOL loadingAnimationIn = self.isLoadingAnimationIn;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLoadingAnimation)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

    if (self.isLoadingAnimationIn)
    {
        self.progress = 0.0;
    }
    else
    {
        self.progress = 1.0;
    }
    
    for (BarItem *barItem in self.barItems)
    {
        [barItem.layer removeAllAnimations];
        barItem.alpha = kbarDarkAlpha;
    }
    
    [self performSelector:@selector(stopLoadingAnimation) withObject:nil afterDelay:self.loadingAnimationDuration inModes:@[ NSRunLoopCommonModes ]];
}

- (void)stopLoadingAnimation
{
    [self.displayLink invalidate];
    
    if (self.isLoadingAnimationIn)
    {
        self.progress = 1.0;
        [self startIndeterminateAnimation];
    }
    else
    {
        self.progress = 0.0;
    }
    
    [self updateBarItemsWithProgress:self.progress];
}

@end

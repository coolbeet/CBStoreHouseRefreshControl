//
//  CBStoreHouseRefreshControl.h
//  CBStoreHouseRefreshControl
//
//  Created by coolbeet on 10/30/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

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

extern NSString *const startPointKey;
extern NSString *const endPointKey;
extern NSString *const xKey;
extern NSString *const yKey;

@interface CBStoreHouseRefreshControl : UIView

+ (CBStoreHouseRefreshControl*)attachToScrollView:(UIScrollView *)scrollView
                                           target:(id)target
                                    refreshAction:(SEL)refreshAction
                                            plist:(NSString *)plist;

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
                          internalAnimationFactor:(CGFloat)internalAnimationFactor;

- (void)scrollViewDidScroll;

- (void)scrollViewDidEndDragging;

- (void)finishingLoading;

@end

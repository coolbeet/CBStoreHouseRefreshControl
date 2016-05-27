//
//  CBStoreHouseRefreshControl.h
//  CBStoreHouseRefreshControl
//
//  Created by coolbeet on 10/30/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CBStoreHouseRefreshControlStateIdle = 0,
    CBStoreHouseRefreshControlStateRefreshing = 1,
    CBStoreHouseRefreshControlStateDisappearing = 2
} CBStoreHouseRefreshControlState;

@interface CBStoreHouseRefreshControl : UIView

@property (nonatomic, readonly) CBStoreHouseRefreshControlState state;

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
- (void)finishingLoading:(BOOL)animated;

- (void)triggerLoading;

@end

//
//  CBStoreHouseRefreshControl.h
//  CBStoreHouseRefreshControl
//
//  Created by coolbeet on 10/30/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBStoreHouseRefreshControl : UIView

+ (CBStoreHouseRefreshControl*)attachToScrollView:(UIScrollView *)scrollView
                                           target:(id)target
                                    refreshAction:(SEL)refreshAction
                                            plist:(NSString *)plist
                            navigationTranslucent:(BOOL)navigationTranslucent;

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
                            navigationTranslucent:(BOOL)navigationTranslucent;

- (void)scrollViewDidScroll;

- (void)scrollViewDidEndDragging;

- (void)finishingLoading;

@end

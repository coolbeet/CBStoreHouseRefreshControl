//
//  CBStoreHouseActivityIndicatorView.h
//  CBStoreHouseRefreshControl
//
//  Created by Dal Rupnik on 18/02/15.
//  Copyright (c) 2015 Suyu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBStoreHouseActivityIndicatorView : UIView

/*!
 *  Color of the shape provided on constructor
 */
@property (nonatomic, strong) UIColor* color;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGFloat animationHeight;
@property (nonatomic, assign) CGFloat horizontalRandomness;

@property (nonatomic, assign) BOOL reverseLoadingAnimation;

/*!
 *  Loading animation will first construct the item and deconstuct
 */
@property (nonatomic, assign) BOOL hasLoadingAnimation;
@property (nonatomic, assign) NSTimeInterval loadingAnimationDuration;

@property (nonatomic, assign, getter = isAnimating) BOOL animating;

/*!
 *  Loads points from Plist
 *
 *  @param frame to display
 *  @param plist to render
 *
 *  @return instance of view
 */
- (instancetype)initWithPlist:(NSString *)plist;

/*!
 *  Designated initializer: Shape of made from CGPoint structs
 *
 *  @param startPoints array of points
 *  @param endPoints array of points
 *
 *  @return instance
 */
- (instancetype)initWithStartPoints:(NSArray *)startPoints endPoints:(NSArray *)endPoints;

- (void)setStartPoints:(NSArray *)startPoints endPoints:(NSArray *)endPoints;

@end

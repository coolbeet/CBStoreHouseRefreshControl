//
//  BarItem.m
//  CBStoreHouseRefreshControl
//
//  Created by coolbeet on 10/30/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import "BarItem.h"

@interface BarItem ()

@property (nonatomic) CGPoint middlePoint;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) UIColor *color;

@end

@implementation BarItem

- (instancetype)initWithFrame:(CGRect)frame startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color lineWidth:(CGFloat)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        self.startPoint = startPoint;
        self.endPoint = endPoint;
        self.lineWidth = lineWidth;
        self.color = color;
        self.backgroundColor = [UIColor clearColor];
        
        CGPoint (^middlePoint)(CGPoint, CGPoint) = ^CGPoint(CGPoint a, CGPoint b) {
            CGFloat x = (a.x + b.x)/2.f;
            CGFloat y = (a.y + b.y)/2.f;
            return CGPointMake(x, y);
        };
        self.middlePoint = middlePoint(startPoint, endPoint);
    }
    return self;
}

- (void)setupWithFrame:(CGRect)rect
{
    self.layer.anchorPoint = CGPointMake(self.middlePoint.x/self.frame.size.width, self.middlePoint.y/self.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x + self.middlePoint.x - self.frame.size.width/2, self.frame.origin.y + self.middlePoint.y - self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
}

- (void)setHorizontalRandomness:(int)horizontalRandomness dropHeight:(CGFloat)dropHeight
{
    int randomNumber = - horizontalRandomness + arc4random()%horizontalRandomness*2;
    self.translationX = randomNumber;
    self.transform = CGAffineTransformMakeTranslation(self.translationX, -dropHeight);
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint:self.startPoint];
    [bezierPath addLineToPoint:self.endPoint];
    [self.color setStroke];
    bezierPath.lineWidth = self.lineWidth;
    [bezierPath stroke];
}

@end

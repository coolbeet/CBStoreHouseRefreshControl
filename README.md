CBStoreHouseRefreshControl
=======================

What is it?
---

A **fully customizable** pull-to-refresh control for iOS inspired by [Storehouse](https://www.storehouse.co/) iOS app

![screenshot1] (https://s3.amazonaws.com/suyu.test/CBStoreHouseRefreshControl1.gif)

You use any shape through a `plist` file, like this one which is my [company](http://akta.com/)'s logo:

![screenshot2] (https://s3.amazonaws.com/suyu.test/CBStoreHouseRefreshControl2.gif)

Which files are needed?
---
You only need to include `CBStoreHouseRefreshControl (.h .m)` in your project.

CocoaPods support is coming very soon!

How to use it
---
You can attach it to any `UIScrollView` like `UITableView` or `UICollectionView` using following simple static method:

```objective-c
+ (CBStoreHouseRefreshControl*)attachToScrollView:(UIScrollView *)scrollView
                                           target:(id)target
                                    refreshAction:(SEL)refreshAction
                                            plist:(NSString *)plist;
```
```objective-c
self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse"];
```
Or, using this method for more configurable options:

```objective-c
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
```

```objective-c
self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor whiteColor] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
```

How to use your own shape
---

The CBStoreHouseRefreshControl's shape contains bunch of `BarItem`s for animation, each `BarItem` is running its own animation, you need to provide `startPoint` and `endPoint` through a plist file. 

All `BarItem` will share one coordinate system whose origin is at the top-left corner. For example if you want to draw a square, the plist will look like this:

![screenshot2] (https://s3.amazonaws.com/suyu.test/square.png)

Note: make sure you put the right key which is `startPoints` and `endPoints`;















CBStoreHouseRefreshControl ![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)
=======================

![Version](http://cocoapod-badges.herokuapp.com/v/CBStoreHouseRefreshControl/badge.png)
![Platform](http://cocoapod-badges.herokuapp.com/p/CBStoreHouseRefreshControl/badge.png)

What is it?
---

A **fully customizable** pull-to-refresh control for iOS inspired by [Storehouse](https://www.storehouse.co/) iOS app

![screenshot1] (https://s3.amazonaws.com/suyu.test/CBStoreHouseRefreshControl1.gif)

You can use any shape through a `plist` file, like this one which is my [company](http://akta.com/)'s logo:

![screenshot2] (https://s3.amazonaws.com/suyu.test/CBStoreHouseRefreshControl2.gif)

Which files are needed?
---
CBStoreHouseRefreshControl is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod 'CBStoreHouseRefreshControl'

Alternatively, you can just drag `CBStoreHouseRefreshControl (.h .m)` and `BarItem (.h .m)` into your own project.

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
                                            color:(UIColor *)color
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

Then, implement `UIScrollViewDelegate` in your `UIViewController` if you haven't already, and pass the calls through to the refresh control:

```objective-c
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}
```

Lastly, make sure you've implemented the `refreshAction` you passed it earlier to listen for refresh triggers:

```objective-c
- (void)refreshTriggered
{
    //call your loading method here

    //Finshed loading the data, reset the refresh control
    [self.storeHouseRefreshControl finishingLoading];
}
```
For more details, please check out the demo app's code.

How to use your own shape
---

The CBStoreHouseRefreshControl's shape contains bunch of `BarItem` for animation, each `BarItem` is running its own animation, you need to provide `startPoint` and `endPoint` through a plist file. 

All `BarItem` will share one coordinate system whose origin is at the top-left corner. For example if you want to draw a square, the plist will look like this:

![screenshot2] (https://s3.amazonaws.com/suyu.test/square.png)

The result will look like this:

![screenshot3] (https://s3.amazonaws.com/suyu.test/square.gif)

#### Notes: 
- Make sure you put the right key which are `startPoints` and `endPoints`.
- Make sure you are using the right format (`{x,y}`) for coordinates.
- The highlight/loading animation will highlight each bar item in the same order you declare them in plist, use `reverseLoadingAnimation` to reverse the animation.

Easy way to generate `startPoint` and `endPoint`?
---

[@isaced](https://github.com/isaced) mentions that it's easier to use [PaintCode](http://www.paintcodeapp.com/) to generate `startPoint` and `endPoint`:

![screenshot4] (https://cloud.githubusercontent.com/assets/2088605/4948694/0ce2da74-667f-11e4-8ce7-a2067f15558d.png)

Result:

![screenshot5] (https://cloud.githubusercontent.com/assets/2088605/4948707/3b76afb4-667f-11e4-91a4-9509d17356fa.gif)

You can get more info [here](https://github.com/coolbeet/CBStoreHouseRefreshControl/issues/1).

Configuration
-------------

Play with following parameters to configure CBStoreHouseRefreshControl's view and animation:

- Set the bar color with the `color` parameter
- Set the bar width with the `lineWidth` parameter
- Set the height of control with the `dropHeight` parameter
- Set the scale of control with the `scale` parameter
- Adjust how disperse the bar items appear/disappear by changing the `horizontalRandomness` parameter
- Set if reversing the loading animation with the `reverseLoadingAnimation` parameter, if set to `YES`, the last bar item will be highlighted firstly.
- Adjust the time offset of the appear/disappear animation by changing the `internalAnimationFactor` parameter, for example if `internalAnimationFactor` is 1 all bar items will appear/disappear all together.

Who's using it?
---------------

We've a [wiki page](https://github.com/coolbeet/CBStoreHouseRefreshControl/wiki) for that, feel free to add your projects there!

Author
------

Suyu Zhang  
suyu_zhang@hotmail.com  
[suyuzhang.com](http://suyuzhang.com/)  


License
-------
Copyright (c) 2014 Suyu Zhang <suyu_zhang@hotmail.com>. See the LICENSE file for license rights and limitations (MIT).





//
//  ContentViewController.m
//  CBStoreHouseRefreshControl
//
//  Created by coolbeet on 10/26/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import "ContentViewController.h"
#import "CBStoreHouseRefreshControl.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Storehouse";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.1 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithWhite:45.f/255.f alpha:1];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.alwaysBounceVertical = YES;

    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    self.tableView.tableFooterView = footer;
    
    // Let the show begins
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor whiteColor] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
    
    //self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:@"AKTA" color:[UIColor whiteColor] lineWidth:2 dropHeight:80 scale:0.7 horizontalRandomness:300 reverseLoadingAnimation:NO internalAnimationFactor:0.7];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell"]];
    image.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:image];
    
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 420;
}

#pragma mark - Notifying refresh control of scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [self.storeHouseRefreshControl finishingLoading];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

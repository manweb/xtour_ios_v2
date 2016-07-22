//
//  XTGraphPageViewController.h
//  XTour
//
//  Created by Manuel Weber on 05/08/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTGraphViewController.h"
#import "XTTourInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface XTGraphPageViewController : UIViewController<UIPageViewControllerDataSource>

@property (retain, nonatomic) UIPageViewController *pageController;
@property (retain, nonatomic) NSString *graphPath;
@property (retain, nonatomic) NSString *tourID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTourInfo:(XTTourInfo*)tourInfo;
- (XTGraphViewController *)viewControllerAtIndex:(NSUInteger)index;

@end

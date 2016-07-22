//
//  XTCalendarPageViewController.h
//  XTour
//
//  Created by Manuel Weber on 26/09/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTCalendarViewController.h"
#import "XTServerRequestHandler.h"
#import "XTTourInfo.h"

@interface XTCalendarPageViewController : UIViewController<UIPageViewControllerDataSource>

@property (nonatomic,retain) UIPageViewController *pageController;
@property (nonatomic) NSInteger maxIndex;
@property (nonatomic,retain) NSMutableDictionary *calendarData;
@property (nonatomic,retain) UIView *loadingView;

- (XTCalendarViewController*)viewControllerAtIndex:(NSUInteger)index;
- (void)SetDataForUser:(NSString*)userID;

@end

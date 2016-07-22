//
//  XTCalendarPageViewController.m
//  XTour
//
//  Created by Manuel Weber on 26/09/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import "XTCalendarPageViewController.h"

@implementation XTCalendarPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [formatter dateFromString:@"2015-01-01 00:00:01"];
    
    _maxIndex = [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:startDate toDate:[NSDate date] options:0] month];
    
    XTCalendarViewController *initialViewController = [self viewControllerAtIndex:_maxIndex];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
    
    _calendarData = [[NSMutableDictionary alloc] init];
    
    _loadingView = [[UIView alloc] initWithFrame:self.view.frame];
    
    _loadingView.alpha = 0.8f;
    
    [self.view addSubview:_loadingView];
    
    [_loadingView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_pageController release];
    [super dealloc];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(XTCalendarViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(XTCalendarViewController *)viewController index];
    
    if (index == _maxIndex) {
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
    
}

- (XTCalendarViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    XTCalendarViewController *calendarViewController = [[XTCalendarViewController alloc] initWithNibName:nil bundle:nil];
    
    calendarViewController.view.frame = self.view.frame;
    
    calendarViewController.index = index;
    
    calendarViewController.calendarData = _calendarData;
    
    [calendarViewController LoadCalendarAtIndex:index];
    
    return calendarViewController;
}

- (void) SetDataForUser:(NSString*)userID;
{
    [_calendarData removeAllObjects];
    
    [_loadingView setHidden:NO];
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_news_feed_string.php?num=%i&uid=%@&filter=%i", 1000, userID, 0];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
        XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
        
        NSMutableArray *tourData = [request GetNewsFeedString:responseData];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        for (int i = 0; i < [tourData count]; i++) {
            XTTourInfo *currentTour = [tourData objectAtIndex:i];
            
            NSInteger year = [[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:currentTour.date]] year];
            
            NSInteger month = [[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:currentTour.date]] month];
            
            NSInteger day = [[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:currentTour.date]] day];
            
            
            [_calendarData setValue:currentTour forKey:[NSString stringWithFormat:@"%04li-%02li-%02li",(long)year,(long)month,(long)day]];
            
            [self.pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:_maxIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
            [_loadingView setHidden:YES];
        }
    }];
    
    [sessionTask resume];
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
        
        NSMutableArray *tourData = [request GetNewsFeedString:10000 forUID:userID filterBest:0];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        for (int i = 0; i < [tourData count]; i++) {
            XTTourInfo *currentTour = [tourData objectAtIndex:i];
            
            NSInteger year = [[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:currentTour.date]] year];
            
            NSInteger month = [[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:currentTour.date]] month];
            
            NSInteger day = [[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate dateWithTimeIntervalSince1970:currentTour.date]] day];
            
            
            [_calendarData setValue:currentTour forKey:[NSString stringWithFormat:@"%04li-%02li-%02li",(long)year,(long)month,(long)day]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:_maxIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
            [_loadingView setHidden:YES];
        });
    });*/
}

@end

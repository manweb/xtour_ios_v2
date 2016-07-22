//
//  XTGraphPageViewController.m
//  XTour
//
//  Created by Manuel Weber on 05/08/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTGraphPageViewController.h"

@interface XTGraphPageViewController ()

@end

@implementation XTGraphPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTourInfo:(XTTourInfo*)tourInfo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tourID = [[NSString alloc] initWithString:tourInfo.tourID];
        _graphPath = [[NSString alloc] initWithFormat:@"users/%@/tours/%@", tourInfo.userID, tourInfo.tourID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    
    XTGraphViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_pageController release];
    [_graphPath release];
    [_tourID release];
    [super dealloc];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(XTGraphViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(XTGraphViewController *)viewController index];
    
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (XTGraphViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    XTGraphViewController *graphViewController = [[XTGraphViewController alloc] initWithNibName:nil bundle:nil];
    
    graphViewController.view.frame = self.view.frame;
    
    graphViewController.index = index;
    
    switch (index) {
        case 0:
            graphViewController.graphLabel.text = @"Höhe - Zeit";
            break;
            
        case 1:
            graphViewController.graphLabel.text = @"Höhe - Distanz";
            break;
            
        case 2:
            graphViewController.graphLabel.text = @"Distanz - Zeit";
            break;
    }
    
    NSURL *graphURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.xtour.ch/%@/%@_graph%lu.png",_graphPath, _tourID, (unsigned long)index+1]];
    [graphViewController.graph setImageWithURL:graphURL placeholderImage:nil];
    
    return graphViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

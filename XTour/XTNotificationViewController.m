//
//  XTNotificationViewController.m
//  XTour
//
//  Created by Manuel Weber on 07/11/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import "XTNotificationViewController.h"

@interface XTNotificationViewController ()

@end

@implementation XTNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    _width = screenBound.size.width;
    
    self.view.frame = CGRectMake(0, -70, _width, 70);
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, _width, 70);
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 20, 20)];
    
    icon.image = [UIImage imageNamed:@"xtour_icon@3x.png"];
    
    _messageView = [[UITextView alloc] initWithFrame:CGRectMake(35, 15, _width-70, 50)];
    
    _messageView.backgroundColor = [UIColor clearColor];
    _messageView.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _messageView.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    closeButton.frame = CGRectMake(_width-35, 25, 30, 30);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_icon_black@3x.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(HideView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:blurEffectView];
    [self.view addSubview:icon];
    [self.view addSubview:_messageView];
    [self.view addSubview:closeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [super dealloc];
    
    [_messageView release];
    
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_delayTimer != nil) {
        [_delayTimer invalidate];
        _delayTimer = nil;
    }
}

- (void) ShowView
{
    _delayTimer = [NSTimer scheduledTimerWithTimeInterval:_delayTime target:self selector:@selector(ShowViewDelayed) userInfo:nil repeats:NO];
}

- (void) ShowViewDelayed
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        self.view.frame = CGRectMake(0, 0, _width, 70);
    } completion:^(BOOL finished) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_displayTime target:self selector:@selector(HideView:) userInfo:nil repeats:NO];
    }];
}

- (void) HideView:(id)sender
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        self.view.frame = CGRectMake(0, -70, _width, 70);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
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

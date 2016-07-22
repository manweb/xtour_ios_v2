//
//  XTNotificationViewController.h
//  XTour
//
//  Created by Manuel Weber on 07/11/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTNotificationViewController : UIViewController

@property (nonatomic,retain) UITextView *messageView;
@property (nonatomic) float width;
@property (nonatomic) float displayTime;
@property (nonatomic) float delayTime;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,retain) NSTimer *delayTimer;

- (void) ShowView;
- (void) ShowViewDelayed;
- (void) HideView:(id)sender;

@end

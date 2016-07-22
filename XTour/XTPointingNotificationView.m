//
//  XTPointingNotificationView.m
//  XTour
//
//  Created by Manuel Weber on 03/02/16.
//  Copyright © 2016 Manuel Weber. All rights reserved.
//

#import "XTPointingNotificationView.h"

@implementation XTPointingNotificationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithSize:(CGSize)size pointingAt:(CGPoint)point direction:(NSInteger)direction message:(NSString*)message
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    
    float y = point.y-size.height-20;
    if (direction > 0) {y = point.y+10;}
    
    float offset = 0;
    if (point.x > (width+size.width)/2) {offset = point.x - (width+size.width)/2 + 15;}
    
    _direction = direction;
    
    if ([self initWithFrame:CGRectMake((width-size.width)/2+offset, y, size.width, size.height+10)]) {
        float yBackground = 0;
        if (direction > 0) {yBackground = 10;}
        
        UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, yBackground, size.width, size.height)];
        
        background.backgroundColor = [UIColor blackColor];
        [background setAlpha:0.8];
        background.layer.cornerRadius = 5.0f;
        
        UILabel *notification = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, size.width-10, size.height-10)];
        
        notification.textColor = [UIColor whiteColor];
        notification.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        notification.text = message;
        notification.textAlignment = NSTextAlignmentCenter;
        
        float yArrow = size.height;
        if (direction > 0) {yArrow = 0;}
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(point.x-(width-size.width)/2-offset-7, yArrow, 15, 10)];
        
        if (direction == 0) {[arrow setImage:[UIImage imageNamed:@"notification_arrow_down@3x.png"]];}
        else {[arrow setImage:[UIImage imageNamed:@"notification_arrow_up@3x.png"]];}
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CloseNotification:)];
        
        [background addSubview:notification];
        
        [self addSubview:background];
        [self addSubview:arrow];
        [self addGestureRecognizer:tap];
        
        [background release];
        [notification release];
        [arrow release];
        [tap release];
    }
    
    return self;
}

- (void)animateWithTimeout:(float)timeout
{
    CGRect frame = self.frame;
    
    float scale = 1;
    if (_direction > 0) {scale = -1;}
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y+scale*10, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
            self.frame = CGRectMake(frame.origin.x, frame.origin.y+scale*5, frame.size.width, frame.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
                self.frame = CGRectMake(frame.origin.x, frame.origin.y+scale*10, frame.size.width, frame.size.height);
            } completion:NULL
             ];
        }];
    }];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(CloseNotification:) userInfo:nil repeats:NO];
}

- (void)CloseNotification:(id)sender
{
    [self removeFromSuperview];
}

@end

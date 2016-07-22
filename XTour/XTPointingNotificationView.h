//
//  XTPointingNotificationView.h
//  XTour
//
//  Created by Manuel Weber on 03/02/16.
//  Copyright © 2016 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTPointingNotificationView : UIView

@property (nonatomic) NSInteger direction;

- (id)initWithSize:(CGSize)size pointingAt:(CGPoint)point direction:(NSInteger)direction message:(NSString*)message;
- (void)animateWithTimeout:(float)timeout;

@end

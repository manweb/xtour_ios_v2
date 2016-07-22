//
//  XTAppDelegate.h
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import <CoreLocation/CoreLocation.h>

@interface XTAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    XTDataSingleton *data;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) int TimeWhenBackgroundEntered;
@property (nonatomic) int TimeWhenBackgroundLeft;
@property (nonatomic,retain) CLLocationManager *LocationManager;
@property (copy) void (^backgroundSessionCompletionHandler)();

@end

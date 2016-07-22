//
//  XTLoginViewController.h
//  XTour
//
//  Created by Manuel Weber on 24/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTServerRequestHandler.h"

@interface XTLoginViewController : UIViewController
{
    XTDataSingleton *data;
    XTServerRequestHandler *serverRequest;
}

@property (retain, nonatomic) UIView *loginView;
@property (retain, nonatomic) UITextField *username;
@property (retain, nonatomic) UITextField *password;
@property (retain, nonatomic) UIButton *loginButton;
@property (retain, nonatomic) UIButton *cancelButton;
@property (retain, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) UIVisualEffectView *blurEffectView;

- (void)Login;
- (void)Cancel;
- (void) animate;
- (void) ShowView;
- (void) HideView;
- (void) ValidateLogin;
- (void) DownloadProfilePicture;
- (void) DownloadUserInfo;

@end

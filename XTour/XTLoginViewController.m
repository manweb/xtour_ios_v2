//
//  XTLoginViewController.m
//  XTour
//
//  Created by Manuel Weber on 24/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTLoginViewController.h"

@interface XTLoginViewController ()

@end

@implementation XTLoginViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    data = [XTDataSingleton singleObj];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    self.view.frame = CGRectMake(0, 0, width, height+tabBarHeight);
    //self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurEffectView.frame = self.view.frame;
    _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [_blurEffectView setHidden:YES];
    
    [self.view addSubview:_blurEffectView];
    
    _loginView = [[UIView alloc] initWithFrame:CGRectMake(10, -200, width-20, 200)];
    _loginView.layer.cornerRadius = 10.0f;
    _loginView.layer.borderWidth = 5.0f;
    _loginView.layer.borderColor = [UIColor grayColor].CGColor;
    _loginView.backgroundColor = [UIColor whiteColor];
    
    _username = [[UITextField alloc] initWithFrame:CGRectMake((width-20)/2-100, 50, 200, 30)];
    _password = [[UITextField alloc] initWithFrame:CGRectMake((width-20)/2-100, 100, 200, 30)];
    
    _username.keyboardType = UIKeyboardTypeEmailAddress;
    
    _username.borderStyle = UITextBorderStyleRoundedRect;
    _password.borderStyle = UITextBorderStyleRoundedRect;
    
    _username.placeholder = @"E-Mail";
    _password.placeholder = @"Passwort";
    
    _password.secureTextEntry = YES;
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginButton.frame = CGRectMake((width-20)/2-50, 150, 100, 30);
    _loginButton.layer.cornerRadius = 15.0;
    _loginButton.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _cancelButton.frame = CGRectMake(width-50, 10, 20, 20);
    
    [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    //[_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"close_icon@3x.png"] forState:UIControlStateNormal];
    
    [_loginButton addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    
    [_username setAlpha:0.0f];
    [_password setAlpha:0.0f];
    [_loginButton setAlpha:0.0f];
    [_cancelButton setAlpha:0.0f];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setCenter:CGPointMake((width-20)/2, 160)];
    [_activityIndicator setHidden:YES];
    
    [_loginView addSubview:_username];
    [_loginView addSubview:_password];
    [_loginView addSubview:_loginButton];
    [_loginView addSubview:_cancelButton];
    [_loginView addSubview:_activityIndicator];
    
    [_blurEffectView addSubview:_loginView];
    
    [_username release];
    [_password release];
    [_loginButton release];
    [_cancelButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_loginView release];
    [_username release];
    [_password release];
    [_loginButton release];
    [_cancelButton release];
    [super dealloc];
}

- (void)Login {
    [_loginButton setHidden:YES];
    
    [_activityIndicator setHidden:NO];
    
    [_activityIndicator startAnimating];
    
    [self ValidateLogin];
}

- (void)Cancel {
    [self HideView];
}

- (void) animate
{
    [self ShowView];
}

- (void) ShowView
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    double yOffset;
    
    if (height == 480) {yOffset = 50;}
    else {yOffset = 80;}
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        //self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
        _loginView.frame = CGRectMake(10, 50, width-20, 200);
        
        [_blurEffectView setHidden:NO];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_loginView.frame = CGRectMake(10, 45, width-20, 200);} completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
                _loginView.frame = CGRectMake(10, 50, width-20, 200);
                
                [_username setAlpha:1.0f];
                [_password setAlpha:1.0f];
                [_loginButton setAlpha:1.0f];
                [_cancelButton setAlpha:1.0f];
            } completion:NULL
             ];
        }];
    }];
}

- (void) ValidateLogin
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/validate_login.php?uid=%s&pwd=%s", [_username.text UTF8String], [_password.text UTF8String]];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfiguration.timeoutIntervalForRequest = 10.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData* responseData, NSURLResponse *responseURL, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message: @"Da ist etwas schief gelaufen. Stelle sicher, dass du Verbindung zum Internet hast." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [_activityIndicator stopAnimating];
            
            [_activityIndicator setHidden:YES];
            
            [_loginButton setHidden:NO];
            
            return;
        }
        
        NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if ([response isEqualToString:@"false"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message: @"Die Login-Informationen sind falsch." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            data.loggedIn = false;
            
            [_activityIndicator stopAnimating];
            
            [_activityIndicator setHidden:YES];
            
            [_loginButton setHidden:NO];
        }
        else {
            data.loggedIn = true;
            data.userID = response;
            
            [self DownloadProfilePicture];
        }
    }];
    
    [sessionTask resume];
    
    return;
}

- (void) DownloadProfilePicture
{
    NSString *requestString = [NSString stringWithFormat:@"http://www.xtour.ch/users/%@/profile.png",data.userID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfiguration.timeoutIntervalForRequest = 10.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask *sessionTask = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            [_activityIndicator stopAnimating];
            
            [_activityIndicator setHidden:YES];
            
            [_loginButton setHidden:NO];
            
            data.loggedIn = false;
            return;
        }
        
        NSData *profilePicture = [NSData dataWithContentsOfURL:location];
        
        NSString *filePath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        
        [profilePicture writeToFile:filePath atomically:YES];
        
        [self DownloadUserInfo];
        
    }];
    
    [sessionTask resume];
}

- (void) DownloadUserInfo
{
    NSString *requestString = [NSString stringWithFormat:@"http://www.xtour.ch/users/%@/UserInfo.xml",data.userID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfiguration.timeoutIntervalForRequest = 10.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error) {
        if (error) {
            [_activityIndicator stopAnimating];
            
            [_activityIndicator setHidden:YES];
            
            [_loginButton setHidden:NO];
            
            data.loggedIn = false;
            return;
        }
        
        NSString *filePath = [data GetDocumentFilePathForFile:@"/UserInfo.xml" CheckIfExist:NO];
        
        [responseData writeToFile:filePath atomically:YES];
        
        [data CheckLogin];
        
        [self HideView];
    }];
    
    [sessionTask resume];
}

- (void) HideView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginViewDismissed" object:nil userInfo:nil];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _loginView.frame = CGRectMake(10, -200, self.view.frame.size.width-20, 200);
        
        [_username setAlpha:0.0f];
        [_password setAlpha:0.0f];
        [_loginButton setAlpha:0.0f];
        [_cancelButton setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

@end

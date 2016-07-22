//
//  XTNavigationViewContainer.m
//  XTour
//
//  Created by Manuel Weber on 28/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTNavigationViewContainer.h"

@interface XTNavigationViewContainer ()

@end

@implementation XTNavigationViewContainer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil view:(UIView*)navigationView title:(NSString*)navigationTitle isFirstView:(bool)firstView
{
    if ([self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        data = [XTDataSingleton singleObj];
        
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        _width = screenBound.size.width;
        _height = screenBound.size.height;
        
        UITabBarController *tabBarController = [super tabBarController];
        _tabBarHeight = tabBarController.tabBar.frame.size.height;
        
        self.view.frame = CGRectMake(0, 0, _width, _height);
        
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, 69)];
        
        _header_shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 69, _width, 1)];
        
        _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
        _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
        
        _header_background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, 70)];
        
        _header_background.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _loginButton.frame = CGRectMake(_width-50, 25, 40, 40);
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 30, 30, 30)];
        [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:[UIImage imageNamed:@"arrow_back@3x.png"] forState:UIControlStateNormal];
        [_backButton setAlpha:0.0];
        //[_backButton setHidden:YES];
        
        _navigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, _width-100, 30)];
        _navigationTitle.textColor = [UIColor whiteColor];
        _navigationTitle.font = [UIFont fontWithName:@"Helvetica-BoldMT" size:14.0f];
        _navigationTitle.textAlignment = NSTextAlignmentCenter;
        [_navigationTitle setAlpha:0.0];
        //[_navigationTitle setHidden:YES];
        
        _navigationTitle.text = navigationTitle;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(_width, 0, _width, _height-_tabBarHeight)];
        
        [_contentView addSubview:navigationView];
        
        [_header addSubview:_loginButton];
        
        [self.view addSubview:_contentView];
        [self.view addSubview:_header_background];
        [self.view addSubview:_header];
        [self.view addSubview:_header_shadow];
        
        if (firstView) {
            [self.view addSubview:_backButton];
            [self.view addSubview:_navigationTitle];
        }
        else {
            [[[UIApplication sharedApplication] keyWindow] addSubview:_backButton];
            [[[UIApplication sharedApplication] keyWindow] addSubview:_navigationTitle];
        }
        
        [self LoginViewDidClose:nil];
        
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(HandlePanGesture:)];
        recognizer.delegate = self;
        
        [_contentView addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*data = [XTDataSingleton singleObj];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    _width = screenBound.size.width;
    _height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    _tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, 69)];
    
    _header_shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 69, _width, 1)];
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _header_background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, 70)];
    
    _header_background.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _loginButton.frame = CGRectMake(_width-50, 25, 40, 40);
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 30, 30, 30)];
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImage:[UIImage imageNamed:@"arrow_back@3x.png"] forState:UIControlStateNormal];
    [_backButton setHidden:YES];
    
    _navigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, _width-100, 30)];
    _navigationTitle.textColor = [UIColor whiteColor];
    _navigationTitle.font = [UIFont fontWithName:@"Helvetica-BoldMT" size:14.0f];
    _navigationTitle.textAlignment = NSTextAlignmentCenter;
    [_navigationTitle setHidden:YES];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(_width, 0, _width, _height-_tabBarHeight)];
    
    [_header addSubview:_loginButton];
    
    [self.view addSubview:_contentView];
    [self.view addSubview:_header_background];
    [self.view addSubview:_header];
    [self.view addSubview:_header_shadow];
    [self.view addSubview:_backButton];
    [self.view addSubview:_navigationTitle];
    
    [self LoginViewDidClose:nil];*/
    
    //[[[UIApplication sharedApplication] keyWindow] addSubview:_backButton];
    //[[[UIApplication sharedApplication] keyWindow] addSubview:_navigationTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LoadLogin:(id)sender {
    if (login) {[login.view removeFromSuperview];}
    
    login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginViewDidClose:) name:@"LoginViewDismissed" object:nil];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:login.view];
    [login animate];
}

- (void)ShowLoginOptions:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Du bist eingelogged als %@",data.userInfo.userName] delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:@"Ausloggen" otherButtonTitles:@"Profil anzeigen", nil];
    
    [actionSheet showInView:self.view];
}

- (void) LoginViewDidClose:(id)sender
{
    [_loginButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(ShowLoginOptions:) forControlEvents:UIControlEventTouchUpInside];
        
        [img release];
    }
    else {
        [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(LoadLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Ausloggen"]) {
        [data Logout];
        
        [self LoginViewDidClose:nil];
    }
}

- (void) ShowView
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        if (_header_background.frame.size.width < _width) {_header_background.frame = CGRectMake(0, 0, 0, 70);}
        _contentView.frame = CGRectMake(0, 0, _width, _height-_tabBarHeight);
        [_backButton setAlpha:1.0];
        [_navigationTitle setAlpha:1.0];
    } completion:^(BOOL finished) {
        [_header_background setHidden:YES];
    }];
}

- (void) HideView
{
    [_header_background setHidden:NO];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        if (_header_background.frame.size.width < _width) {_header_background.frame = CGRectMake(0, 0, _width, 70);}
        _contentView.frame = CGRectMake(_width, 0, _width, _height-_tabBarHeight);
        [_backButton setAlpha:0.0];
        [_navigationTitle setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void) back:(id)sender
{
    [self HideView];
}

- (void) ClearContentView
{
    [[_contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (IBAction) HandlePanGesture:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    
    CGRect currentPosition = _contentView.frame;
    
    if (translation.x > 0) {
        _contentView.frame = CGRectMake(translation.x, currentPosition.origin.y, currentPosition.size.width, currentPosition.size.height);
        
        [_header_background setHidden:NO];
        _header_background.frame = CGRectMake(0, 0, translation.x, 70);
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [recognizer locationInView:self.view];
        
        if (location.x < _width/2 || translation.x <= 0) {
            [self ShowView];
        }
        else {
            [self HideView];
        }
    }
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

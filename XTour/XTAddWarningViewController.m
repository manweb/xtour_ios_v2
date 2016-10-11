//
//  XTAddWarningViewController.m
//  XTour
//
//  Created by Manuel Weber on 13/01/16.
//  Copyright © 2016 Manuel Weber. All rights reserved.
//

#import "XTAddWarningViewController.h"

@interface XTAddWarningViewController ()

@end

@implementation XTAddWarningViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil warningInfo:(XTWarningsInfo *)warningInfo
{
    _warning = warningInfo;
    
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data = [XTDataSingleton singleObj];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    self.view.frame = CGRectMake(0, 0, width, height+tabBarHeight);
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height+tabBarHeight)];
    
    _backgroundView.backgroundColor = [UIColor blackColor];
    [_backgroundView setAlpha:0.0f];
    
    [self.view addSubview:_backgroundView];
    
    /*UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurEffectView.frame = self.view.frame;
    _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [_blurEffectView setHidden:YES];
    
    [self.view addSubview:_blurEffectView];*/
    
    _addWarningView = [[UIView alloc] initWithFrame:CGRectMake(10, -200, width-20, 250)];
    _addWarningView.layer.cornerRadius = 10.0f;
    _addWarningView.layer.borderWidth = 5.0f;
    _addWarningView.layer.borderColor = [UIColor grayColor].CGColor;
    _addWarningView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2-100, 10, 200, 20)];
    
    _titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    _titleLabel.text = @"Was hat du beobachtet?";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _warningComment = [[UITextView alloc] initWithFrame:CGRectMake(20, 90, width-60, 110)];
    [_warningComment setAlpha:0.0f];
    
    _warningComment.layer.borderWidth = 1.0f;
    _warningComment.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _warningComment.font = [UIFont fontWithName:@"Helvetica" size:16];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginButton.frame = CGRectMake((width-20)/2-50, 210, 100, 30);
    _loginButton.layer.cornerRadius = 15.0;
    _loginButton.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _cancelButton.frame = CGRectMake(width-50, 10, 20, 20);
    
    [_loginButton setTitle:@"Eintragen" forState:UIControlStateNormal];
    //[_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"close_icon@3x.png"] forState:UIControlStateNormal];
    
    [_loginButton addTarget:self action:@selector(Enter) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 15, width-60, 80)];
    
    _pickerView.delegate = self;
    
    _warning1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _warning2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _warning3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _warning4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _warning5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    float spaceBetweenIcons = (width-80)/4;
    
    _warning1.frame = CGRectMake(10, 40, 40, 40);
    _warning2.frame = CGRectMake(10+spaceBetweenIcons, 40, 40, 40);
    _warning3.frame = CGRectMake(10+2*spaceBetweenIcons, 40, 40, 40);
    _warning4.frame = CGRectMake(10+3*spaceBetweenIcons, 40, 40, 40);
    _warning5.frame = CGRectMake(10+4*spaceBetweenIcons, 40, 40, 40);
    
    [_warning1 setBackgroundImage:[UIImage imageNamed:@"warning_icon_avelange@3x.png"] forState:UIControlStateNormal];
    [_warning2 setBackgroundImage:[UIImage imageNamed:@"warning_icon_unstable@3x.png"] forState:UIControlStateNormal];
    [_warning3 setBackgroundImage:[UIImage imageNamed:@"warning_icon_crack@3x.png"] forState:UIControlStateNormal];
    [_warning4 setBackgroundImage:[UIImage imageNamed:@"warning_icon_falling_rocks@3x.png"] forState:UIControlStateNormal];
    [_warning5 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    _warning1.tag = 1;
    _warning2.tag = 2;
    _warning3.tag = 3;
    _warning4.tag = 4;
    _warning5.tag = 5;
    
    [_warning1 addTarget:self action:@selector(SelectWarning:) forControlEvents:UIControlEventTouchUpInside];
    [_warning2 addTarget:self action:@selector(SelectWarning:) forControlEvents:UIControlEventTouchUpInside];
    [_warning3 addTarget:self action:@selector(SelectWarning:) forControlEvents:UIControlEventTouchUpInside];
    [_warning4 addTarget:self action:@selector(SelectWarning:) forControlEvents:UIControlEventTouchUpInside];
    [_warning5 addTarget:self action:@selector(SelectWarning:) forControlEvents:UIControlEventTouchUpInside];
    
    _selectedWarning = [[UIView alloc] initWithFrame:CGRectMake(8, 38, 44, 44)];
    
    _selectedWarning.backgroundColor = [UIColor clearColor];
    _selectedWarning.layer.borderWidth = 2.0f;
    _selectedWarning.layer.borderColor = [[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:1.0] CGColor];
    _selectedWarning.layer.cornerRadius = 5.0f;
    [_selectedWarning setHidden:YES];
    
    //[_addWarningView addSubview:_pickerView];
    [_addWarningView addSubview:_warning1];
    [_addWarningView addSubview:_warning2];
    [_addWarningView addSubview:_warning3];
    [_addWarningView addSubview:_warning4];
    [_addWarningView addSubview:_warning5];
    [_addWarningView addSubview:_selectedWarning];
    [_addWarningView addSubview:_titleLabel];
    [_addWarningView addSubview:_loginButton];
    [_addWarningView addSubview:_cancelButton];
    [_addWarningView addSubview:_warningComment];
    
    [self.view addSubview:_addWarningView];
    
    _categories = [[NSMutableArray alloc] initWithObjects:@"Lawinenabgang",@"Instabile Unterlage",@"Spalten",@"Steinschlag",@"Sonst etwas", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_categories count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_categories objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _warning.category = row;
}

- (void) Enter
{
    _warning.comment = self.warningComment.text;
    
    [data AddWarningInfo:_warning];
    
    if (!request) {request = [[XTServerRequestHandler alloc] init];}
    
    [request SubmitWarningInfo:_warning];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddWarningViewDismissed" object:nil userInfo:nil];
    
    [self HideView];
}

- (void)Cancel {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddWarningViewDismissedCancel" object:nil userInfo:nil];
    
    [self HideView];
}

- (void) SelectWarning:(id)sender
{
    UIButton *button = sender;
    
    long selectedWarning = button.tag - 1;
    
    _warning.category = selectedWarning;
    
    _titleLabel.text = [_categories objectAtIndex:selectedWarning];
    
    if (_selectedWarning.hidden) {
        _selectedWarning.frame = CGRectMake(button.frame.origin.x - 2, _selectedWarning.frame.origin.y, _selectedWarning.frame.size.width, _selectedWarning.frame.size.height);
        
        [_selectedWarning setHidden:NO];
    }
    else {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
            _selectedWarning.frame = CGRectMake(button.frame.origin.x - 2, _selectedWarning.frame.origin.y, _selectedWarning.frame.size.width, _selectedWarning.frame.size.height);
        } completion:NULL];
    }
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
    
    if (height == 480) {yOffset = 40;}
    else {yOffset = 80;}
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        //self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
        _addWarningView.frame = CGRectMake(10, 50, width-20, 250);
        
        //[_blurEffectView setHidden:NO];
        [_backgroundView setAlpha:0.4f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_addWarningView.frame = CGRectMake(10, 45, width-20, 250);} completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
                _addWarningView.frame = CGRectMake(10, 50, width-20, 250);
                
                [_warningComment setAlpha:1.0f];
                [_loginButton setAlpha:1.0f];
                [_cancelButton setAlpha:1.0f];
            } completion:NULL
             ];
        }];
    }];
}

- (void) HideView
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _addWarningView.frame = CGRectMake(10, -200, self.view.frame.size.width-20, 250);
        
        [_warningComment setAlpha:0.0f];
        [_loginButton setAlpha:0.0f];
        [_cancelButton setAlpha:0.0f];
        [_backgroundView setAlpha:0.0f];
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

//
//  XTWarnigsViewController.m
//  XTour
//
//  Created by Manuel Weber on 22/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTWarnigsViewController.h"

@interface XTWarnigsViewController ()

@end

@implementation XTWarnigsViewController

static NSString * const reuseIdentifier = @"Cell";

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
	// Do any additional setup after loading the view.
    
    // Register cell classes
    [self.collectionView registerClass:[XTWarningCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(70, 0, 0, 0)];
    
    // Do any additional setup after loading the view.
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float width = screenBounds.size.width;
    float height = screenBounds.size.height;
    
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 69)];
    _header_shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 69, width, 1)];
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(width-50, 25, 40, 40)];
    [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(LoadLogin:) forControlEvents:UIControlEventTouchDown];
    
    [_header addSubview:_loginButton];
    
    [self.view addSubview:_header];
    [self.view addSubview:_header_shadow];
    
    _warningsArray = [[NSMutableArray alloc] init];
    [_warningsArray removeAllObjects];
    
    data = [XTDataSingleton singleObj];
    
    _categories = [[NSMutableArray alloc] initWithObjects:@"Lawinenabgang",@"Instabile Unterlage",@"Spalten",@"Steinschlag",@"Sonst etwas", nil];
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height/2-20, width, 40)];
    
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    emptyLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"Keine Internetverbindung";
    
    _noConnectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    UIImageView *noConnectionImage = [[UIImageView alloc] initWithFrame:CGRectMake((width-100)/2, height/2+20, 100, 40)];
    
    [noConnectionImage setImage:[UIImage imageNamed:@"NoConnection@3x.png"]];
    
    [_noConnectionView addSubview:emptyLabel];
    [_noConnectionView addSubview:noConnectionImage];
    
    [emptyLabel release];
    [noConnectionImage release];
    
    _noWarningsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    _messageLbl = [[UITextView alloc] initWithFrame:CGRectMake(10,self.view.bounds.size.height/2-50,self.view.bounds.size.width-20,100)];
    
    _messageLbl.backgroundColor = [UIColor clearColor];
    _messageLbl.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    _messageLbl.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _messageLbl.text = [NSString stringWithFormat:@"Im Umkreis von %.0fkm sind keine Gefahrenstellen markiert.\n\nHerunterziehen um zu aktualisieren",data.profileSettings.warningRadius];
    _messageLbl.textAlignment = NSTextAlignmentCenter;
    [_messageLbl setEditable:NO];
    [_messageLbl setScrollEnabled:NO];
    
    [_noWarningsView addSubview:_messageLbl];
    
    if (refreshControl == nil) {
        refreshControl = [[UIRefreshControl alloc] init];
    }
    [refreshControl addTarget:self action:@selector(UpdateWarnings:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    [refreshControl beginRefreshing];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self UpdateWarnings:nil];
    [self LoginViewDidClose:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_warningsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XTWarningCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    XTWarningsInfo *currentWarning = [_warningsArray objectAtIndex:indexPath.row];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[currentWarning.submitDate integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *formattedDate = [formatter stringFromDate:date];
    
    if ([[_categories objectAtIndex:currentWarning.category] isEqualToString:@"Sonst etwas"]) {cell.warningTitle.text = @"Gefahrenstelle";}
    else {cell.warningTitle.text = [_categories objectAtIndex:currentWarning.category];}
    cell.warningDescription.text = [NSString stringWithFormat:@"Eingetragen von %@ am %@. Distanz zur Gefahrenstelle: %.1f km",currentWarning.userName,formattedDate,currentWarning.distance];
    
    [formatter release];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    CGRect cellFrame = cell.frame;
    
    XTWarningsInfo *currentWarning = [_warningsArray objectAtIndex:indexPath.row];
    
    warningDetailView = [[XTWarningDetailView alloc] init];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:warningDetailView.view];
    
    [warningDetailView LoadInfo:currentWarning withFrame:cellFrame];
    
    [warningDetailView Animate];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    
    float boxWidth = width - 20;
    
    return CGSizeMake(boxWidth, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (void)dealloc {
    [_header release];
    [_header_shadow release];
    [_loginButton release];
    [_warningsArray release];
    [super dealloc];
}

- (void)LoadLogin:(id)sender {
    if (login) {[login.view removeFromSuperview];}
    
    login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginViewDidClose:) name:@"LoginViewDismissed" object:nil];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:login.view];
    [login animate];
}

- (void)ShowLoginOptions:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginViewDidClose:) name:@"LoginViewDismissed" object:nil];
    
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
    
    if ([buttonTitle isEqualToString:@"Ausloggen"]) {[data Logout];}
    else if ([buttonTitle isEqualToString:@"Profil anzeigen"]) {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        float width = screenBound.size.width;
        float height = screenBound.size.height;
        
        XTProfileViewController *profile = [[XTProfileViewController alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        
        [profile initialize];
        
        XTNavigationViewContainer *navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:profile title:data.userInfo.userName isFirstView:YES];
        
        [self.view addSubview:navigationView.view];
        
        [navigationView ShowView];
        
        [profile release];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginViewDismissed" object:nil userInfo:nil];
}

- (void) UpdateWarnings:(id)sender
{
    if (!data.CurrentLocation) {return;}
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_warnings_string.php?radius=%f&longitude=%f&latitude=%f", data.profileSettings.warningRadius, data.CurrentLocation.coordinate.longitude, data.CurrentLocation.coordinate.latitude];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfiguration.timeoutIntervalForRequest = 10.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
        if (error) {
            self.collectionView.backgroundView = _noConnectionView;
            
            [refreshControl endRefreshing];
            
            return;
        }
        
        XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
        
        self.warningsArray = [request GetWarningsWithinRadius:responseData];
        
        if ([_warningsArray count] > 0) {
            [self tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[_warningsArray count]];
            
            self.collectionView.backgroundView = nil;
        }
        else {
            [self tabBarItem].badgeValue = nil;
            
            _messageLbl.text = [NSString stringWithFormat:@"Im Umkreis von %.0fkm sind keine Gefahrenstellen markiert.\n\nHerunterziehen um zu aktualisieren",data.profileSettings.warningRadius];
            
            self.collectionView.backgroundView = _noWarningsView;
        }
        
        [self.collectionView reloadData];
        
        [refreshControl endRefreshing];
    }];
    
    [sessionTask resume];
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.warningsArray = [request GetWarningsWithinRadius:20 atLongitude:data.CurrentLocation.coordinate.longitude andLatitude:data.CurrentLocation.coordinate.latitude];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_warningsArray count] > 0) {
                [_background setHidden:YES];
                [self.collectionView setHidden:NO];
                [self.collectionView reloadData];
                
                [self tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", [_warningsArray count]];
            }
            else {
                [_background setHidden:NO];
                [self.collectionView setHidden:YES];
                
                [self tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", 0];
            }
            
            [refreshControl endRefreshing];
        });
    });*/
}

@end

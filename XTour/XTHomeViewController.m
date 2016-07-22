//
//  XTFirstViewController.m
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTHomeViewController.h"

@interface XTHomeViewController ()

@end

@implementation XTHomeViewController

+ (CLLocationManager *)sharedLocationManager {
    static CLLocationManager *_locationManager;
    
    @synchronized(self) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        }
    }
    return _locationManager;
}

- (void) pollTime
{
    data.timer++;
    data.totalTime++;
    data.rateTimer++;
    int tm = (int)data.timer;
    NSString *currentTimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                                   lround(floor(tm / 3600.)) % 100,
                                   lround(floor(tm / 60.)) % 60,
                                   lround(floor(tm)) % 60];
    _timerLabel.text = currentTimeString;
    
    int tm_total = (int)data.totalTime;
    NSString *currentTotalTimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                                   lround(floor(tm_total / 3600.)) % 100,
                                   lround(floor(tm_total / 60.)) % 60,
                                   lround(floor(tm_total)) % 60];
    _totalTimeLabel.text = currentTotalTimeString;
    
    if (data.timer - _recoveryTimer > 120 && _writeRecoveryFile) {
        NSLog(@"Writing recovery file");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [data WriteRecoveryFile];
            _recoveryTimer = data.timer;
        });
    }
}

- (void) startLocationUpdate
{
    NSLog(@"Starting location service");
    
    if (_locationStartTimer) {
        [_locationStartTimer invalidate];
        _locationStartTimer = nil;
    }
    
    //Create location manager
    CLLocationManager *locationManager = [XTHomeViewController sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10;
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager setAllowsBackgroundLocationUpdates:YES];
    
    [locationManager startUpdatingLocation];
}

- (void) stopLocationUpdate:(bool)saveLocation
{
    NSLog(@"Stopping location service");
    
    if (_locationStopTimer) {
        [_locationStopTimer invalidate];
        _locationStopTimer = nil;
    }
    
    //Create location manager
    CLLocationManager *locationManager = [XTHomeViewController sharedLocationManager];
    
    [locationManager stopUpdatingLocation];
    
    if (!saveLocation) {return;}
    
    [self UpdateDisplayWithLocation:_bestLocation];
    
    if (_oldAccuracy < 300) {[self SaveCurrentLocation:_bestLocation];}
    
    _oldAccuracy = 10000.0;
}

- (void) stopLocationUpdate
{
    [self stopLocationUpdate:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    _width = screenBound.size.width;
    _height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    double dy = 10;
    double yOffset = 10;
    double _timerSectionHeight = 80.0;
    double _sectionHeight = 60.0;
    double iconScale = 1.0;
    
    // iPhone 4
    if (_height == 480) {
        dy = 3;
        yOffset = 73;
        _timerSectionHeight = 80.0;
        _sectionHeight = 60.0;
        iconScale = 1.0;
    }
    
    // iPhone 5
    if (_height == 568) {
        dy = 20;
        yOffset = 80;
        _timerSectionHeight = 80.0;
        _sectionHeight = 60.0;
        iconScale = 1.0;
    }
    
    // iPhone 6
    if (_height == 667) {
        dy = 20;
        yOffset = 80;
        _timerSectionHeight = 100.0;
        _sectionHeight = 80.0;
        iconScale = 1.2;
    }
    
    // iPhone 6 Plus
    if (_height == 736) {
        dy = 20;
        yOffset = 80;
        _timerSectionHeight = 80.0;
        _sectionHeight = 60.0;
        iconScale = 1.0;
    }
    
    /*_header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _header.frame = CGRectMake(0, 0, width, 69);
    _header_shadow.frame = CGRectMake(0, 69, width, 1);
    
    _loginButton.frame = CGRectMake(width-50, 25, 40, 40);
    
    _timerSection.frame = CGRectMake(10, yOffset, width-20, _timerSectionHeight);
    
    yOffset += _timerSectionHeight + dy;
    
    _distanceSection.frame = CGRectMake(10, yOffset, width-20, _sectionHeight);
    
    yOffset += _sectionHeight + dy;
    
    _altitudeSection.frame = CGRectMake(10, yOffset, width-20, _sectionHeight);
    
    yOffset += _sectionHeight + dy;
    
    _locationSection.frame = CGRectMake(10, yOffset, width-20, _sectionHeight);
    
    yOffset += _sectionHeight + dy;
    
    _StartButton.frame = CGRectMake(20, yOffset, iconScale*80, iconScale*80);
    _PauseButton.frame = CGRectMake(width/2-iconScale*20, yOffset+iconScale*20, iconScale*40, iconScale*40);
    _StopButton.frame = CGRectMake(width-iconScale*100, yOffset, iconScale*80, iconScale*80);
    
    _timerIcon.frame = CGRectMake(5, (_timerSectionHeight-iconScale*60)/2, iconScale*60, iconScale*60);
    _distanceIcon.frame = CGRectMake(10, (_sectionHeight-iconScale*40)/2, iconScale*40, iconScale*40);
    _altitudeIcon.frame = CGRectMake(10, (_sectionHeight-iconScale*40)/2, iconScale*40, iconScale*40);
    _locationIcon.frame = CGRectMake(10, (_sectionHeight-iconScale*40)/2, iconScale*40, iconScale*40);
    
    _distanceSectionSeparator.frame = CGRectMake((width-20)/2, 5, 2, _sectionHeight-10);
    _altitudeSectionSeparator.frame = CGRectMake((width-20)/2, 5, 2, _sectionHeight-10);
    
    _timerSection.layer.cornerRadius = 12.0f;
    _distanceSection.layer.cornerRadius = 12.0f;
    _altitudeSection.layer.cornerRadius = 12.0f;
    _locationSection.layer.cornerRadius = 12.0f;
    
    UIColor *boxBorderColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    _timerSection.layer.borderWidth = 1.0f;
    _distanceSection.layer.borderWidth = 1.0f;
    _altitudeSection.layer.borderWidth = 1.0f;
    _locationSection.layer.borderWidth = 1.0f;
    
    _timerSection.layer.borderColor = boxBorderColor.CGColor;
    _distanceSection.layer.borderColor = boxBorderColor.CGColor;
    _altitudeSection.layer.borderColor = boxBorderColor.CGColor;
    _locationSection.layer.borderColor = boxBorderColor.CGColor;
    
    _timerLabel.frame = CGRectMake(iconScale*85, _timerSectionHeight/2-iconScale*30, width-25-iconScale*85, iconScale*60);
    _timerLabel.font = [UIFont fontWithName:@"Helvetica" size:35*iconScale];
    
    _distanceLabel.frame = CGRectMake(iconScale*65, _sectionHeight/2-iconScale*10, width/2-70, iconScale*20);
    _distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _distanceRateLabel.frame = CGRectMake(width/2+iconScale*10, _sectionHeight/2-iconScale*10, width/2-15-iconScale*10, iconScale*20);
    _distanceRateLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _altitudeLabel.frame = CGRectMake(iconScale*65, _sectionHeight/2-iconScale*10, width/2-70, iconScale*20);
    _altitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _altitudeRateLabel.frame = CGRectMake(width/2+iconScale*10, _sectionHeight/2-iconScale*10, width/2-15-iconScale*10, iconScale*20);
    _altitudeRateLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _longLabel.frame = CGRectMake(iconScale*65-10, _sectionHeight/2-iconScale*15-5, width/2-iconScale*65+25, iconScale*15);
    _longLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _latLabel.frame = CGRectMake(iconScale*65-10, _sectionHeight/2+5, width/2-iconScale*65+25, iconScale*15);
    _latLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _elevationLabel.frame = CGRectMake(width/2, _sectionHeight/2-iconScale*10, width/2-35, iconScale*20);
    _elevationLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _totalTimeLabel.frame = CGRectMake(width-30-width/3, _timerSectionHeight-iconScale*20, width/3, iconScale*20);
    _totalTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:12*iconScale];
    
    _totalDistanceLabel.frame = CGRectMake(width/4, _sectionHeight-iconScale*20, width/2-20-width/4, iconScale*20);
    _totalDistanceLabel.font = [UIFont fontWithName:@"Helvetica" size:12*iconScale];
    
    _totalAltitudeLabel.frame = CGRectMake(width/4, _sectionHeight-iconScale*20, width/2-20-width/4, iconScale*20);
    _totalAltitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:12*iconScale];
    
    _altitudeRateIcon.frame = CGRectMake(width-60, _sectionHeight/2-15*iconScale, 30*iconScale, 30*iconScale);*/
    
    double zoom = 10.0;
    if (data.runStatus != 0) {zoom = 15.0;}
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.770809 longitude:8.377733 zoom:zoom];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, 320, 360) camera:camera];
    
    _mapView.mapType = kGMSTypeTerrain;
    
    [self.view insertSubview:_mapView atIndex:0];
    [_mapView setDelegate:self];
    
    _path = [[GMSMutablePath alloc] init];
    _polyline = [[GMSPolyline alloc] init];
    
    [_polyline setPath:_path];
    _polyline.strokeColor = [UIColor blueColor];
    _polyline.strokeWidth = 5.f;
    _polyline.map = _mapView;
    
    _polylines = [[NSMutableArray alloc] init];
    
    _savedPolylines = [[NSMutableArray alloc] init];
    
    _mapHasMoved = false;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *centerBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    centerBlurView.frame = CGRectMake(0, 0, 120, 30);
    centerBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    centerBlurView.layer.cornerRadius = 5.0f;
    centerBlurView.clipsToBounds = YES;
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(_width/2-60, _height-tabBarHeight-40, 120, 30)];
    
    _centerView.backgroundColor = [UIColor clearColor];
    _centerView.layer.cornerRadius = 5.0f;
    
    _centerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _centerButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    _centerButton.backgroundColor = [UIColor clearColor];
    _centerButton.layer.cornerRadius = 5.0f;
    _centerButton.frame = CGRectMake(0, 0, 120, 30);
    [_centerButton setTitle:@"Karte zentrieren" forState:UIControlStateNormal];
    [_centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(centerMap:) forControlEvents:UIControlEventTouchUpInside];
    
    [_centerView addSubview:centerBlurView];
    [_centerView addSubview:_centerButton];
    
    [_centerView setHidden:YES];
    
    [centerBlurView release];
    
    [self.view addSubview:_centerView];
    
    UIVisualEffectView *addWarningBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    addWarningBlurView.frame = CGRectMake(0, 0, 40, 40);
    addWarningBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    addWarningBlurView.layer.cornerRadius = 20.0f;
    addWarningBlurView.clipsToBounds = YES;
    
    _addWarningBackground = [[UIView alloc] initWithFrame:CGRectMake(_width-50, 80, 40, 40)];
    
    _addWarningBackground.backgroundColor = [UIColor clearColor];
    _addWarningBackground.layer.cornerRadius = 20.0f;
    
    _addWarningButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    
    [_addWarningButton setImage:[UIImage imageNamed:@"add_warning_icon@3x.png"] forState:UIControlStateNormal];
    [_addWarningButton addTarget:self action:@selector(AddWarning:) forControlEvents:UIControlEventTouchUpInside];
    
    _addWarningText = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 250, 30)];
    
    _addWarningText.text = @"Klicke auf die Karte für midestens 2s um eine Gefahrenstelle zu markieren.";
    _addWarningText.textColor = [UIColor whiteColor];
    _addWarningText.font = [UIFont fontWithName:@"Helvetica" size:12];
    _addWarningText.contentInset = UIEdgeInsetsMake(-8, 0, 0, 0);
    _addWarningText.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    [_addWarningText setHidden:YES];
    
    [_addWarningBackground addSubview:addWarningBlurView];
    [_addWarningBackground addSubview:_addWarningButton];
    [_addWarningBackground addSubview:_addWarningText];
    [self.view addSubview:_addWarningBackground];
    
    [addWarningBlurView release];
    
    UIVisualEffectView *changeMapBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    changeMapBlurView.frame = CGRectMake(0, 0, 40, 40);
    changeMapBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    changeMapBlurView.layer.cornerRadius = 20.0f;
    changeMapBlurView.clipsToBounds = YES;
    
    _changeMapBackground = [[UIView alloc] initWithFrame:CGRectMake(_width-50, 130, 40, 40)];
    
    _changeMapBackground.backgroundColor = [UIColor clearColor];
    _changeMapBackground.layer.cornerRadius = 20.0f;
    
    _changeMap = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _changeMap.frame = CGRectMake(5, 5, 30, 30);
    [_changeMap setBackgroundImage:[UIImage imageNamed:@"map_type_satellite@3x.png"] forState:UIControlStateNormal];
    [_changeMap addTarget:self action:@selector(ChangeMapType:) forControlEvents:UIControlEventTouchUpInside];
    
    [_changeMapBackground addSubview:changeMapBlurView];
    [_changeMapBackground addSubview:_changeMap];
    [self.view addSubview:_changeMapBackground];
    
    [changeMapBlurView release];
    
    UIVisualEffectView *addPictureBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    addPictureBlurView.frame = CGRectMake(0, 0, 40, 40);
    addPictureBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    addPictureBlurView.layer.cornerRadius = 20.0f;
    addPictureBlurView.clipsToBounds = YES;
    
    _addPictureBackground = [[UIView alloc] initWithFrame:CGRectMake(_width-50, 180, 40, 40)];
    
    _addPictureBackground.backgroundColor = [UIColor clearColor];
    _addPictureBackground.layer.cornerRadius = 20.0f;
    
    _addPictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _addPictureButton.frame = CGRectMake(5, 5, 30, 30);
    [_addPictureButton setBackgroundImage:[UIImage imageNamed:@"camera_icon_white@3x.png"] forState:UIControlStateNormal];
    [_addPictureButton addTarget:self action:@selector(LoadCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    [_addPictureBackground addSubview:addPictureBlurView];
    [_addPictureBackground addSubview:_addPictureButton];
    [self.view addSubview:_addPictureBackground];
    
    [addPictureBlurView release];
    
    UIVisualEffectView *followTourBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    followTourBlurView.frame = CGRectMake(0, 0, _width-20, 52);
    followTourBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    followTourBlurView.layer.cornerRadius = 5.0f;
    followTourBlurView.clipsToBounds = YES;
    
    _followTourView = [[UIView alloc] initWithFrame:CGRectMake(10, 75, _width-20, 52)];
    
    _followTourView.backgroundColor = [UIColor clearColor];
    _followTourView.layer.cornerRadius = 5.0f;
    
    _followTourTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, _width-80, 16)];
    
    _followTourTitle.textColor = [UIColor whiteColor];
    _followTourTitle.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _followTourTitle.text = @"Hinzugefügte Tour";
    
    float labelWidth = (_width-70)/3;
    
    _followTourTime = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, labelWidth-5, 16)];
    
    _followTourTime.textColor = [UIColor whiteColor];
    _followTourTime.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    
    _followTourDistance = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth+5, 20, labelWidth-5, 16)];
    
    _followTourDistance.textColor = [UIColor whiteColor];
    _followTourDistance.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    
    _followTourAltitude = [[UILabel alloc] initWithFrame:CGRectMake(2*labelWidth+5, 20, labelWidth, 16)];
    
    _followTourAltitude.textColor = [UIColor whiteColor];
    _followTourAltitude.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    _removeFollowTour = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _removeFollowTour.frame = CGRectMake(_width-55, 11, 30, 30);
    [_removeFollowTour setBackgroundImage:[UIImage imageNamed:@"cancel_icon@3x.png"] forState:UIControlStateNormal];
    [_removeFollowTour addTarget:self action:@selector(RemoveFollowTour:) forControlEvents:UIControlEventTouchUpInside];
    
    _upLineView = [[UIView alloc] initWithFrame:CGRectMake(5, 42, 50, 2)];
    
    _upLineView.backgroundColor = [UIColor greenColor];
    
    _downLineView = [[UIView alloc] initWithFrame:CGRectMake(120, 42, 50, 2)];
    
    _downLineView.backgroundColor = [UIColor yellowColor];
    
    _upLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 50, 15)];
    
    _upLineLabel.textColor = [UIColor whiteColor];
    _upLineLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _upLineLabel.text = @"Aufstieg";
    
    _downLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 35, 50, 15)];
    
    _downLineLabel.textColor = [UIColor whiteColor];
    _downLineLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _downLineLabel.text = @"Abfahrt";
    
    [_followTourView addSubview:followTourBlurView];
    [_followTourView addSubview:_followTourTitle];
    [_followTourView addSubview:_followTourTime];
    [_followTourView addSubview:_followTourDistance];
    [_followTourView addSubview:_followTourAltitude];
    [_followTourView addSubview:_removeFollowTour];
    [_followTourView addSubview:_upLineView];
    [_followTourView addSubview:_downLineView];
    [_followTourView addSubview:_upLineLabel];
    [_followTourView addSubview:_downLineLabel];
    
    [self.view addSubview:_followTourView];
    
    [_followTourView setHidden:YES];
    
    [_upLineView setHidden:YES];
    [_downLineView setHidden:YES];
    [_upLineLabel setHidden:YES];
    [_downLineLabel setHidden:YES];
    
    [followTourBlurView release];
    
    _addWarning = false;
    
    _tempMarker = [[GMSMarker alloc] init];
    
    _lastRunStatus = 0;
    
    [_totalTimeLabel setHidden:YES];
    [_totalDistanceLabel setHidden:YES];
    [_totalAltitudeLabel setHidden:YES];
    
    _GPSSignalLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200, _sectionHeight)];
    
    _GPSSignalLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _GPSSignalLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _GPSSignalLabel.text = @"Suche GPS Signal...";
    
    [_GPSSignal setHidden:NO];
    
    [_altitudeRateIcon setHidden:YES];
    
    [_longLabel setHidden:YES];
    [_latLabel setHidden:YES];
    [_elevationLabel setHidden:YES];
    
    [_locationSection addSubview:_GPSSignalLabel];
    
    data = [XTDataSingleton singleObj];
    data.timer = 0;
    
    NSLog(@"%@",[data GetDocumentFilePathForFile:@"/" CheckIfExist:NO]);
    
    data.runStatus = 0;
    
    _bestLocation = nil;
    
    _locationStartTimer = nil;
    _locationStopTimer = nil;
    
    _geocoder = [[CLGeocoder alloc] init];
    _placemark = [[CLPlacemark alloc] init];
    
    _oldAccuracy = 10000.0;
    
    _recoveryTimer = 0;
    
    _didReachInitialAccuracy = false;
    
    _didRecoverTour = false;
    _writeRecoveryFile = false;
    
    [data CheckLogin];
    
    // Check whether the recovery file exist. If so, the app may have crashed, so re-load the data
    NSString *recoveryFile = [data GetDocumentFilePathForFile:@"/recovery.xml" CheckIfExist:YES];
    if (recoveryFile && _writeRecoveryFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Recovery file found" message:@"Trying to recover last tour" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Found recovery file");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [data RecoverTour];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Tour was recovered");
                
                _didRecoverTour = true;
            });
        });
    }
    else {NSLog(@"No recovery file found");}
    
    //[data CleanUpTourDirectory];
    
    [data CreateTourDirectory];
    NSArray *tourFiles = [data GetAllGPXFiles];
    NSArray *imageFiles = [data GetAllImages];
    
    NSLog(@"GPX files: %@",tourFiles);
    NSLog(@"Image files: %@",imageFiles);
    
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *dir = [data GetDocumentFilePathForFile:@"/tours/" CheckIfExist:NO];
    NSArray *imagesInDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];
    NSLog(@"Content of tour directory: %@",imagesInDirectory);
    
    [data GetUserSettings];
    
    [self startLocationUpdate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    /*NSString *tourDirectory = [data GetDocumentFilePathForFile:@"/" CheckIfExist:NO];
    NSArray *content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tourDirectory error:nil];
    
    for (int i = 0; i < [content count]; i++) {
        NSString *file = [NSString stringWithFormat:@"%@/%@", tourDirectory, [content objectAtIndex:i]];
        if ([[file pathExtension] isEqualToString:@"txt"]) {
            NSLog(@"Background session task: %@",file);
            
            [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        }
    }*/
    
    if ([data GetNumberOfFilesInTourDirectory] > 0) {
        
        XTFileUploader *uploader = [[XTFileUploader alloc] init];
        
        [uploader UploadGPXFiles];
        [uploader UploadImages];
        [uploader UploadImageInfo];
        
        XTNotificationViewController *notification = [[XTNotificationViewController alloc] init];
        
        //[[UIApplication sharedApplication].keyWindow addSubview:notification.view];
        
        [self.view addSubview:notification.view];
        
        notification.messageView.text = @"Einige Touren-Daten wurden noch nicht auf den Server hochgeladen. Versuche es jetzt nochmals.";
        
        notification.delayTime = 2.0f;
        notification.displayTime = 10.0f;
        
        [notification ShowView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [_timerSection release];
    [_distanceSection release];
    [_altitudeSection release];
    [_locationSection release];
    [_timerLabel release];
    [_longLabel release];
    [_latLabel release];
    [_distanceLabel release];
    [_distanceRateLabel release];
    [_altitudeLabel release];
    [_altitudeRateLabel release];
    [_elevationLabel release];
    [_PauseButton release];
    [_loginButton release];
    [_pollingTimer release];
    [login release];
    [summary release];
    [_GPSSignal release];
    [_StartButton release];
    [_StopButton release];
    [_timerSection release];
    [_distanceSection release];
    [_altitudeSection release];
    [_locationSection release];
    [_totalDistanceLabel release];
    [_totalTimeLabel release];
    [_totalAltitudeLabel release];
    [_altitudeRateIcon release];
    [_header release];
    [_header_shadow release];
    [_GPSSignalLabel release];
    [_geocoder release];
    [_placemark release];
    [_pollingTimer release];
    [_distanceSectionSeparator release];
    [_altitudeSectionSeparator release];
    [_timerIcon release];
    [_distanceIcon release];
    [_altitudeIcon release];
    [_locationIcon release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self LoginViewDidClose:nil];
    
    if (data.runStatus == 5) {[self ResetTour];}
    
    NSString *up_icon;
    NSString *down_icon;
    
    switch (data.profileSettings.equipment) {
        case 0:
            if (data.runStatus == 1) {up_icon = @"skier_up_button_inactive.png";}
            else {up_icon = @"skier_up_button.png";}
            if (data.runStatus == 3) {down_icon = @"skier_down_button_inactive.png";}
            else {down_icon = @"skier_down_button.png";}
            _up_button_icon = @"skier";
            _down_button_icon = @"skier";
            break;
        case 1:
            if (data.runStatus == 1) {up_icon = @"snowboarder_up_button_inactive.png";}
            else {up_icon = @"snowboarder_up_button.png";}
            if (data.runStatus == 3) {down_icon = @"snowboarder_down_button_inactive.png";}
            else {down_icon = @"snowboarder_down_button.png";}
            _up_button_icon = @"snowboarder";
            _down_button_icon = @"snowboarder";
            break;
        case 2:
            if (data.runStatus == 1) {up_icon = @"skier_up_button_inactive.png";}
            else {up_icon = @"skier_up_button.png";}
            if (data.runStatus == 3) {down_icon = @"snowboarder_down_button_inactive.png";}
            else {down_icon = @"snowboarder_down_button.png";}
            _up_button_icon = @"skier";
            _down_button_icon = @"snowboarder";
            break;
            
    }
    
    [_StartButton setImage:[UIImage imageNamed:up_icon] forState:UIControlStateNormal];
    [_StopButton setImage:[UIImage imageNamed:down_icon] forState:UIControlStateNormal];
    
    for (int i = 0; i < [data GetNumImages]; i++) {
        if ([data GetImageLongitudeAt:i] && [data GetImageLatitudeAt:i]) {
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([data GetImageLatitudeAt:i], [data GetImageLongitudeAt:i]);
            
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.icon = [UIImage imageNamed:@"ski_pole_camera@3x.png"];
            marker.map = _mapView;
        }
    }
    
    _mapView.myLocationEnabled = YES;
    
    //[_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    for (int i = 0; i < [_polylines count]; i++) {
        GMSPolyline *currentPolyline = [_polylines objectAtIndex:i];
        
        currentPolyline.map = nil;
    }
    
    [_polylines removeAllObjects];
    
    NSLog(@"Number of tracks: %lu",(unsigned long)[data.pathSegments count]);
    
    for (int i = 0; i < [data.pathSegments count]; i++) {
        GMSPolyline *currentPolyline = [[GMSPolyline alloc] init];
        currentPolyline = [data.pathSegments objectAtIndex:i];
        
        NSLog(@"Number of coordinates: %lu",(unsigned long)[currentPolyline.path count]);
        
        currentPolyline.map = _mapView;
        
        [_polylines addObject:currentPolyline];
    }
    
    if (data.followTourInfo) {
        for (int i = 0; i < [data.followTourInfo.tracks count]; i++) {
            GMSPolyline *currentPolyline = [[GMSPolyline alloc] init];
            currentPolyline = [data.followTourInfo.tracks objectAtIndex:i];
            
            currentPolyline.map = _mapView;
            
            [_polylines addObject:currentPolyline];
        }
    }
    
    if (data.followTourInfo) {
        float tourTime = (float)data.followTourInfo.totalTime;
        
        float hours = floorf(tourTime/3600);
        float minutes = floor(floorf((tourTime/3600 - hours)*60)/10)*10;
        
        float distance = data.followTourInfo.distance;
        NSString *distanceUnit = @"km";
        if (data.followTourInfo.distance < 1) {
            distance = data.followTourInfo.distance*1000;
            distanceUnit = @"m";
        }
        
        _followTourTime.text = [NSString stringWithFormat:@"%.0fh %.0fm",hours,minutes];
        _followTourDistance.text = [NSString stringWithFormat:@"%.1f%@",data.followTourInfo.distance,distanceUnit];
        _followTourAltitude.text = [NSString stringWithFormat:@"%.1fm",data.followTourInfo.altitude];
        
        if (_followTourView.hidden) {
            CGRect warningFrame = _addWarningBackground.frame;
            CGRect mapFrame = _changeMapBackground.frame;
            
            _addWarningBackground.frame = CGRectMake(warningFrame.origin.x, warningFrame.origin.y+57, warningFrame.size.width, warningFrame.size.height);
            
            _changeMapBackground.frame = CGRectMake(mapFrame.origin.x, mapFrame.origin.y+57, mapFrame.size.width, mapFrame.size.height);
            
            [_upLineView setHidden:NO];
            [_upLineLabel setHidden:NO];
            
            [_followTourView setAlpha:1.0];
            
            [_followTourView setHidden:NO];
        }
        
        if ([_polylines count] > 1) {
            [_downLineView setHidden:NO];
            [_downLineLabel setHidden:NO];
        }
    }
    else {
        CGRect warningFrame = _addWarningBackground.frame;
        CGRect mapFrame = _changeMapBackground.frame;
        
        _addWarningBackground.frame = CGRectMake(warningFrame.origin.x, 80, warningFrame.size.width, warningFrame.size.height);
        
        _changeMapBackground.frame = CGRectMake(mapFrame.origin.x, 130, mapFrame.size.width, mapFrame.size.height);
        
        [_followTourView setHidden:YES];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    _mapView.myLocationEnabled = NO;
    
    @try {
        [_mapView removeObserver:self forKeyPath:@"myLocation" context:NULL];
    }
    @catch (id exception) {
        
    }
}

- (void)applicationEnterBackground
{
    //Create location manager
    /*CLLocationManager *locationManager = [XTHomeViewController sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10;
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];*/
    
    /*self.backgroundTaskManager = [XTBackgroundTaskManager sharedBackgroundTaskManager];
    [self.backgroundTaskManager beginNewBackgroundTask];*/
}

- (void)applicationEnterForeground
{
    
}

- (IBAction)pauseTour:(id)sender {
    [_pollingTimer invalidate];
    _pollingTimer = nil;
    
    [self stopLocationUpdate:NO];
    
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
        [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
        [_PauseButton setImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        
        data.runStatus = 2;
        
        return;
    }
    
    if (data.runStatus == 0) {
    
    }
    else if (data.runStatus == 1) {
        [_PauseButton setImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        data.runStatus = 2;
    }
    else if (data.runStatus == 2) {
        data.endTime = [NSDate date];
        data.TotalEndTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        if (!summary) {summary = [[XTSummaryViewController alloc] initWithNibName:nil bundle:nil];}
        [self presentViewController:summary animated:YES completion:nil];
        
        [summary release];
        summary = nil;
    }
    else if (data.runStatus == 3) {
        [_PauseButton setImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        data.runStatus = 4;
    }
    else if (data.runStatus == 4) {
        data.endTime = [NSDate date];
        data.TotalEndTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        if (!summary) {summary = [[XTSummaryViewController alloc] initWithNibName:nil bundle:nil];}
        [self presentViewController:summary animated:YES completion:nil];
        
        [summary release];
        summary = nil;
    }
    
    [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
    [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
    
    if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }
}

- (IBAction)startUpTour:(id)sender {
    if (_didReachInitialAccuracy && data.loggedIn) {
        if (!_pollingTimer) {_pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];}
    }
    
    [self startLocationUpdate];
    
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button_inactive.png",_up_button_icon]] forState:UIControlStateNormal];
        [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        data.runStatus = 1;
        return;
    }
    
    if (data.runStatus == 0) {
        if (!data.loggedIn) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Du musst dich einloggen um eine Tour zu starten. Klicke auf das Profil-Icon." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
            return;
        }
        
        if (!_didReachInitialAccuracy) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Achtung" message:@"Das GPS Signal ist noch etwas schwach. Möchtest du die Tour trotzdem starten?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
            
            [alert show];
            [alert release];
            
            data.runStatus = 1;
            
            return;
        }
        data.startTime = [NSDate date];
        data.TotalStartTime = [NSDate date];
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyLLddHHmmss"];
        
        NSString *tourID = [[NSString alloc] initWithFormat:@"%@%@", [formatter stringFromDate:[NSDate date]], data.userID];
        
        data.tourID = tourID;
        data.upCount++;
        
        [formatter release];
        [tourID release];
    }
    else if (data.runStatus == 1) {
    
    }
    else if (data.runStatus == 2) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
    }
    else if (data.runStatus == 3) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        data.upCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    else if (data.runStatus == 4) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        data.upCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    
    [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button_inactive.png",_up_button_icon]] forState:UIControlStateNormal];
    [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
    
    data.runStatus = 1;
    
    if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }
}

- (IBAction)startDownTour:(id)sender {
    if (_didReachInitialAccuracy && data.loggedIn) {
        if (!_pollingTimer) {_pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];}
    }
    
    [self startLocationUpdate];
    
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
        [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button_inactive.png",_down_button_icon]] forState:UIControlStateNormal];
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        data.runStatus = 3;
        return;
    }
    
    if (data.runStatus == 0) {
        if (!data.loggedIn) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Du musst dich einloggen um eine Tour zu starten. Klicke auf das Profil-Icon." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
            return;
        }
        
        if (!_didReachInitialAccuracy) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Achtung" message:@"Das GPS Signal ist noch etwas schwach. Möchtest du die Tour trotzdem starten?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
            
            [alert show];
            [alert release];
            
            data.runStatus = 3;
            
            return;
        }
        data.startTime = [NSDate date];
        data.TotalStartTime = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyLLddHHmmss"];
        
        NSString *tourID = [[NSString alloc] initWithFormat:@"%@%@", [formatter stringFromDate:[NSDate date]], data.userID];
        
        data.tourID = tourID;
        data.downCount++;
        
        [formatter release];
        [tourID release];
    }
    else if (data.runStatus == 1) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        data.downCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    else if (data.runStatus == 2) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        data.downCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    else if (data.runStatus == 3) {
    
    }
    else if (data.runStatus == 4) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
    }
    
    [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
    [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button_inactive.png",_down_button_icon]] forState:UIControlStateNormal];
    
    data.runStatus = 3;
    
    if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }
}

- (void) FinishTour:(bool)batteryIsLow
{
    [_pollingTimer invalidate];
    _pollingTimer = nil;
    
    [self stopLocationUpdate:NO];
    
    if (data.runStatus == 0 || data.runStatus == 5) {return;}
    
    NSString *tourType = @"up";
    
    switch (data.runStatus) {
        case 1:
            tourType = @"up";
            break;
        case 2:
            tourType = @"up";
            break;
        case 3:
            tourType = @"down";
            break;
        case 4:
            tourType = @"down";
            break;
    }
    
    data.endTime = [NSDate date];
    data.TotalEndTime = [NSDate date];
    [data CreateXMLForCategory:tourType];
    
    data.lowBatteryLevel = batteryIsLow;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data CreateXMLForCategory:@"sum"];
        [data WriteImageInfo];
        
        data.runStatus = 5;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [data ResetAll];
            
            XTFileUploader *uploader = [[XTFileUploader alloc] init];
            [uploader UploadGPXFiles];
            [uploader UploadImages];
            [uploader UploadImageInfo];
        });
    });
}

- (void) UpdateDisplayWithLocation:(CLLocation*)location
{
    if (!location) {return;}
    
    double longitude = (double)location.coordinate.longitude;
    double latitude = (double)location.coordinate.latitude;
    double alt = (double)location.altitude;
    
    double longitudeAbs = fabs(longitude);
    double latitudeAbs = fabs(latitude);
    
    _longLabel.text = [NSString stringWithFormat:@"%.0f°%.0f'%.1f\" %@",
                       floor(longitudeAbs),
                       floor((longitudeAbs - floor(longitudeAbs)) * 60),
                       ((longitudeAbs - floor(longitudeAbs)) * 60 - floor((longitudeAbs - floor(longitudeAbs)) * 60)) * 60, longitude < 0 ? @"W" : @"E"];
    _latLabel.text = [NSString stringWithFormat:@"%.0f°%.0f'%.1f\" %@",
                      floor(latitudeAbs),
                      floor((latitudeAbs - floor(latitudeAbs)) * 60),
                      ((latitudeAbs - floor(latitudeAbs)) * 60 - floor((latitudeAbs - floor(latitudeAbs)) * 60)) * 60, latitude < 0 ? @"S" : @"N"];
    _elevationLabel.text = [NSString stringWithFormat:@"%.0f müm", alt];
    
    NSString *distTotal;
    if (data.totalDistance < 0.1) {distTotal = [NSString stringWithFormat:@"%.0f m", (data.totalDistance)*1000];}
    else {distTotal = [NSString stringWithFormat:@"%.1f km", data.totalDistance];}
    
    _distanceLabel.text = distTotal;
    _altitudeLabel.text = [NSString stringWithFormat:@"%.0f m", data.runStatus == 1 ? data.totalCumulativeAltitude : data.totalCumulativeDescent];
    
    _totalDistanceLabel.text = [NSString stringWithFormat:@"%.1f km",data.sumDistance];
    _totalAltitudeLabel.text = [NSString stringWithFormat:@"%.1f m",data.sumCumulativeAltitude];
    
    if (data.rateTimer > 10) {
        double diffDistance = data.totalDistance - data.rateLastDistance;
        double diffAltitude = data.totalAltitude - data.rateLastAltitude;
        data.DistanceRate = diffDistance/data.rateTimer * 3600.0;
        data.AltitudeRate = diffAltitude/data.rateTimer * 3600.0;
        
        NSString *r_dist_str = [NSString stringWithFormat:@"%.1f km/h", data.DistanceRate];
        NSString *r_alt_str = [NSString stringWithFormat:@"%.1f m/h", data.AltitudeRate];
        
        _distanceRateLabel.text = r_dist_str;
        _altitudeRateLabel.text = r_alt_str;
        
        if (data.AltitudeRate > 0) {_altitudeRateIcon.image = [UIImage imageNamed:@"arrow_up@3x.png"]; [_altitudeRateIcon setHidden:NO];}
        else if (data.AltitudeRate < 0) {_altitudeRateIcon.image = [UIImage imageNamed:@"arrow_down@3x.png"]; [_altitudeRateIcon setHidden:NO];}
        else {[_altitudeRateIcon setHidden:YES];}
        
        data.rateTimer = 0;
        data.rateLastDistance = data.totalDistance;
        data.rateLastAltitude = data.totalAltitude;
    }
}

- (void) SaveCurrentLocation:(CLLocation*)location
{
    if (!location) {return;}
    
    CLLocationDistance alt = location.altitude;
    
    if (!data.StartLocation) {
        data.StartLocation = location;
        
        data.lowestPoint = location;
        data.highestPoint = location;
        
        [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                _placemark = [placemarks lastObject];
                data.country = _placemark.country;
                data.province = _placemark.administrativeArea;
            }
            else {
                NSLog(@"%@", error.debugDescription);
            }
        }];
    }
    NSLog(@"Calculating haversine distance...");
    [data AddCoordinate:location];
    double d = [data CalculateHaversineForCurrentCoordinate];
    
    double altitudeDiff = [data CalculateAltitudeDiffForCurrentCoordinate];
    [data AddDistance:d andHeight:altitudeDiff];
    
    UIDevice *device = [UIDevice currentDevice];
    [device setBatteryMonitoringEnabled:YES];
    float level = [device batteryLevel];
    
    [data.batteryLevel addObject:[NSNumber numberWithFloat:level]];
    
    if (alt < data.lowestPoint.altitude) {data.lowestPoint = location;}
    if (alt > data.highestPoint.altitude) {data.highestPoint = location;}
    if (alt < data.sumlowestPoint.altitude) {data.sumlowestPoint = location;}
    if (alt > data.sumhighestPoint.altitude) {data.sumhighestPoint = location;}
    
    NSLog(@"Haversine distance: %f", d);
    
    if (level < 0.2 && data.profileSettings.safetyModus) {
        [self FinishTour:YES];
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        [notification setAlertAction:@"Launch"];
        [notification setAlertBody:@"\U0001F50B Die Battery ist unter 20% gefallen. Die GPS-Aufzeichnung wurde gestoppt und die Tour beendet."];
        [notification setHasAction:YES];
        notification.applicationIconBadgeNumber = 1;
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        [notification release];
    }
}

- (void) SetBackgroundTimer
{
    self.backgroundTaskManager = [XTBackgroundTaskManager sharedBackgroundTaskManager];
    [self.backgroundTaskManager beginNewBackgroundTask];
    
    if (!_locationStartTimer) {_locationStartTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(startLocationUpdate) userInfo:nil repeats:NO];}
    
    if (!_locationStopTimer) {_locationStopTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(stopLocationUpdate) userInfo:nil repeats:NO];}
}

- (void) ResetTour
{
    _timerLabel.text = @"00h 00m 00s";
    _distanceLabel.text = @"-- km";
    _altitudeLabel.text = @"-- m";
    _distanceRateLabel.text = @"-- km/h";
    _altitudeRateLabel.text = @"-- m/h";
    
    [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
    
    [_totalTimeLabel setHidden:YES];
    [_totalDistanceLabel setHidden:YES];
    [_totalAltitudeLabel setHidden:YES];
    
    data.runStatus = 0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _didReachInitialAccuracy = true;
        
        if (!_pollingTimer) {_pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];}
        
        data.startTime = [NSDate date];
        data.TotalStartTime = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyLLddHHmmss"];
        
        NSString *tourID = [[NSString alloc] initWithFormat:@"%@%@", [formatter stringFromDate:[NSDate date]], data.userID];
        
        data.tourID = tourID;
        
        if (data.runStatus == 1) {
            data.upCount++;
            
            [_StartButton setImage:[UIImage imageNamed:@"skier_up_button_inactive.png"] forState:UIControlStateNormal];
        }
        else {
            data.downCount++;
            
            [_StopButton setImage:[UIImage imageNamed:@"skier_down_button_inactive.png"] forState:UIControlStateNormal];
        }
        
        [formatter release];
        [tourID release];
        
        [_GPSSignalLabel setHidden:YES];
        
        [_longLabel setHidden:NO];
        [_latLabel setHidden:NO];
        [_elevationLabel setHidden:NO];
        
        if (data.profileSettings.batterySafeMode) {[self SetBackgroundTimer];}
    }
    else {data.runStatus = 0;}
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* Location = [locations lastObject];
    
    data.CurrentLocation = Location;
    
    NSLog(@"Accuracy: %.1f",Location.horizontalAccuracy);
    
    double accuracy = Location.horizontalAccuracy;
    
    if (accuracy < _oldAccuracy) {self.bestLocation = Location; self.oldAccuracy = accuracy;}
    
    if (accuracy >= 1000.0) {[_GPSSignal setImage:[UIImage imageNamed:@"GPS_none.png"]]; if (!_didReachInitialAccuracy) {return;}}
    if (accuracy >= 100.0 && accuracy < 1000.0) {[_GPSSignal setImage:[UIImage imageNamed:@"GPS_weak.png"]]; if (!_didReachInitialAccuracy) {return;}}
    if (accuracy > 10.0 && accuracy < 100.0) {[_GPSSignal setImage:[UIImage imageNamed:@"GPS_medium.png"]]; if (!_didReachInitialAccuracy) {return;}}
    if (accuracy <= 10.0) {
        [_GPSSignal setImage:[UIImage imageNamed:@"GPS_strong.png"]];
        if (!_didReachInitialAccuracy) {
            _didReachInitialAccuracy = true;
            [self stopLocationUpdate:NO];
            
            [_GPSSignalLabel setHidden:YES];
            
            [_longLabel setHidden:NO];
            [_latLabel setHidden:NO];
            [_elevationLabel setHidden:NO];
            
            [self UpdateDisplayWithLocation:Location];
            
            NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_warnings_string.php?radius=%f&longitude=%f&latitude=%f", data.profileSettings.warningRadius, Location.coordinate.longitude, Location.coordinate.latitude];
            NSURL *url = [NSURL URLWithString:requestString];
            
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            
            sessionConfiguration.timeoutIntervalForRequest = 10.0;
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
            
            NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
                if (error) {
                    return;
                }
                
                XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
                
                NSMutableArray *warningsArray = [request GetWarningsWithinRadius:responseData];
                
                if ([warningsArray count] > 0) {
                    [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%lu", (unsigned long)[warningsArray count]]];
                    
                    [self ShowWarningNotification];
                }
                else {[[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:nil];}
            }];
            
            [sessionTask resume];
            
            return;
        }
    }
    
    if (data.runStatus == 0 || data.runStatus == 2 || data.runStatus == 4) {return;}
    
    if (data.profileSettings.batterySafeMode) {
        if (_locationStartTimer) {return;}
        
        [self SetBackgroundTimer];
    }
    else {
        [self UpdateDisplayWithLocation:Location];
        
        if (accuracy < 300) {
            [self SaveCurrentLocation:Location];
            
            [self UpdateMap:Location];
        }
    }
}

- (void)ShowWarningNotification
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    float tabBarHeight = [[UITabBarController new] tabBar].frame.size.height;
    
    XTPointingNotificationView *notification = [[XTPointingNotificationView alloc] initWithSize:CGSizeMake(width-20, 40) pointingAt:CGPointMake(width/5*3.5, height-tabBarHeight) direction:0 message:@"Gefahrenstellen in der Umgebung gefunden!"];
    
    [self.view addSubview:notification];
    
    [notification animateWithTimeout:5];
    
    [notification release];
}

- (void)UpdateMap:(CLLocation*)location
{
    @try {
        //CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        CGFloat currentZoom = _mapView.camera.zoom;
        //GMSVisibleRegion visibleRegion = _mapView.projection.visibleRegion;
        if (!_mapHasMoved) {
            _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:currentZoom];
        }
        
        NSUInteger coordinateSize = [[data GetCoordinatesForCurrentRun] count];
        NSUInteger pathSize = [_path count];
        
        if (_lastRunStatus == 0) {_lastRunStatus = data.runStatus;}
        
        if (coordinateSize < 2) {return;}
        
        if (pathSize > coordinateSize) {
            /*GMSPolyline *currentPolyline = [[GMSPolyline alloc] init];
             
             currentPolyline.strokeWidth = 5.0f;
             if (_lastRunStatus == 1 || _lastRunStatus == 2) {currentPolyline.strokeColor = [UIColor blueColor];}
             else {currentPolyline.strokeColor = [UIColor redColor];}
             
             [currentPolyline setPath:_path];
             
             [_savedPolylines addObject:currentPolyline];
             
             currentPolyline.map = _mapView;
             
             _lastRunStatus = data.runStatus;*/
            
            [_path removeAllCoordinates];
            pathSize = 0;
        }
        
        if (!(coordinateSize > pathSize)) {return;}
        
        // Add new coordinates to the path
        NSUInteger i;
        NSMutableArray *locations = [data GetCoordinatesForCurrentRun];
        for (i = pathSize; i < coordinateSize; i++) {
            CLLocation * location = [locations objectAtIndex:i];
            [_path addCoordinate:location.coordinate];
        }
        
        /*[_path removeAllCoordinates];
         NSMutableArray *locations = [data GetCoordinatesForCurrentRun];
         for (int i = 0; i < [locations count]; i++) {
         CLLocation *location = [locations objectAtIndex:i];
         [_path addCoordinate:location.coordinate];
         }*/
        
        [_polyline setPath:_path];
        /*_polyline.strokeColor = [UIColor blueColor];
         _polyline.strokeWidth = 5.f;
         _polyline.map = _mapView;*/
    }
    @catch (id exception) {
        
    }
    return;
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if (gesture) {
        _mapHasMoved = true;
        [_centerView setHidden:NO];
    }
}

- (void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (!_addWarning) {return;}
    
    if (!warningInfo) {warningInfo = [[XTWarningsInfo alloc] init];}
    
    [warningInfo ClearData];
    
    warningInfo.userID = data.userID;
    warningInfo.tourID = data.tourID;
    warningInfo.userName = data.userInfo.userName;
    warningInfo.submitDate = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    warningInfo.longitude = coordinate.longitude;
    warningInfo.latitude = coordinate.latitude;
    
    _tempMarker.position = coordinate;
    _tempMarker.icon = [UIImage imageNamed:@"ski_pole_warning@3x.png"];
    _tempMarker.groundAnchor = CGPointMake(0.88, 1.0);
    _tempMarker.map = _mapView;
    
    if (addWarningView) {[addWarningView.view removeFromSuperview];}
    
    addWarningView = [[XTAddWarningViewController alloc] initWithNibName:nil bundle:nil warningInfo:warningInfo];
    
    addWarningView.titleLabel.text = @"Neue Gefahrenstelle";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnterWarning:) name:@"AddWarningViewDismissed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CancelEnterWarning:) name:@"AddWarningViewDismissedCancel" object:nil];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:addWarningView.view];
    [addWarningView animate];
}

- (void)centerMap:(id)sender {
    _mapHasMoved = false;
    [_centerView setHidden:YES];
}

- (void)AddWarning:(id)sender {
    if (!_addWarning) {
        [self ShowAddWarning];
    }
    else {
        [self HideAddWarning];
    }
}

- (void) EnterWarning:(id)sender {
    _tempMarker.map = nil;
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(warningInfo.latitude, warningInfo.longitude);
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.icon = [UIImage imageNamed:@"ski_pole_warning@3x.png"];
    marker.groundAnchor = CGPointMake(0.88, 1.0);
    marker.map = _mapView;
    
    NSMutableArray *categories = [[NSMutableArray alloc] initWithObjects:@"Lawinenabgang",@"Instabile Unterlage",@"Spalten",@"Steinschlag",@"Sonst etwas", nil];
    
    if ([[categories objectAtIndex:warningInfo.category] isEqualToString:@"Sonst etwas"]) {marker.title = @"Gefahrenstelle";}
    else {marker.title = [categories objectAtIndex:warningInfo.category];}
    
    [categories release];
    
    [self HideAddWarning];
}

- (void) CancelEnterWarning:(id)sender {
    _tempMarker.map = nil;
}

- (void) ShowAddWarning
{
    CGRect addWarningBackgroundFrame = _addWarningBackground.frame;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _addWarningBackground.frame = CGRectMake(10, addWarningBackgroundFrame.origin.y, _width-20, 40);
        _addWarningButton.frame = CGRectMake(_width-55, 5, 30, 30);
        [_addWarningButton setImage:[UIImage imageNamed:@"cancel_icon@3x.png"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
            [_addWarningText setHidden:NO];
        } completion:nil];
    }];
    
    _addWarning = true;
}

- (void) HideAddWarning
{
    CGRect addWarningBackgroundFrame = _addWarningBackground.frame;
    
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        [_addWarningText setHidden:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
            _addWarningBackground.frame = CGRectMake(_width-50, addWarningBackgroundFrame.origin.y, 40, 40);
            _addWarningButton.frame = CGRectMake(5, 5, 30, 30);
            [_addWarningButton setImage:[UIImage imageNamed:@"add_warning_icon@3x.png"] forState:UIControlStateNormal];
        } completion:nil];
    }];
    
    _addWarning = false;
}

- (void) ChangeMapType:(id)sender
{
    if (_mapView.mapType == kGMSTypeTerrain) {
        _mapView.mapType = kGMSTypeHybrid;
        
        [_changeMap setBackgroundImage:[UIImage imageNamed:@"map_type_terrain@3x.png"] forState:UIControlStateNormal];
    }
    else {
        _mapView.mapType = kGMSTypeTerrain;
        
        [_changeMap setBackgroundImage:[UIImage imageNamed:@"map_type_satellite@3x.png"] forState:UIControlStateNormal];
    }
}

- (void) RemoveFollowTour:(id)sender
{
    for (int i = 0; i < [_polylines count]; i++) {
        GMSPolyline *currentPolyline = [_polylines objectAtIndex:i];
        
        currentPolyline.map = nil;
    }
    
    [_polylines removeAllObjects];
    
    data.followTourInfo = nil;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        [_followTourView setAlpha:0.0];
        
        [_followTourView setHidden:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
            _addWarningBackground.frame = CGRectMake(_width-50, 80, 40, 40);
            _changeMapBackground.frame = CGRectMake(_width-50, 130, 40, 40);
        } completion:nil];
    }];
}

- (void) LoadCamera:(id)sender
{
    if (!data.tourID) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message: @"Photos können nur während einer Tour aufgenommen werden." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (!_ImagePicker) {_ImagePicker = [[UIImagePickerController alloc] init];}
    _ImagePicker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [_ImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.view.window.rootViewController presentViewController:_ImagePicker animated: YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"Camera is not available. Choose existing?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    }
    
    [_ImagePicker release];
    _ImagePicker = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"New image");
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!pickedImage) {return;}
    
    _didPickImage = true;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float imgHeight = pickedImage.size.height;
        float imgWidth = pickedImage.size.width;
        
        float newImgHeight = 0.;
        float newImgWidth = 0.;
        if (imgHeight > imgWidth) {newImgHeight = 1024.; newImgWidth = ceilf(imgWidth/imgHeight*1024.);}
        else {newImgWidth = 1024.; newImgHeight = ceilf(imgHeight/imgWidth*1024.);}
        
        CGRect rect = CGRectMake(0,0,newImgWidth,newImgHeight);
        UIGraphicsBeginImageContext(rect.size);
        [pickedImage drawInRect:rect];
        UIImage *newImg= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSString *newImageName = [data GetNewPhotoName];
        NSString *newImageNameOriginal = [newImageName stringByReplacingOccurrencesOfString:@".jpg" withString:@"_original.jpg"];
        
        NSLog(@"Resizing image %@...",newImageName);
        
        NSData *ImageData = UIImageJPEGRepresentation(pickedImage, 0.9);
        NSData *imageResizedData = UIImageJPEGRepresentation(newImg, 0.9);
        
        if (data.profileSettings.saveOriginalImage) {[ImageData writeToFile:newImageNameOriginal atomically:YES];}
        [imageResizedData writeToFile:newImageName atomically:YES];
        
        XTImageInfo *imageInfo = [[XTImageInfo alloc] init];
        imageInfo.Filename = newImageNameOriginal;
        
        CLLocation *location = (CLLocation*)[data GetLastCoordinates];
        
        if (location) {
            imageInfo.Longitude = location.coordinate.longitude;
            imageInfo.Latitude = location.coordinate.latitude;
            imageInfo.Elevation = location.altitude;
            imageInfo.Date = location.timestamp;
        }
        
        UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Done");
            [data AddImage:imageInfo];
            //[self.collectionView reloadData];
            [imageInfo release];
            
            _didPickImage = false;
        });
    });
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
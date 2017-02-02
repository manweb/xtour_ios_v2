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

- (BOOL)canBecomeFirstResponder {
    return YES;
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
    
    double startButtonSize = 80.0;
    double stopButtonSize = 50.0;
    double changeButtonSize = 40.0;
    double mapScreenFraction = 0.6;
    
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
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _header.frame = CGRectMake(0, 0, _width, 20);
    _header_shadow.frame = CGRectMake(0, 20, _width, 1);
    
    _loginButton.frame = CGRectMake(_width-60, 30, 50, 50);
    
    /*_timerSection.frame = CGRectMake(10, yOffset, width-20, _timerSectionHeight);
    
    yOffset += _timerSectionHeight + dy;
    
    _distanceSection.frame = CGRectMake(10, yOffset, width-20, _sectionHeight);
    
    yOffset += _sectionHeight + dy;
    
    _altitudeSection.frame = CGRectMake(10, yOffset, width-20, _sectionHeight);
    
    yOffset += _sectionHeight + dy;
    
    _locationSection.frame = CGRectMake(10, yOffset, width-20, _sectionHeight);
    
    yOffset += _sectionHeight + dy;*/
    
    _StartButton.frame = CGRectMake((_width-iconScale*startButtonSize)/2, _height-tabBarHeight-iconScale*startButtonSize, iconScale*startButtonSize, iconScale*startButtonSize);
    _FinishButton.frame = CGRectMake((_width+iconScale*startButtonSize)/2, _height-tabBarHeight-iconScale*(startButtonSize-(startButtonSize-stopButtonSize)/2), iconScale*stopButtonSize, iconScale*stopButtonSize);
    _ModusButton.frame = CGRectMake((_width-iconScale*startButtonSize)/2-iconScale*(changeButtonSize+10)-iconScale*10, _height-tabBarHeight-iconScale*(startButtonSize-(startButtonSize-changeButtonSize)/2), iconScale*changeButtonSize, iconScale*changeButtonSize);
    
    [_FinishButton setHidden:YES];
    
    _ButtonWidthLarge = iconScale*80;
    _ButtonHeightLarge = iconScale*80;
    _StartButtonWidthSmall = iconScale*60;
    _StartButtonHeightSmall = iconScale*60;
    _PauseButtonWidthSmall = iconScale*40;
    _PauseButtonWidthSmall = iconScale*40;
    
    /*_timerIcon.frame = CGRectMake(5, (_timerSectionHeight-iconScale*60)/2, iconScale*60, iconScale*60);
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
    _locationSection.layer.borderColor = boxBorderColor.CGColor;*/
    
    _timerLabel.frame = CGRectMake(_width/2*0.2, _height*mapScreenFraction+5, _width*0.8, iconScale*40);
    _timerLabel.font = [UIFont fontWithName:@"Helvetica" size:40*iconScale];
    
    _distanceTitleLabel.frame = CGRectMake(15, _height*mapScreenFraction+iconScale*55, _width/2-15, iconScale*20);
    _distanceTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _distanceLabel.frame = CGRectMake(20, _height*mapScreenFraction+iconScale*80, (_width/2-20)/2, iconScale*20);
    _distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _distanceRateLabel.frame = CGRectMake(20+(_width/2-20)/2, _height*mapScreenFraction+iconScale*80, (_width/2-20)/2, iconScale*20);
    _distanceRateLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _altitudeTitleLabel.frame = CGRectMake(_width/2+15, _height*mapScreenFraction+iconScale*55, _width/2-40, iconScale*20);
    _altitudeTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _altitudeLabel.frame = CGRectMake(_width/2+20, _height*mapScreenFraction+iconScale*80, (_width/2-20)/2, iconScale*20);
    _altitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _altitudeRateLabel.frame = CGRectMake(_width/2+20+(_width/2-20)/2, _height*mapScreenFraction+iconScale*80, (_width/2-20)/2, iconScale*20);
    _altitudeRateLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _altitudeRateIcon.frame = CGRectMake(_width-30, _height*mapScreenFraction+iconScale*53, iconScale*15, iconScale*15);
    
    _longLabel.frame = CGRectMake(30, 18, (_width-30)/3, 15);
    //_longLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _latLabel.frame = CGRectMake((_width-30)/3+30, 18, (_width-30)/3, 15);
    //_latLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _elevationLabel.frame = CGRectMake((_width-30)*2/3+30, 18, (_width-30)/3, 15);
    //_elevationLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    /*_totalTimeLabel.frame = CGRectMake(width-30-width/3, _timerSectionHeight-iconScale*20, width/3, iconScale*20);
    _totalTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:12*iconScale];
    
    _totalDistanceLabel.frame = CGRectMake(width/4, _sectionHeight-iconScale*20, width/2-20-width/4, iconScale*20);
    _totalDistanceLabel.font = [UIFont fontWithName:@"Helvetica" size:12*iconScale];
    
    _totalAltitudeLabel.frame = CGRectMake(width/4, _sectionHeight-iconScale*20, width/2-20-width/4, iconScale*20);
    _totalAltitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:12*iconScale];
    
    _altitudeRateIcon.frame = CGRectMake(width-60, _sectionHeight/2-15*iconScale, 30*iconScale, 30*iconScale);*/
    
    _HorizontalDevider.frame = CGRectMake(10, _height*mapScreenFraction+iconScale*40+10, _width-20, 1);
    
    _VerticalDevider.frame = CGRectMake(_width/2, _height*mapScreenFraction+iconScale*40+12, 1, iconScale*45);
    
    double zoom = 10.0;
    if (data.runStatus != 0) {zoom = 15.0;}
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.770809 longitude:8.377733 zoom:zoom];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, _width, _height*mapScreenFraction) camera:camera];
    
    _mapView.mapType = kGMSTypeTerrain;
    
    [self.view insertSubview:_mapView atIndex:0];
    [_mapView setDelegate:self];
    
    _path = [[GMSMutablePath alloc] init];
    _polyline = [[GMSPolyline alloc] init];
    
    [_polyline setPath:_path];
    _polyline.strokeColor = [UIColor colorWithRed:41.0f/255.0f green:127.0f/255.0f blue:199.0f/255.0f alpha:1.0f];
    _polyline.strokeWidth = 3.f;
    _polyline.map = _mapView;
    
    _polylines = [[NSMutableArray alloc] init];
    
    _savedPolylines = [[NSMutableArray alloc] init];
    
    _mapHasMoved = false;
    
    _locationBackground.frame = CGRectMake(0, _height*mapScreenFraction-35, _width, 35);
    
    _locationBackground.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _locationBackground.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:0.0] CGColor],
                       (id)[[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0] CGColor], nil];
    gradient.startPoint = CGPointMake(0.5, 0.0); // default; bottom of the view
    gradient.endPoint = CGPointMake(0.5, 1.0);   // default; top of the view
    [_locationBackground.layer insertSublayer:gradient atIndex:0];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *centerBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    centerBlurView.frame = CGRectMake(0, 0, 120, 30);
    centerBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    centerBlurView.layer.cornerRadius = 5.0f;
    centerBlurView.clipsToBounds = YES;
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(_width/2-60, _height*mapScreenFraction-60, 120, 30)];
    
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
    addWarningBlurView.frame = CGRectMake(0, 0, 50, 50);
    addWarningBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    addWarningBlurView.layer.cornerRadius = 25.0f;
    addWarningBlurView.clipsToBounds = YES;
    
    _addWarningBackground = [[UIView alloc] initWithFrame:CGRectMake(_width+60, 90, 50, 50)];
    
    _addWarningBackground.backgroundColor = [UIColor clearColor];
    _addWarningBackground.layer.cornerRadius = 25.0f;
    
    _addWarningButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    
    [_addWarningButton setImage:[UIImage imageNamed:@"add_warning_icon@3x.png"] forState:UIControlStateNormal];
    [_addWarningButton addTarget:self action:@selector(AddWarning:) forControlEvents:UIControlEventTouchUpInside];
    
    _addWarningText = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 250, 40)];
    
    _addWarningText.text = @"Klicke auf die Karte für midestens 2s um eine Gefahrenstelle zu markieren.";
    _addWarningText.textColor = [UIColor whiteColor];
    _addWarningText.font = [UIFont fontWithName:@"Helvetica" size:14];
    _addWarningText.contentInset = UIEdgeInsetsMake(-8, 0, 0, 0);
    _addWarningText.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    [_addWarningText setHidden:YES];
    
    [_addWarningBackground addSubview:addWarningBlurView];
    [_addWarningBackground addSubview:_addWarningButton];
    [_addWarningBackground addSubview:_addWarningText];
    [self.view addSubview:_addWarningBackground];
    
    [addWarningBlurView release];
    
    UIVisualEffectView *changeMapBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    changeMapBlurView.frame = CGRectMake(0, 0, 50, 50);
    changeMapBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    changeMapBlurView.layer.cornerRadius = 25.0f;
    changeMapBlurView.clipsToBounds = YES;
    
    _changeMapBackground = [[UIView alloc] initWithFrame:CGRectMake(_width+60, 150, 50, 50)];
    
    _changeMapBackground.backgroundColor = [UIColor clearColor];
    _changeMapBackground.layer.cornerRadius = 25.0f;
    
    _changeMap = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _changeMap.frame = CGRectMake(10, 10, 30, 30);
    [_changeMap setBackgroundImage:[UIImage imageNamed:@"map_type_satellite@3x.png"] forState:UIControlStateNormal];
    [_changeMap addTarget:self action:@selector(ChangeMapType:) forControlEvents:UIControlEventTouchUpInside];
    
    [_changeMapBackground addSubview:changeMapBlurView];
    [_changeMapBackground addSubview:_changeMap];
    [self.view addSubview:_changeMapBackground];
    
    [changeMapBlurView release];
    
    UIVisualEffectView *addPictureBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    addPictureBlurView.frame = CGRectMake(0, 0, 50, 50);
    addPictureBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    addPictureBlurView.layer.cornerRadius = 25.0f;
    addPictureBlurView.clipsToBounds = YES;
    
    _addPictureBackground = [[UIView alloc] initWithFrame:CGRectMake(_width+60, 210, 50, 50)];
    
    _addPictureBackground.backgroundColor = [UIColor clearColor];
    _addPictureBackground.layer.cornerRadius = 25.0f;
    
    _addPictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _addPictureButton.frame = CGRectMake(10, 10, 30, 30);
    [_addPictureButton setBackgroundImage:[UIImage imageNamed:@"camera_icon_white@3x.png"] forState:UIControlStateNormal];
    [_addPictureButton addTarget:self action:@selector(LoadCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    [_addPictureBackground addSubview:addPictureBlurView];
    [_addPictureBackground addSubview:_addPictureButton];
    [self.view addSubview:_addPictureBackground];
    
    _imageCountBackground = [[UIView alloc] initWithFrame:CGRectMake(_width-25, 205, 20, 20)];
    
    _imageCountBackground.backgroundColor = [UIColor colorWithRed:41.0f/255.0f green:127.0f/255.0f blue:199.0f/255.0f alpha:1.0f];
    _imageCountBackground.layer.cornerRadius = 10.0f;
    [_imageCountBackground setHidden:YES];
    
    _imageCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    _imageCount.textColor = [UIColor whiteColor];
    _imageCount.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    _imageCount.textAlignment = NSTextAlignmentCenter;
    _imageCount.text = @"5";
    
    [_imageCountBackground addSubview:_imageCount];
    [self.view addSubview:_imageCountBackground];
    
    [addPictureBlurView release];
    
    UIVisualEffectView *followTourBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    followTourBlurView.frame = CGRectMake(0, 0, _width-80, 52);
    followTourBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    followTourBlurView.layer.cornerRadius = 5.0f;
    followTourBlurView.clipsToBounds = YES;
    
    _followTourView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, _width-80, 52)];
    
    _followTourView.backgroundColor = [UIColor clearColor];
    _followTourView.layer.cornerRadius = 5.0f;
    
    _followTourTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, _width-90, 16)];
    
    _followTourTitle.textColor = [UIColor whiteColor];
    _followTourTitle.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _followTourTitle.text = @"Hinzugefügte Tour";
    
    float labelWidth = (_width-110)/3;
    
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
    
    _removeFollowTour.frame = CGRectMake(_width-105, 5, 20, 20);
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
    
    _didSetInitialLocation = false;
    
    _didRecoverTour = false;
    _writeRecoveryFile = false;
    
    _hasInitializedIcons = false;
    
    _startPointIsSet = false;
    
    data.addedNewTrack = false;
    
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
    [_FinishButton release];
    [_loginButton release];
    [_pollingTimer release];
    [login release];
    [summary release];
    [_GPSSignal release];
    [_StartButton release];
    [_ModusButton release];
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
    [_locationBackground release];
    [_locationBackground release];
    [_distanceTitleLabel release];
    [_altitudeTitleLabel release];
    [_HorizontalDevider release];
    [_VerticalDevider release];
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
            /*if (data.runStatus == 1) {up_icon = @"skier_up_button_inactive.png";}
            else {up_icon = @"skier_up_button v2.png";}
            if (data.runStatus == 3) {down_icon = @"skier_down_button_inactive.png";}
            else {down_icon = @"skier_down_button v2.png";}*/
            _up_button_icon = @"skier";
            _down_button_icon = @"skier";
            break;
        case 1:
            /*if (data.runStatus == 1) {up_icon = @"snowboarder_up_button_inactive.png";}
            else {up_icon = @"snowboarder_up_button.png";}
            if (data.runStatus == 3) {down_icon = @"snowboarder_down_button_inactive.png";}
            else {down_icon = @"snowboarder_down_button.png";}*/
            _up_button_icon = @"snowboarder";
            _down_button_icon = @"snowboarder";
            break;
        case 2:
            /*if (data.runStatus == 1) {up_icon = @"skier_up_button_inactive.png";}
            else {up_icon = @"skier_up_button v2.png";}
            if (data.runStatus == 3) {down_icon = @"snowboarder_down_button_inactive.png";}
            else {down_icon = @"snowboarder_down_button.png";}*/
            _up_button_icon = @"skier";
            _down_button_icon = @"snowboarder";
            break;
            
    }
    
    up_icon = [NSString stringWithFormat:@"%@_up_icon v2.png",_up_button_icon];
    down_icon = [NSString stringWithFormat:@"%@_down_icon v2.png",_down_button_icon];
    
    //[_StartButton setImage:[UIImage imageNamed:up_icon] forState:UIControlStateNormal];
    
    if (data.runModus == 0) {[_ModusButton setImage:[UIImage imageNamed:up_icon] forState:UIControlStateNormal];}
    else {[_ModusButton setImage:[UIImage imageNamed:down_icon] forState:UIControlStateNormal];}
    
    _mapView.myLocationEnabled = YES;
    
    //[_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self RedrawTracks];
    
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
            [_upLineView setHidden:NO];
            [_upLineLabel setHidden:NO];
            
            [_followTourView setAlpha:1.0];
            
            [_followTourView setHidden:NO];
        }
        
        if ([data.followTourInfo.tracks count] > 1) {
            [_downLineView setHidden:NO];
            [_downLineLabel setHidden:NO];
        }
    }
    else {
        [_followTourView setHidden:YES];
    }
    
    if (!_hasInitializedIcons) {
        [UIView animateWithDuration:0.2f delay:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
        _addWarningBackground.frame = CGRectMake(_width-60, 90, 50, 50);
        } completion:nil];
        
        [UIView animateWithDuration:0.2f delay:1.05f options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
        _changeMapBackground.frame = CGRectMake(_width-60, 150, 50, 50);
        } completion:nil];
        
        [UIView animateWithDuration:0.2f delay:1.1f options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
        _addPictureBackground.frame = CGRectMake(_width-60, 210, 50, 50);
        } completion:nil];
        
        _hasInitializedIcons = true;
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

- (IBAction)changeTourModus:(id)sender {
    if (data.runModus == 0) {data.runModus = 1;}
    else {data.runModus = 0;}
    
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
        [_ModusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
        [_FinishButton setImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        
        data.runStatus = 2;
        
        return;
    }
    
    if (data.runStatus == 0) {
        
    }
    else if (data.runStatus == 1) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        data.downCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
        
        data.runStatus = 3;
    }
    else if (data.runStatus == 2) {
        
    }
    else if (data.runStatus == 3) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        data.upCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
        
        data.runStatus = 1;
    }
    else if (data.runStatus == 4) {
        
    }
    
    //[_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
    //[_ModusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
    
    if (data.runModus == 0) {[_ModusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_icon v2.png",_up_button_icon]] forState:UIControlStateNormal];}
    else {[_ModusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_icon v2.png",_down_button_icon]] forState:UIControlStateNormal];}
    
    /*if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }*/
}

- (IBAction)startTour:(id)sender {
    if (data.runStatus == 0 || data.runStatus == 2 || data.runStatus == 4) {
        if (_didReachInitialAccuracy && data.loggedIn) {
            if (!_pollingTimer) {_pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];}
        }
        
        [self startLocationUpdate];
    }
    
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button_inactive.png",_up_button_icon]] forState:UIControlStateNormal];
        [_ModusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
        [_FinishButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
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
            
            alert.tag = 1;
            
            [alert show];
            [alert release];
            
            if (data.runModus == 0) {data.runStatus = 1;}
            else {data.runStatus = 2;}
            
            return;
        }
        data.startTime = [NSDate date];
        data.TotalStartTime = [NSDate date];
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyLLddHHmmss"];
        
        NSString *tourID = [[NSString alloc] initWithFormat:@"%@%@", [formatter stringFromDate:[NSDate date]], data.userID];
        
        data.tourID = tourID;
        
        if (data.runModus == 0) {data.upCount++; data.runStatus = 1;}
        else {data.downCount++; data.runStatus = 3;}
        
        [_mapView animateToZoom:15.0];
        
        [_StartButton setImage:[UIImage imageNamed:@"pause_button v3.png"] forState:UIControlStateNormal];
        
        [_FinishButton setHidden:NO];
        
        [formatter release];
        [tourID release];
    }
    else if (data.runStatus == 1) {
        [_pollingTimer invalidate];
        _pollingTimer = nil;
        
        [self stopLocationUpdate:NO];
        
        [_StartButton setImage:[UIImage imageNamed:@"start_button v3.png"] forState:UIControlStateNormal];
        
        data.runStatus = 2;
    }
    else if (data.runStatus == 2) {
        if (data.runModus == 0) {data.runStatus = 1;}
        else {
            data.endTime = [NSDate date];
            [data CreateXMLForCategory:@"up"];
            
            data.downCount++;
            [data ResetDataForNewRun];
            data.startTime = [NSDate date];
            
            data.runStatus = 3;
        }
        
        [_StartButton setImage:[UIImage imageNamed:@"pause_button v3.png"] forState:UIControlStateNormal];
    }
    else if (data.runStatus == 3) {
        [_pollingTimer invalidate];
        _pollingTimer = nil;
        
        [self stopLocationUpdate:NO];
        
        [_StartButton setImage:[UIImage imageNamed:@"start_button v3.png"] forState:UIControlStateNormal];
        
        data.runStatus = 4;
    }
    else if (data.runStatus == 4) {
        if (data.runModus == 1) {data.runStatus = 3;}
        else {
            data.endTime = [NSDate date];
            [data CreateXMLForCategory:@"down"];
            
            data.upCount++;
            [data ResetDataForNewRun];
            data.startTime = [NSDate date];
            
            data.runStatus = 1;
        }
        
        [_StartButton setImage:[UIImage imageNamed:@"pause_button v3.png"] forState:UIControlStateNormal];
    }
    
    //[_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button_inactive.png",_up_button_icon]] forState:UIControlStateNormal];
    //[_ModusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
    
    /*if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }*/
}

- (IBAction)finishTour:(id)sender {
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
        [_ModusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button_inactive.png",_down_button_icon]] forState:UIControlStateNormal];
        [_FinishButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        data.runStatus = 3;
        return;
    }
    
    if (data.runStatus == 0) {

    }
    else if (data.runStatus == 1) {
        [_pollingTimer invalidate];
        _pollingTimer = nil;
        
        [self stopLocationUpdate:NO];
        
        data.endTime = [NSDate date];
        data.TotalEndTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        if (!summary) {summary = [[XTSummaryViewController alloc] initWithNibName:nil bundle:nil];}
        [self presentViewController:summary animated:YES completion:nil];
        
        [summary release];
        summary = nil;
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
        [_pollingTimer invalidate];
        _pollingTimer = nil;
        
        [self stopLocationUpdate:NO];
        
        data.endTime = [NSDate date];
        data.TotalEndTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        if (!summary) {summary = [[XTSummaryViewController alloc] initWithNibName:nil bundle:nil];}
        [self presentViewController:summary animated:YES completion:nil];
        
        [summary release];
        summary = nil;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResetTour) name:@"SummaryViewDismissed" object:nil];
    
    //[_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
    //[_ModusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button_inactive.png",_down_button_icon]] forState:UIControlStateNormal];
    
    /*if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }*/
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
        
        NSString *r_dist_str;
        if (data.DistanceRate >= 10) {r_dist_str = [NSString stringWithFormat:@"%.0f km/h", data.DistanceRate];}
        else {r_dist_str = [NSString stringWithFormat:@"%.1f km/h", data.DistanceRate];}
        
        NSString *r_alt_str;
        if (data.AltitudeRate > 1000) {r_alt_str = [NSString stringWithFormat:@"%.1f km/h", data.AltitudeRate*1000];}
        else {r_alt_str = [NSString stringWithFormat:@"%.0f m/h", data.AltitudeRate];}
        
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
    
    [_totalTimeLabel setHidden:YES];
    [_totalDistanceLabel setHidden:YES];
    [_totalAltitudeLabel setHidden:YES];
    
    data.runStatus = 0;
    
    _startPointIsSet = false;
    
    [_imageCountBackground setHidden:YES];
    
    [_mapView clear];
    
    [_followTourView setHidden:YES];
    
    data.followTourInfo = nil;
    
    [self RedrawTracks];
    
    [_StartButton setImage:[UIImage imageNamed:@"start_button v3.png"] forState:UIControlStateNormal];
    
    [_FinishButton setHidden:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
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
                
                //[_StartButton setImage:[UIImage imageNamed:@"skier_up_button_inactive.png"] forState:UIControlStateNormal];
            }
            else {
                data.downCount++;
                
                //[_ModusButton setImage:[UIImage imageNamed:@"skier_down_button_inactive.png"] forState:UIControlStateNormal];
            }
            
            [_mapView animateToZoom:15.0];
            
            [_StartButton setImage:[UIImage imageNamed:@"pause_button v3.png"] forState:UIControlStateNormal];
            
            [_FinishButton setHidden:NO];
            
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
    
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            if (data.runStatus == 1) {
                data.endTime = [NSDate date];
                [data CreateXMLForCategory:@"up"];
                
                data.downCount++;
                [data ResetDataForNewRun];
                data.startTime = [NSDate date];
                
                data.runStatus = 3;
                
                [_StartButton setHidden:YES];
                [_ModusButton setHidden:NO];
            }
            else if (data.runStatus == 3) {
                data.endTime = [NSDate date];
                [data CreateXMLForCategory:@"down"];
                
                data.upCount++;
                [data ResetDataForNewRun];
                data.startTime = [NSDate date];
                
                data.runStatus = 1;
                
                [_StartButton setHidden:NO];
                [_ModusButton setHidden:YES];
            }
        }
    }
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
    
    if (!_didSetInitialLocation) {
        [self UpdateMap:Location];
        
        _didSetInitialLocation = true;
    }
    
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
            
            [self UpdateMap:Location];
            
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
                    
                    for (int i = 0; i < [warningsArray count]; i++) {
                        GMSMarker *warningMarker = [[GMSMarker alloc] init];
                        
                        XTWarningsInfo *currentInfo = [warningsArray objectAtIndex:i];
                        
                        NSString *warningTitle;
                        switch (currentInfo.category) {
                            case 0:
                                warningTitle = @"Lawinenabgang";
                                break;
                            case 1:
                                warningTitle = @"Instabile Unterlage";
                                break;
                            case 2:
                                warningTitle = @"Spalten";
                                break;
                            case 3:
                                warningTitle = @"@Steinschlag";
                                break;
                            case 4:
                                warningTitle = @"Gefahrenstelle";
                                break;
                        }
                        
                        warningMarker.position = CLLocationCoordinate2DMake(currentInfo.latitude, currentInfo.longitude);
                        warningMarker.icon = [UIImage imageNamed:@"ski_pole_warning@3x.png"];
                        warningMarker.groundAnchor = CGPointMake(0.88, 1.0);
                        warningMarker.appearAnimation = kGMSMarkerAnimationPop;
                        warningMarker.title = warningTitle;
                        warningMarker.map = _mapView;
                    }
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
        
        if (data.addedNewTrack) {
            [self RedrawTracks];
            
            GMSMarker *startPoint = [[GMSMarker alloc] init];
            
            startPoint.position = location.coordinate;
            startPoint.icon = [UIImage imageNamed:@"markerIcon_gray@3x.png"];
            startPoint.groundAnchor = CGPointMake(0.5,0.5);
            startPoint.map = _mapView;
            
            [startPoint release];
            
            data.addedNewTrack = false;
        }
        
        NSUInteger coordinateSize = [[data GetCoordinatesForCurrentRun] count];
        NSUInteger pathSize = [_path count];
        
        if (_lastRunStatus == 0) {_lastRunStatus = data.runStatus;}
        
        if (!_startPointIsSet && data.runStatus != 0) {
            GMSMarker *startPoint = [[GMSMarker alloc] init];
            
            startPoint.position = location.coordinate;
            startPoint.icon = [UIImage imageNamed:@"markerIcon_green@3x.png"];
            startPoint.groundAnchor = CGPointMake(0.5,0.5);
            startPoint.map = _mapView;
            
            [startPoint release];
            
            _startPointIsSet = true;
        }
        
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
            
            if (data.runModus == 0) {_polyline.strokeColor = [UIColor colorWithRed:41.0f/255.0f green:127.0f/255.0f blue:199.0f/255.0f alpha:1.0f];}
            else {_polyline.strokeColor = [UIColor colorWithRed:199.0f/255.0f green:74.0f/255.0f blue:41.0f/255.0f alpha:1.0f];}
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

- (void)RedrawTracks
{
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
    
    [_mapView animateToLocation:CLLocationCoordinate2DMake(data.CurrentLocation.coordinate.latitude, data.CurrentLocation.coordinate.longitude)];
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
        _addWarningBackground.frame = CGRectMake(10, addWarningBackgroundFrame.origin.y, _width-20, 50);
        _addWarningButton.frame = CGRectMake(_width-60, 10, 30, 30);
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
            _addWarningBackground.frame = CGRectMake(_width-60, addWarningBackgroundFrame.origin.y, 50, 50);
            _addWarningButton.frame = CGRectMake(10, 10, 30, 30);
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
    
    [self RedrawTracks];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        [_followTourView setAlpha:0.0];
        
        [_followTourView setHidden:YES];
    } completion:NULL];
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
    
    _imageCount.text = [NSString stringWithFormat:@"%lu",[data GetNumImages]+1];
    
    if ([data GetNumImages]+1 > 9) {
        _imageCountBackground.frame = CGRectMake(_width-32, _imageCountBackground.frame.origin.y, 30, 20);
        
        _imageCount.frame = CGRectMake(0, 0, 30, 20);
        
        if ([data GetNumImages]+1 > 10) {_imageCount.text = @"10+";}
    }
    
    [_imageCountBackground setHidden:NO];
    
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
            
            GMSMarker *marker = [GMSMarker markerWithPosition:location.coordinate];
            marker.icon = [UIImage imageNamed:@"ski_pole_camera@3x.png"];
            marker.map = _mapView;
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

/*- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (UIEventSubtypeMotionShake) {
        NSString *messageTitle;
        NSString *message;
        
        if (data.runStatus == 1) {
            messageTitle = @"Hey";
            message = @"Möchtest du auf Abfahrt wechseln?";
        }
        
        if (data.runStatus == 3) {
            messageTitle = @"Hey";
            message = @"Möchtest du auf Aufstieg wechseln?";
        }
        
        if (data.runStatus == 1 || data.runStatus == 3) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:messageTitle message:message delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
            
            alert.tag = 2;
            
            [alert show];
            [alert release];
        }
    }
}*/

@end

//
//  XTTourDetailView.m
//  XTour
//
//  Created by Manuel Weber on 02/05/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTTourDetailView.h"

@implementation XTTourDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) Initialize:(XTTourInfo *) tourInfo fromServer:(BOOL)server withOffset:(NSInteger)offset andContentOffset:(NSInteger)offsetContent
{
    data = [XTDataSingleton singleObj];
    
    _currentTourID = tourInfo.tourID;
    
    _viewOffset = 0;
    if (offset) {_viewOffset = offset;}
    
    _viewContentOffset = 0;
    if (offsetContent) {_viewContentOffset = offsetContent;}
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    //float height = screenBound.size.height;
    
    float boxWidth = width - 20;
    float boxRadius = 5.f;
    float boxBorderWidth = 1.0f;
    float boxMarginLeft = 10.0f;
    //float boxMarginTop = 75.0f;
    UIColor *boxBorderColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    float boxYPosition = 5;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.770809 longitude:8.377733 zoom:6];
    if (!mapView) {mapView = [GMSMapView mapWithFrame:CGRectMake(5, 5, boxWidth - 10, 240) camera:camera];}
    
    mapView.mapType = kGMSTypeTerrain;
    
    _mountainPeakViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition, boxWidth, 60)];
    
    _mountainPeakExtendedView = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition+55, boxWidth, 0)];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurEffectView.frame = CGRectMake(0, 0, boxWidth, 0);
    _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [_mountainPeakExtendedView addSubview:_blurEffectView];
    
    _mountainPeakMoreView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, boxWidth-10, 240) style:UITableViewStyleGrouped];
    
    _mountainPeakMoreView.rowHeight = 40.0;
    _mountainPeakMoreView.sectionHeaderHeight = 30.0;
    _mountainPeakMoreView.sectionFooterHeight = 1.0;
    _mountainPeakMoreView.backgroundColor = [UIColor clearColor];
    _mountainPeakMoreView.scrollEnabled = YES;
    _mountainPeakMoreView.showsVerticalScrollIndicator = YES;
    _mountainPeakMoreView.userInteractionEnabled = YES;
    _mountainPeakMoreView.bounces = YES;
    _mountainPeakMoreView.delegate = self;
    _mountainPeakMoreView.dataSource = self;
    
    [_mountainPeakExtendedView addSubview:_mountainPeakMoreView];
    
    [_mountainPeakMoreView setHidden:YES];
    
    //_morePeaks = [[NSMutableArray alloc] init];
    
    _MountainPeakMore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _MountainPeakMore.frame = CGRectMake(boxWidth-30, 10, 20, 15);
    [_MountainPeakMore setBackgroundImage:[UIImage imageNamed:@"arrow_more@3x.png"] forState:UIControlStateNormal];
    [_MountainPeakMore addTarget:self action:@selector(ShowMorePeaks:) forControlEvents:UIControlEventTouchUpInside];
    
    _MountainPeakIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    
    [_MountainPeakIcon setImage:[UIImage imageNamed:@"peak_finder_icon@3x.png"]];
    
    _MountainPeakTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, boxWidth-100, 15)];
    _MountainPeakCoordinatesLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, boxWidth-100, 12)];
    _MountainPeakAltitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 22, boxWidth-100, 16)];
    
    _MountainPeakTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    _MountainPeakCoordinatesLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    _MountainPeakAltitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    
    _MountainPeakTitleLabel.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
    _MountainPeakCoordinatesLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _MountainPeakAltitudeLabel.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
    
    _noPeakFoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, boxWidth-100, 20)];
    
    _noPeakFoundLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    _noPeakFoundLabel.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
    _noPeakFoundLabel.text = @"Kein Gipfel gefunden";
    
    [_noPeakFoundLabel setHidden:YES];
    
    [_mountainPeakExtendedView setHidden:YES];
    
    [_mountainPeakViewContainer addSubview:_MountainPeakIcon];
    [_mountainPeakViewContainer addSubview:_MountainPeakMore];
    [_mountainPeakViewContainer addSubview:_MountainPeakTitleLabel];
    [_mountainPeakViewContainer addSubview:_MountainPeakCoordinatesLabel];
    [_mountainPeakViewContainer addSubview:_MountainPeakAltitudeLabel];
    [_mountainPeakViewContainer addSubview:_noPeakFoundLabel];
    
    if (!server) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            XTPeakFinder *peakFinder = [[[XTPeakFinder alloc] init] autorelease];
            
            _MountainPeakTitleLabel.text = @"Suche Gipfel...";
            
            [peakFinder FindPeakAtLongitude:data.highestPoint.coordinate.longitude latitude:data.highestPoint.coordinate.latitude country:@"Switzerland"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *peak = [peakFinder GetPeak];
                _morePeaks = [peakFinder GetAlternativePeaks];
                
                if (peak) {
                    float longitude = [[peak objectAtIndex:1] floatValue];
                    NSString *lonEW;
                    if (longitude < 0) {lonEW = @"W"; longitude = fabs(longitude);}
                    else {lonEW = @"E";}
                    
                    float latitude = [[peak objectAtIndex:2] floatValue];
                    NSString *latNS;
                    if (latitude < 0) {latNS = @"S"; latitude = fabs(latitude);}
                    else {latNS = @"N";}
                    
                    NSString *lonString = [NSString stringWithFormat:@"%.0f°%.0f'%.0f\" %s",
                                           floor(longitude),
                                           floor((longitude - floor(longitude)) * 60),
                                           ((longitude - floor(longitude)) * 60 - floor((longitude - floor(longitude)) * 60)) * 60, [lonEW UTF8String]];
                    NSString *latString = [NSString stringWithFormat:@"%.0f°%.0f'%.0f\" %s",
                                           floor(latitude),
                                           floor((latitude - floor(latitude)) * 60),
                                           ((latitude - floor(latitude)) * 60 - floor((latitude - floor(latitude)) * 60)) * 60, [latNS UTF8String]];
                    
                    _MountainPeakTitleLabel.text = @"Dieser Gipfel wurde gefunden";
                    _MountainPeakAltitudeLabel.text = [NSString stringWithFormat:@"%@, %.0fm", [peak objectAtIndex:0], [[peak objectAtIndex:3] floatValue]];
                    _MountainPeakCoordinatesLabel.text = [NSString stringWithFormat:@"%@ %@", lonString, latString];
                    
                    _mountainPeak = [peak objectAtIndex:0];
                }
                else {
                    [_noPeakFoundLabel setHidden:NO];
                    
                    _MountainPeakTitleLabel.text = @"";
                    
                    _mountainPeak = @"";
                }
                
                [self.mountainPeakMoreView reloadData];
            });
        });
        
        boxYPosition += 65;
    }
    
    _summaryViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition, boxWidth, 140)];
    
    boxYPosition += 145;
    
    _mapViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition, boxWidth, 250)];
    
    boxYPosition += 255;
    
    if (server) {
        _graphViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition, boxWidth, width/320*200+10)];
        
        boxYPosition += width/320*200+15;
    }
    
    _imageViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition, boxWidth, 200)];
    
    boxYPosition += 205;
    
    _descriptionViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition, boxWidth, 200)];
    
    boxYPosition += 205;
    
    _noImagesViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset + boxYPosition - 410, boxWidth, 50)];
    
    _noDescriptionViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset + boxYPosition - 205, boxWidth, 50)];
    
    UIImageView *cameraImage = [[UIImageView alloc] initWithFrame:CGRectMake(boxWidth/2-15, 0, 30, 30)];
    
    [cameraImage setImage:[UIImage imageNamed:@"camera_icon_gray@3x.png"]];
    
    UILabel *noImagesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, boxWidth, 15)];
    
    noImagesLabel.text = @"Keine Bilder zu dieser Tour";
    noImagesLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    noImagesLabel.textColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1.0f];
    noImagesLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *editImage = [[UIImageView alloc] initWithFrame:CGRectMake(boxWidth/2-10, 0, 20, 20)];
    
    [editImage setImage:[UIImage imageNamed:@"edit_icon_gray@3x.png"]];
    
    UILabel *noDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, boxWidth, 15)];
    
    noDescriptionLabel.text = @"Keine Beschreibung zu dieser Tour";
    noDescriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    noDescriptionLabel.textColor = [UIColor colorWithRed:164.0f/255.0f green:164.0f/255.0f blue:164.0f/255.0f alpha:1.0f];
    noDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    
    [_noImagesViewContainer setHidden:YES];
    
    [_noDescriptionViewContainer setHidden:YES];
    
    [_noImagesViewContainer addSubview:cameraImage];
    [_noImagesViewContainer addSubview:noImagesLabel];
    [_noDescriptionViewContainer addSubview:editImage];
    [_noDescriptionViewContainer addSubview:noDescriptionLabel];
    
    [cameraImage release];
    [noImagesLabel release];
    [editImage release];
    [noDescriptionLabel release];
    
    _mountainPeakViewContainer.backgroundColor = [UIColor whiteColor];
    _mountainPeakExtendedView.backgroundColor = [UIColor clearColor];
    _mapViewContainer.backgroundColor = [UIColor whiteColor];
    _summaryViewContainer.backgroundColor = [UIColor whiteColor];
    _imageViewContainer.backgroundColor = [UIColor whiteColor];
    _descriptionViewContainer.backgroundColor = [UIColor whiteColor];
    _graphViewContainer.backgroundColor = [UIColor whiteColor];
    
    _mountainPeakViewContainer.layer.cornerRadius = boxRadius;
    _mapViewContainer.layer.cornerRadius = boxRadius;
    _summaryViewContainer.layer.cornerRadius = boxRadius;
    _imageViewContainer.layer.cornerRadius = boxRadius;
    _descriptionViewContainer.layer.cornerRadius = boxRadius;
    _graphViewContainer.layer.cornerRadius = boxRadius;
    
    _mountainPeakViewContainer.layer.borderWidth = boxBorderWidth;
    _mountainPeakExtendedView.layer.borderWidth = boxBorderWidth;
    _mapViewContainer.layer.borderWidth = boxBorderWidth;
    _summaryViewContainer.layer.borderWidth = boxBorderWidth;
    _imageViewContainer.layer.borderWidth = boxBorderWidth;
    _descriptionViewContainer.layer.borderWidth = boxBorderWidth;
    _graphViewContainer.layer.borderWidth = boxBorderWidth;
    
    _mountainPeakViewContainer.layer.borderColor = boxBorderColor.CGColor;
    _mountainPeakExtendedView.layer.borderColor = boxBorderColor.CGColor;
    _mapViewContainer.layer.borderColor = boxBorderColor.CGColor;
    _summaryViewContainer.layer.borderColor = boxBorderColor.CGColor;
    _imageViewContainer.layer.borderColor = boxBorderColor.CGColor;
    _descriptionViewContainer.layer.borderColor = boxBorderColor.CGColor;
    _graphViewContainer.layer.borderColor = boxBorderColor.CGColor;
    
    /*NSString *TimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
     lround(floor(data.totalTime / 3600.)) % 100,
     lround(floor(data.totalTime / 60.)) % 60,
     lround(floor(data.totalTime)) % 60];*/
    
    _profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    
    if (server) {
    [_profilePicture setImageWithURL:[NSURL URLWithString:tourInfo.profilePicture] placeholderImage:[UIImage imageNamed:@"profile_icon_gray.png"]];
    }
    else {
        _profilePicture.image = [UIImage imageNamed:tourInfo.profilePicture];
    }
    
    float labelX1 = 5;
    float labelX2 = (boxWidth-10)/3;
    float labelX3 = (boxWidth-10)*2/3;
    
    _TimeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 17, 94, 21)];
    _DistanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 58, 100, 15)];
    _SpeedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 58, 100, 15)];
    _UpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 58, 100, 15)];
    _DownTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 100, 100, 15)];
    _HighestPointTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 100, 100, 15)];
    _LowestPointTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 100, 100, 15)];
    
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(boxWidth/3-10, 15, boxWidth*2/3-10, 30)];
    _DistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 72, 100, 20)];
    _SpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 72, 100, 20)];
    _UpLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 72, 100, 20)];
    _DownLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 114, 100, 20)];
    _HighestPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 114, 100, 20)];
    _LowestPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 114, 100, 20)];
    
    _TimeTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _DistanceTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _SpeedTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _UpTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _DownTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _HighestPointTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _LowestPointTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    
    _TimeLabel.textAlignment = NSTextAlignmentRight;
    
    _TimeTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _DistanceTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _SpeedTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _UpTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _DownTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _HighestPointTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _LowestPointTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    
    _TimeLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*32.0f];
    _DistanceLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _SpeedLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _UpLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _DownLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _HighestPointLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _LowestPointLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    
    _TimeTitleLabel.text = @"Time";
    _DistanceTitleLabel.text = @"Distanz";
    _SpeedTitleLabel.text = @"Geschwindigkeit";
    _UpTitleLabel.text = @"Aufstieg";
    _DownTitleLabel.text = @"Abfahrt";
    _HighestPointTitleLabel.text = @"Höchster Punkt";
    _LowestPointTitleLabel.text = @"Tiefster Punkt";
    
    NSUInteger tm = tourInfo.totalTime;
    
    NSString *TimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                            lround(floor(tm / 3600.)) % 100,
                            lround(floor(tm / 60.)) % 60,
                            lround(floor(tm)) % 60];
    
    float distance = tourInfo.distance;
    float time = (float)tourInfo.totalTime/3600.0;
    float speed = distance/time;
    
    NSString *distanceUnit = @"km";
    NSString *speedUnit = @"km/h";
    
    if (distance < 10.0) {
        distance *= 1000.0;
        distanceUnit = @"m";
    }
    
    if (speed < 10.0) {
        speed *= 1000.0;
        speedUnit = @"m/h";
    }
    
    _TimeLabel.text = TimeString;
    _DistanceLabel.text = [NSString stringWithFormat:@"%.1f %@", distance, distanceUnit];
    _SpeedLabel.text = [NSString stringWithFormat:@"%.1f %@", speed, speedUnit];
    _UpLabel.text = [NSString stringWithFormat:@"%.1f m", tourInfo.altitude];
    _DownLabel.text = [NSString stringWithFormat:@"%.1f m", tourInfo.descent];
    _HighestPointLabel.text = [NSString stringWithFormat:@"%.1f m", tourInfo.highestPoint];
    _LowestPointLabel.text = [NSString stringWithFormat:@"%.1f m", tourInfo.lowestPoint];
    
    _descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, boxWidth-10, 190)];
    
    _descriptionView.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _descriptionView.font = [UIFont fontWithName:@"Helvetica" size:16];
    
    _hasDescription = false;
    if ([tourInfo.tourDescription isEqualToString:@""] && server) {_descriptionView.text = @"Keine Bechreibung zu dieser Tour vorhanden.";}
    else if ([tourInfo.tourDescription isEqualToString:@""]) {_descriptionView.text = @"Kurze Beschreibung zur Tour";}
    else {_descriptionView.text = tourInfo.tourDescription; _hasDescription = true;}
    
    if (server) {_descriptionView.editable = NO;}
    else {_descriptionView.editable = YES;}
    
    /*[_TimeLabel setText:TimeString];
     [_AltitudeLabel setText:[NSString stringWithFormat:@"%.1f km",data.sumDistance]];
     [_UpLabel setText:[NSString stringWithFormat:@"%.1f m",data.sumAltitude]];
     [_DownLabel setText:[NSString stringWithFormat:@"%.1f m",data.sumDescent]];*/
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(105, 75, 100, 100)];
    _loadingView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6];
    _loadingView.layer.cornerRadius = 10.0f;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.frame = CGRectMake(20, 20, 60, 60);
    [_activityView startAnimating];
    
    [_loadingView addSubview:_activityView];
    
    [_mapViewContainer addSubview:mapView];
    [_mapViewContainer addSubview:_loadingView];
    [_summaryViewContainer addSubview:_profilePicture];
    //[_summaryViewContainer addSubview:_TimeTitleLabel];
    [_summaryViewContainer addSubview:_DistanceTitleLabel];
    [_summaryViewContainer addSubview:_SpeedTitleLabel];
    [_summaryViewContainer addSubview:_UpTitleLabel];
    [_summaryViewContainer addSubview:_DownTitleLabel];
    [_summaryViewContainer addSubview:_HighestPointTitleLabel];
    [_summaryViewContainer addSubview:_LowestPointTitleLabel];
    [_summaryViewContainer addSubview:_TimeLabel];
    [_summaryViewContainer addSubview:_DistanceLabel];
    [_summaryViewContainer addSubview:_SpeedLabel];
    [_summaryViewContainer addSubview:_UpLabel];
    [_summaryViewContainer addSubview:_DownLabel];
    [_summaryViewContainer addSubview:_HighestPointLabel];
    [_summaryViewContainer addSubview:_LowestPointLabel];
    [_descriptionViewContainer addSubview:_descriptionView];
    if (server && !_hasDescription) {
        [_descriptionViewContainer setHidden:YES];
        
        [_noDescriptionViewContainer setHidden:NO];
        
        boxYPosition -= 155;
    }
    
    if (!server) {[self addSubview:_mountainPeakViewContainer];}
    [self addSubview:_mapViewContainer];
    [self addSubview:_summaryViewContainer];
    [self addSubview:_imageViewContainer];
    [self addSubview:_descriptionViewContainer];
    [self addSubview:_noImagesViewContainer];
    [self addSubview:_noDescriptionViewContainer];
    if (server) {[self addSubview:_graphViewContainer];}
    if (!server) {[self addSubview:_mountainPeakExtendedView];}
    
    if (server) {self.contentSize = CGSizeMake(width, _viewOffset+boxYPosition+_viewContentOffset);}
    else {self.contentSize = CGSizeMake(width, _viewOffset+boxYPosition);}
    
    _didSelectRow = false;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc {
    [_coordinateArray release];
    [_tourImages release];
    [_tourFiles release];
    [_loadingView release];
    [_activityView release];
    [_mountainPeakViewContainer release];
    [_mapViewContainer release];
    [_summaryViewContainer release];
    [_imageViewContainer release];
    [_descriptionViewContainer release];
    [_graphViewContainer release];
    [_descriptionView release];
    [_profilePicture release];
    [_TimeTitleLabel release];
    [_DistanceTitleLabel release];
    [_SpeedTitleLabel release];
    [_UpTitleLabel release];
    [_DownTitleLabel release];
    [_HighestPointTitleLabel release];
    [_LowestPointTitleLabel release];
    [_UpRateTitleLabel release];
    [_DownRateTitleLabel release];
    [_TimeLabel release];
    [_DistanceLabel release];
    [_SpeedLabel release];
    [_UpLabel release];
    [_DownLabel release];
    [_HighestPointLabel release];
    [_LowestPointLabel release];
    [_UpRateLabel release];
    [_DownRateLabel release];
    if (_enterCommentTextView) {[_enterCommentTextView release];}
    if (_enterCommentTitle) {[_enterCommentTitle release];}
    [super dealloc];
}

- (void) LoadTourDetail:(XTTourInfo *) tourInfo fromServer:(BOOL) server
{
    //CGRect screenBound = [[UIScreen mainScreen] bounds];
    //float width = screenBound.size.width;
    //float boxWidth = width - 20;
    
    _tourFiles = [[NSMutableArray alloc] init];
    _coordinateArray = [[NSMutableArray alloc] init];
    
    if (server) {
        NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_tour_coordinates_string.php?tid=%@", tourInfo.tourID];
        NSURL *url = [NSURL URLWithString:requestString];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        sessionConfiguration.timeoutIntervalForRequest = 10.0;
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message: @"Da ist etwas schief gelaufen. Stelle sicher, dass du Verbindung zum Internet hast." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
                [_loadingView removeFromSuperview];
                
                return;
            }
            
            XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
            
            [request ProcessTourCoordinates:(NSData*)responseData];
            
            _tourFiles = request.tourFilesType;
            _coordinateArray = request.tourFilesCoordinates;
            
            NSString *requestString2 = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_start_stop_coordinates_string.php?tid=%@", tourInfo.tourID];
            NSURL *url2 = [NSURL URLWithString:requestString2];
            
            NSURLSession *session2 = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
            
            NSURLSessionTask *sessionTask2 = [session2 dataTaskWithRequest:[NSURLRequest requestWithURL:url2] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
                XTServerRequestHandler *request2 = [[[XTServerRequestHandler alloc] init] autorelease];
                
                _startStopCoordinates = [request2 GetStartStopCoordinates:(NSData*)responseData];
                
                NSString *requestString3 = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_tour_images_string.php?tid=%@", tourInfo.tourID];
                NSURL *url3 = [NSURL URLWithString:requestString3];
                
                NSURLSession *session3 = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
                
                NSURLSessionTask *sessionTask3 = [session3 dataTaskWithRequest:[NSURLRequest requestWithURL:url3] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
                    XTServerRequestHandler *request3 = [[[XTServerRequestHandler alloc] init] autorelease];
                    
                    _tourImages = [request3 GetImagesForTour:(NSData*)responseData];
                    
                    NSString *requestString4 = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_comments_string.php?tid=%@", tourInfo.tourID];
                    NSURL *url4 = [NSURL URLWithString:requestString4];
                    
                    NSURLSession *session4 = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
                    
                    NSURLSessionTask *sessionTask4 = [session4 dataTaskWithRequest:[NSURLRequest requestWithURL:url4] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
                        XTServerRequestHandler *request4 = [[[XTServerRequestHandler alloc] init] autorelease];
                        
                        _tourComments = [request4 GetUserCommentsForTour:(NSData*)responseData];
                        
                        [self UpdateView:tourInfo fromServer:server];
                    }];
                    
                    [sessionTask4 resume];
                
                }];
                
                [sessionTask3 resume];
                
            }];
            
            [sessionTask2 resume];
            
            [request CheckGraphsForTour:tourInfo.tourID];
        
        }];
        
        [sessionTask resume];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _tourFiles = [data GetGPXFilesForCurrentTour];
            
            XTXMLParser *xml = [[[XTXMLParser alloc] init] autorelease];
            
            for (int i = 0; i < [_tourFiles count]; i++) {
                NSString *currentFile = [_tourFiles objectAtIndex:i];
                
                [xml ReadGPXFile:currentFile];
                
                NSMutableArray *locationData = [xml GetLocationDataFromFile];
                [_coordinateArray addObject:locationData];
            }
            
            _tourImages = data.imageInfo;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self UpdateView:tourInfo fromServer:server];
            });
        });
    }
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (server) {
            XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
            NSMutableArray *tourFilesUp = [request GetTourFilesForTour:tourInfo.tourID andType:@"up"];
            NSMutableArray *tourFilesDown = [request GetTourFilesForTour:tourInfo.tourID andType:@"down"];
            _tourFiles = [tourFilesUp mutableCopy];
            [_tourFiles addObjectsFromArray:tourFilesDown];
            
            for (int i = 0; i < [_tourFiles count]; i++) {
                NSString *currentFile = [_tourFiles objectAtIndex:i];
                
                NSMutableArray *currentCoordinates = [request GetCoordinatesForFile:currentFile];
                [_coordinateArray addObject:currentCoordinates];
            }
            
            _tourImages = [request GetImagesForTour:tourInfo.tourID];
            
            [request CheckGraphsForTour:tourInfo.tourID];
        }
        else {
            data = [XTDataSingleton singleObj];
            
            _tourFiles = [data GetGPXFilesForCurrentTour];
            
            XTXMLParser *xml = [[[XTXMLParser alloc] init] autorelease];
            
            for (int i = 0; i < [_tourFiles count]; i++) {
                NSString *currentFile = [_tourFiles objectAtIndex:i];
                
                [xml ReadGPXFile:currentFile];
                
                NSMutableArray *locationData = [xml GetLocationDataFromFile];
                [_coordinateArray addObject:locationData];
            }
            
            _tourImages = data.imageInfo;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            float minLon = 1e6;
            float maxLon = -1e6;
            float minLat = 1e6;
            float maxLat = -1e6;
            
            GMSMutablePath *currentPath = [[GMSMutablePath alloc] init];
            NSMutableArray *polylines = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [_coordinateArray count]; i++) {
                [currentPath removeAllCoordinates];
                
                NSMutableArray *coordinate = [_coordinateArray objectAtIndex:i];
                
                for (int k = 0; k < [coordinate count]; k++) {
                    CLLocation *location = [coordinate objectAtIndex:k];
                    [currentPath addCoordinate:location.coordinate];
                    
                    if (location.coordinate.longitude < minLon) {minLon = location.coordinate.longitude;}
                    if (location.coordinate.longitude > maxLon) {maxLon = location.coordinate.longitude;}
                    if (location.coordinate.latitude < minLat) {minLat = location.coordinate.latitude;}
                    if (location.coordinate.latitude > maxLat) {maxLat = location.coordinate.latitude;}
                }
                
                GMSPolyline *polyline = [[GMSPolyline alloc] init];
                [polyline setPath:currentPath];
                if ([[_tourFiles objectAtIndex:i] containsString:@"up"]) {polyline.strokeColor = [UIColor blueColor];}
                else {polyline.strokeColor = [UIColor redColor];}
                polyline.strokeWidth = 5.f;
                
                [polylines addObject:polyline];
                GMSPolyline *currentPolyline = [polylines objectAtIndex:i];
                
                currentPolyline.map = mapView;
            }
            
            GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:[[GMSCoordinateBounds alloc]initWithCoordinate:CLLocationCoordinate2DMake(minLat, minLon) coordinate:CLLocationCoordinate2DMake(maxLat, maxLon)] withPadding:50.0f];
            [mapView moveCamera:cameraUpdate];
            
            [_loadingView removeFromSuperview];
            
            XTSummaryImageViewController *imageView = [[XTSummaryImageViewController alloc] initWithNibName:nil bundle:nil];
            
            imageView.view.frame = CGRectMake(0, 0, boxWidth, 200);
            imageView.images = _tourImages;
            
            [_imageViewContainer addSubview:imageView.view];
            
            XTGraphPageViewController *graphPageController = [[XTGraphPageViewController alloc] initWithNibName:nil bundle:nil andTourInfo:tourInfo];
            
            graphPageController.view.frame = CGRectMake(5, 5, boxWidth-10, width/320*200);
            graphPageController.pageController.view.frame = CGRectMake(0, 0, boxWidth-10, width/320*200);
            
            [_graphViewContainer addSubview:graphPageController.view];
        });
    });*/
}

- (void) UpdateView:(XTTourInfo*)tourInfo fromServer:(BOOL)server
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float boxWidth = width - 20;
    float boxRadius = 5.f;
    float boxBorderWidth = 1.0f;
    float boxMarginLeft = 10.0f;
    UIColor *boxBorderColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    float minLon = 1e6;
    float maxLon = -1e6;
    float minLat = 1e6;
    float maxLat = -1e6;
    
    GMSMutablePath *currentPath = [[GMSMutablePath alloc] init];
    NSMutableArray *polylines = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_coordinateArray count]; i++) {
        [currentPath removeAllCoordinates];
        
        NSMutableArray *coordinate = [_coordinateArray objectAtIndex:i];
        
        for (int k = 0; k < [coordinate count]; k++) {
            CLLocation *location = [coordinate objectAtIndex:k];
            [currentPath addCoordinate:location.coordinate];
            
            if (location.coordinate.longitude < minLon) {minLon = location.coordinate.longitude;}
            if (location.coordinate.longitude > maxLon) {maxLon = location.coordinate.longitude;}
            if (location.coordinate.latitude < minLat) {minLat = location.coordinate.latitude;}
            if (location.coordinate.latitude > maxLat) {maxLat = location.coordinate.latitude;}
        }
        
        GMSPolyline *polyline = [[GMSPolyline alloc] init];
        [polyline setPath:currentPath];
        if ([[_tourFiles objectAtIndex:i] containsString:@"up"]) {polyline.strokeColor = [UIColor colorWithRed:41.0f/255.0f green:127.0f/255.0f blue:199.0f/255.0f alpha:1.0f];}
        else {polyline.strokeColor = [UIColor colorWithRed:199.0f/255.0f green:74.0F/255.0f blue:41.0f/255.0f alpha:1.0f];}
        polyline.strokeWidth = 3.f;
        
        [polylines addObject:polyline];
        GMSPolyline *currentPolyline = [polylines objectAtIndex:i];
        
        currentPolyline.map = mapView;
    }
    
    NSMutableArray *startStopMarkerCoordinates;
    
    if (server) {startStopMarkerCoordinates = [[_startStopCoordinates mutableCopy] autorelease];}
    else {startStopMarkerCoordinates = [[data.segmentCoordinates mutableCopy] autorelease];}
    
    for (int i = 0; i < [startStopMarkerCoordinates count]; i++) {
        GMSMarker *startPoint = [[GMSMarker alloc] init];
        
        CLLocation *segmentLocation = [startStopMarkerCoordinates objectAtIndex:i];
        
        if (i==0) {
            startPoint.position = CLLocationCoordinate2DMake(segmentLocation.coordinate.latitude, segmentLocation.coordinate.longitude);
            startPoint.icon = [UIImage imageNamed:@"markerIcon_green@3x.png"];
            startPoint.groundAnchor = CGPointMake(0.5,0.5);
            startPoint.map = mapView;
        }
        else if (i==[startStopMarkerCoordinates count]-1) {
            startPoint.position = CLLocationCoordinate2DMake(segmentLocation.coordinate.latitude, segmentLocation.coordinate.longitude);
            startPoint.icon = [UIImage imageNamed:@"markerIcon_red@3x.png"];
            startPoint.groundAnchor = CGPointMake(0.5,0.5);
            startPoint.map = mapView;
        }
        else if (i%2==0 && !server) {
            startPoint.position = CLLocationCoordinate2DMake(segmentLocation.coordinate.latitude, segmentLocation.coordinate.longitude);
            startPoint.icon = [UIImage imageNamed:@"markerIcon_gray@3x.png"];
            startPoint.groundAnchor = CGPointMake(0.5,0.5);
            startPoint.map = mapView;
        }
        else if (server) {
            startPoint.position = CLLocationCoordinate2DMake(segmentLocation.coordinate.latitude, segmentLocation.coordinate.longitude);
            startPoint.icon = [UIImage imageNamed:@"markerIcon_gray@3x.png"];
            startPoint.groundAnchor = CGPointMake(0.5,0.5);
            startPoint.map = mapView;
        }
    }
    
    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:[[GMSCoordinateBounds alloc]initWithCoordinate:CLLocationCoordinate2DMake(minLat, minLon) coordinate:CLLocationCoordinate2DMake(maxLat, maxLon)] withPadding:50.0f];
    [mapView moveCamera:cameraUpdate];
    
    [_loadingView removeFromSuperview];
    
    if (!_tourImages) {
        [_imageViewContainer setHidden:YES];
        
        [_noImagesViewContainer setHidden:NO];
        
        CGRect descriptionViewFrame = _descriptionViewContainer.frame;
        
        _descriptionViewContainer.frame = CGRectMake(descriptionViewFrame.origin.x, descriptionViewFrame.origin.y - 155, descriptionViewFrame.size.width, descriptionViewFrame.size.height);
        
        CGRect noDescriptionViewFrame = _noDescriptionViewContainer.frame;
        
        _noDescriptionViewContainer.frame = CGRectMake(noDescriptionViewFrame.origin.x, noDescriptionViewFrame.origin.y - 155, noDescriptionViewFrame.size.width, noDescriptionViewFrame.size.height);
        
        CGSize contentSize = self.contentSize;
        
        self.contentSize = CGSizeMake(contentSize.width, contentSize.height-155);
    }
    else {
        XTSummaryImageViewController *imageView = [[XTSummaryImageViewController alloc] initWithNibName:nil bundle:nil];
        
        imageView.view.frame = CGRectMake(0, 0, boxWidth, 200);
        imageView.images = _tourImages;
        
        [_imageViewContainer addSubview:imageView.view];
    }
    
    XTGraphPageViewController *graphPageController = [[XTGraphPageViewController alloc] initWithNibName:nil bundle:nil andTourInfo:tourInfo];
    
    graphPageController.view.frame = CGRectMake(5, 5, boxWidth-10, width/320*200);
    graphPageController.pageController.view.frame = CGRectMake(0, 0, boxWidth-10, width/320*200);
    
    [_graphViewContainer addSubview:graphPageController.view];
    
    if (server) {
        float commentsY = self.contentSize.height - [UITabBarController new].tabBar.frame.size.height;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
        
        for (int n = 0; n < [_tourComments count]; n++) {
            XTUserComment *currentComment = [_tourComments objectAtIndex:n];
            
            UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, commentsY, boxWidth, 100)];
            
            commentView.backgroundColor = [UIColor whiteColor];
            commentView.layer.cornerRadius = boxRadius;
            commentView.layer.borderWidth = boxBorderWidth;
            commentView.layer.borderColor = boxBorderColor.CGColor;
            
            UILabel *commentTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, boxWidth-40, 20)];
            
            commentTitle.textColor = [UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0f];
            commentTitle.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
            
            NSString *commentDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentComment.commentDate]];
            
            commentTitle.text = [NSString stringWithFormat:@"%@ am %@",currentComment.userName,commentDate];
            
            UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
            
            [profilePicture setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.xtour.ch/users/%@/profile.png",currentComment.userID]] placeholderImage:[UIImage imageNamed:@"profile_icon_gray.png"]];
            
            UITextView *commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(35, 30, boxWidth-40, 65)];
            
            commentTextView.editable = NO;
            commentTextView.scrollEnabled = YES;
            commentTextView.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
            commentTextView.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
            
            NSString *commentText = [currentComment.comment stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            
            commentTextView.text = [commentText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [commentView addSubview:commentTitle];
            [commentView addSubview:profilePicture];
            [commentView addSubview:commentTextView];
            
            [self addSubview:commentView];
            
            commentsY += 105;
            
            [commentTitle release];
            [profilePicture release];
            [commentTextView release];
            [commentView release];
        }
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, commentsY, boxWidth, 100)];
        
        commentView.backgroundColor = [UIColor whiteColor];
        commentView.layer.cornerRadius = boxRadius;
        commentView.layer.borderWidth = boxBorderWidth;
        commentView.layer.borderColor = boxBorderColor.CGColor;
        
        _enterCommentTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 20)];
        
        _enterCommentTitle.textColor = [UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0f];
        _enterCommentTitle.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        
        _enterCommentTitle.text = @"Kommentar schreiben";
        
        UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        
        [profilePicture setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.xtour.ch/users/%@/profile.png",data.userID]] placeholderImage:[UIImage imageNamed:@"profile_icon_gray.png"]];
        
        _enterCommentTextView = [[UITextView alloc] initWithFrame:CGRectMake(40, 30, boxWidth-80, 60)];
        
        _enterCommentTextView.editable = YES;
        _enterCommentTextView.scrollEnabled = YES;
        _enterCommentTextView.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        _enterCommentTextView.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
        _enterCommentTextView.layer.borderWidth = 1.0f;
        _enterCommentTextView.layer.borderColor = [[UIColor colorWithRed:180.0f/255.0f green:180.f/255.0f blue:180.0f/255.0f alpha:1.0f] CGColor];
        
        _enterComment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        _enterComment.frame = CGRectMake(boxWidth-35, 65, 30, 30);
        [_enterComment setBackgroundImage:[UIImage imageNamed:@"enter_comment_icon@3x.png"] forState:UIControlStateNormal];
        [_enterComment addTarget:self action:@selector(EnterComment:) forControlEvents:UIControlEventTouchUpInside];
        
        [commentView addSubview:_enterCommentTitle];
        [commentView addSubview:profilePicture];
        [commentView addSubview:_enterCommentTextView];
        [commentView addSubview:_enterComment];
        
        [self addSubview:commentView];
        
        [profilePicture release];
        [commentView release];
        
        CGSize contentSize = self.contentSize;
        
        self.contentSize = CGSizeMake(contentSize.width, contentSize.height+([_tourComments count]+1)*105);
    }
}

- (void) EnterComment:(id)sender
{
    XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
    
    XTUserComment *userComment = [[XTUserComment alloc] init];
    
    userComment.userID = data.userID;
    userComment.tourID = _currentTourID;
    userComment.userName = data.userInfo.userName;
    userComment.commentDate = [[NSDate date] timeIntervalSince1970];
    userComment.comment = _enterCommentTextView.text;
    
    [request SubmitUserComment:userComment];
    
    [_enterCommentTextView resignFirstResponder];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    NSString *commentDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:userComment.commentDate]];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _enterCommentTitle.text = [NSString stringWithFormat:@"%@ am %@",userComment.userName,commentDate];
        
        _enterCommentTextView.layer.borderWidth = 0;
        
        CGRect commentViewFrame = _enterCommentTextView.frame;
        
        _enterCommentTextView.frame = CGRectMake(35, commentViewFrame.origin.y, commentViewFrame.size.width+40, commentViewFrame.size.height);
        
        [_enterComment setHidden:YES];
    } completion:NULL];
}

- (void) ShowMorePeaks:(id)sender
{
    CGRect mountainPeakExtendedViewFrame = _mountainPeakExtendedView.frame;
    
    if (_mountainPeakExtendedView.isHidden) {[_mountainPeakExtendedView setHidden:NO];}
    
    float height = ([_morePeaks count]+1)*40.0 + 125.0;
    if (height < 150) {height = 150;}
    if (height > 250) {height = 250;}
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        if (_mountainPeakExtendedView.frame.size.height == 0) {
            _mountainPeakExtendedView.frame = CGRectMake(mountainPeakExtendedViewFrame.origin.x, mountainPeakExtendedViewFrame.origin.y, mountainPeakExtendedViewFrame.size.width, height);
            
            _blurEffectView.frame = CGRectMake(0, 0, mountainPeakExtendedViewFrame.size.width, height);
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
            _MountainPeakMore.transform = transform;
        }
        else {
            [_mountainPeakMoreView setHidden:YES];
            
            _mountainPeakExtendedView.frame = CGRectMake(mountainPeakExtendedViewFrame.origin.x, mountainPeakExtendedViewFrame.origin.y, mountainPeakExtendedViewFrame.size.width, 0);
            
            _blurEffectView.frame = CGRectMake(0, 0, mountainPeakExtendedViewFrame.size.width, 0);
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(2*M_PI);
            _MountainPeakMore.transform = transform;
            
            if (![_enterMountainPeak.text isEqualToString:@""] && !_didSelectRow) {
                NSMutableArray *peak = [NSMutableArray arrayWithObjects:_enterMountainPeak.text, [NSNumber numberWithFloat:data.highestPoint.coordinate.longitude], [NSNumber numberWithFloat:data.highestPoint.coordinate.latitude], [NSNumber numberWithFloat:data.highestPoint.altitude], [NSNumber numberWithFloat:0.0], nil];
                
                float longitude = [[peak objectAtIndex:1] floatValue];
                NSString *lonEW;
                if (longitude < 0) {lonEW = @"W"; longitude = fabs(longitude);}
                else {lonEW = @"E";}
                
                float latitude = [[peak objectAtIndex:2] floatValue];
                NSString *latNS;
                if (latitude < 0) {latNS = @"S"; latitude = fabs(latitude);}
                else {latNS = @"N";}
                
                NSString *lonString = [NSString stringWithFormat:@"%.0f°%.0f'%.0f\" %s",
                                       floor(longitude),
                                       floor((longitude - floor(longitude)) * 60),
                                       ((longitude - floor(longitude)) * 60 - floor((longitude - floor(longitude)) * 60)) * 60, [lonEW UTF8String]];
                NSString *latString = [NSString stringWithFormat:@"%.0f°%.0f'%.0f\" %s",
                                       floor(latitude),
                                       floor((latitude - floor(latitude)) * 60),
                                       ((latitude - floor(latitude)) * 60 - floor((latitude - floor(latitude)) * 60)) * 60, [latNS UTF8String]];
                
                _MountainPeakTitleLabel.text = @"Dieser Gipfel ist ausgewählt";
                _MountainPeakCoordinatesLabel.text = [NSString stringWithFormat:@"%@ %@", lonString, latString];
                _MountainPeakAltitudeLabel.text = [NSString stringWithFormat:@"%@, %.0fm", [peak objectAtIndex:0], [[peak objectAtIndex:3] floatValue]];
                
                _mountainPeak = [peak objectAtIndex:0];
                
                [_noPeakFoundLabel setHidden:YES];
            }
            else if ([_mountainPeak isEqualToString:@""]) {
                _MountainPeakTitleLabel.text = @"";
                _MountainPeakCoordinatesLabel.text = @"";
                _MountainPeakAltitudeLabel.text = @"";
                
                [_noPeakFoundLabel setHidden:NO];
            }
        }
    } completion:^(BOOL finished) {
        if (_mountainPeakExtendedView.frame.size.height == 0) {
            [_mountainPeakExtendedView setHidden:YES];
        }
        else {
            [_mountainPeakMoreView setHidden:NO];
        }
        
        _didSelectRow = false;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_morePeaks count] > 0) {return 3;}
    else {return 2;}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_morePeaks count] > 0) {
        if (section == 0 || section == 2) {return 1;}
        else {return [_morePeaks count];}
    }
    else {return 1;}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UIView *PeakFieldView = [cell viewWithTag:10];
    
    [PeakFieldView removeFromSuperview];
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Entferne diesen Gipfel";
        cell.textLabel.textColor = [UIColor redColor];
    }
    else if (indexPath.section == 1 && [_morePeaks count] > 0) {
        NSMutableArray *peak = [_morePeaks objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %.0fm", [peak objectAtIndex:0], [[peak objectAtIndex:3] floatValue]];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else {
        UIView *newPeakFieldBackground = [[UIView alloc] initWithFrame:CGRectMake(10, 5, width-50, 30)];
        
        newPeakFieldBackground.backgroundColor = [UIColor whiteColor];
        newPeakFieldBackground.layer.borderWidth = 1.0f;
        newPeakFieldBackground.layer.borderColor = [[UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0f] CGColor];
        newPeakFieldBackground.layer.cornerRadius = 5.0f;
        newPeakFieldBackground.tag = 10;
        
        _enterMountainPeak = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, width-60, 30)];
        
        _enterMountainPeak.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
        
        [newPeakFieldBackground addSubview:_enterMountainPeak];
        
        [cell.contentView addSubview:newPeakFieldBackground];
        
        cell.textLabel.text = @"";
        
        [newPeakFieldBackground release];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        [_noPeakFoundLabel setHidden:NO];
        
        _noPeakFoundLabel.text = @"Kein Gipfel ausgewählt";
        _MountainPeakTitleLabel.text = @"";
        _MountainPeakCoordinatesLabel.text = @"";
        _MountainPeakAltitudeLabel.text = @"";
        
        _mountainPeak = @"";
        
        _didSelectRow = true;
    }
    else if (indexPath.section == 1 && [_morePeaks count] > 0) {
        [_noPeakFoundLabel setHidden:YES];
        
        NSMutableArray *peak = [_morePeaks objectAtIndex:indexPath.row];
        
        float longitude = [[peak objectAtIndex:1] floatValue];
        NSString *lonEW;
        if (longitude < 0) {lonEW = @"W"; longitude = fabs(longitude);}
        else {lonEW = @"E";}
        
        float latitude = [[peak objectAtIndex:2] floatValue];
        NSString *latNS;
        if (latitude < 0) {latNS = @"S"; latitude = fabs(latitude);}
        else {latNS = @"N";}
        
        NSString *lonString = [NSString stringWithFormat:@"%.0f°%.0f'%.0f\" %s",
                               floor(longitude),
                               floor((longitude - floor(longitude)) * 60),
                               ((longitude - floor(longitude)) * 60 - floor((longitude - floor(longitude)) * 60)) * 60, [lonEW UTF8String]];
        NSString *latString = [NSString stringWithFormat:@"%.0f°%.0f'%.0f\" %s",
                               floor(latitude),
                               floor((latitude - floor(latitude)) * 60),
                               ((latitude - floor(latitude)) * 60 - floor((latitude - floor(latitude)) * 60)) * 60, [latNS UTF8String]];
        
        _MountainPeakTitleLabel.text = @"Dieser Gipfel ist ausgewählt";
        _MountainPeakCoordinatesLabel.text = [NSString stringWithFormat:@"%@ %@", lonString, latString];
        _MountainPeakAltitudeLabel.text = [NSString stringWithFormat:@"%@, %.0fm", [peak objectAtIndex:0], [[peak objectAtIndex:3] floatValue]];
        
        _mountainPeak = [peak objectAtIndex:0];
        
        _didSelectRow = true;
    }
    
    [self ShowMorePeaks:nil];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, tableView.frame.size.width-10, 20)];
    
    viewHeader.backgroundColor = [UIColor clearColor];
    
    lblTitle.font = [UIFont fontWithName:@"Helvetica" size:14];
    lblTitle.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    lblTitle.backgroundColor = [UIColor clearColor];
    
    if (section == 0) {lblTitle.text = @"Nicht der richtige Gipfel?";}
    else if (section == 1 && [_morePeaks count] > 0) {lblTitle.text = @"Oder wähle einer der umliegenden Gipfel";}
    else {lblTitle.text = @"Oder gib ein Gipfel ein";}
    
    [viewHeader addSubview:lblTitle];
    
    [lblTitle release];
    
    return viewHeader;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    if (_enterMountainPeak.isFirstResponder) {return;}
    
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
    
    [self setContentOffset:CGPointMake(0, self.contentSize.height - self.bounds.size.height + self.contentInset.bottom) animated:YES];
    
    if (!_hasDescription) {_descriptionView.text = @"";}
    
    _hasDescription = true;
}

- (void) keyboardWillHide:(NSNotification *)notification {
    
    if (_enterMountainPeak.isFirstResponder) {return;}
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
    
    if ([_descriptionView.text isEqualToString:@""]) {_descriptionView.text = @"Kurze Beschreibung zur Tour"; _hasDescription = false;}
    else {_hasDescription = true;}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

@end

//
//  XTProfileViewController.m
//  XTour
//
//  Created by Manuel Weber on 03/06/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTProfileViewController.h"

@interface XTProfileViewController ()

@end

@implementation XTProfileViewController

- (void)initialize {
    
    data = [XTDataSingleton singleObj];
    
    self.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    _width = screenBound.size.width;
    //float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [UITabBarController new];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    float boxWidth = _width - 20;
    float boxRadius = 5.f;
    float boxBorderWidth = 1.0f;
    float boxMarginLeft = 10.0f;
    float boxMarginTop = 75.0f;
    UIColor *boxBorderColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    _profileSummary = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, boxMarginTop+30, boxWidth, 300)];
    
    _profileSummary.backgroundColor = [UIColor whiteColor];
    _profileSummary.layer.cornerRadius = boxRadius;
    _profileSummary.layer.borderWidth = boxBorderWidth;
    _profileSummary.layer.borderColor = boxBorderColor.CGColor;
    
    _profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(_width/2-30, boxMarginTop, 60, 60)];
    
    if (data.loggedIn) {
        _profilePicture.image = [UIImage imageNamed:[data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO]];
    }
    else {
        _profilePicture.image = [UIImage imageNamed:@"profile_icon_gray.png"];
    }
    
    UIView *profilePictureBackground = [[UIView alloc] initWithFrame:CGRectMake(_width/2-31, boxMarginTop-1, 62, 62)];
    
    profilePictureBackground.backgroundColor = [UIColor clearColor];
    profilePictureBackground.layer.borderWidth = 2.0f;
    profilePictureBackground.layer.borderColor = [[UIColor whiteColor] CGColor];
    profilePictureBackground.layer.cornerRadius = 31.0f;
    
    UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(5, 50, boxWidth-10, 1)] autorelease];
    
    line.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    
    UILabel *statsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 200, 15)];
    
    statsLabel.text = @"Statistik";
    statsLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    statsLabel.textColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
    
    _month = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _month.frame = CGRectMake(5, 60, (boxWidth-10)/3, 20);
    [_month setTitle:@"Diesen Monat" forState:UIControlStateNormal];
    _month.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    [_month setTitleColor:[UIColor colorWithRed:41.0f/255.0f green:127.0f/255.0f blue:199.0f/255.0f alpha:0.9f] forState:UIControlStateNormal];
    [_month addTarget:self action:@selector(ShowMonthlyStatistics:) forControlEvents:UIControlEventTouchUpInside];
    
    _season = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _season.frame = CGRectMake(5+(boxWidth-10)/3, 60, (boxWidth-10)/3, 20);
    [_season setTitle:@"Diese Saison" forState:UIControlStateNormal];
    _season.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    [_season setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_season addTarget:self action:@selector(ShowSeasonalStatistics:) forControlEvents:UIControlEventTouchUpInside];
    
    _total = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _total.frame = CGRectMake(5+2*(boxWidth-10)/3, 60, (boxWidth-10)/3, 20);
    [_total setTitle:@"Seit Beginn" forState:UIControlStateNormal];
    _total.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    [_total setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_total addTarget:self action:@selector(ShowTotalStatistics:) forControlEvents:UIControlEventTouchUpInside];
    
    _tab = [[UIView alloc] initWithFrame:CGRectMake(5, 85, (boxWidth-10)/3, 2)];
    
    _tab.backgroundColor = [UIColor colorWithRed:41.0f/255.0f green:127.0f/255.0f blue:199.0f/255.0f alpha:0.9f];
    
    float iconSize = 40.0;
    
    UILabel *timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(boxWidth/2+10, 105, 150, 15)];
    
    timeTitleLabel.text = @"Gesamtzeit";
    timeTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    timeTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    
    UILabel *toursTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 150, 15)];
    
    toursTitleLabel.text = @"Anzahl Touren";
    toursTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    toursTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    
    UILabel *distanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115+iconSize, 150, 15)];
    
    distanceTitleLabel.text = @"Distanz";
    distanceTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    distanceTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    
    UILabel *altitudeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(boxWidth/2+10, 115+iconSize, 150, 15)];
    
    altitudeTitleLabel.text = @"Höhenmeter";
    altitudeTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    altitudeTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    
    UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(boxWidth/2+5, 105, iconSize, iconSize)];
    
    timeImage.image = [UIImage imageNamed:@"clock_icon.png"];
    
    UIImageView *numberOfToursImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 105, iconSize, iconSize)];
    
    numberOfToursImage.image = [UIImage imageNamed:@"clock_icon.png"];
    
    UIImageView *distanceImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 115+iconSize, iconSize, iconSize)];
    
    distanceImage.image = [UIImage imageNamed:@"skier_up_icon.png"];
    
    UIImageView *altitudeImage = [[UIImageView alloc] initWithFrame:CGRectMake(boxWidth/2+5, 115+iconSize, iconSize, iconSize)];
    
    altitudeImage.image = [UIImage imageNamed:@"altitude_icon.png"];
    
    _toursLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 115, boxWidth/2-10, iconSize)];
    
    _toursLabel.text = @"--";
    _toursLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0f];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(boxWidth/2+15, 115, boxWidth/2-10, iconSize)];
    
    _timeLabel.text = @"--h --m";
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0f];
    
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 125+iconSize, boxWidth/2-10, iconSize)];
    
    _distanceLabel.text = @"-- km";
    _distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0f];
    
    _altitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(boxWidth/2+15, 125+iconSize, boxWidth/2-10, iconSize)];
    
    _altitudeLabel.text = @"-- km";
    _altitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0f];
    
    yearlyStatistics = [[XTYearlyStatisticsViewController alloc] initWithNibName:nil bundle:nil];
    
    yearlyStatistics.view.frame = CGRectMake(5, 220, boxWidth-10, 70);
    
    [yearlyStatistics LoadData];
    
    _calendarView = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, boxMarginTop+335, boxWidth, 1.05*boxWidth)];
    
    _calendarView.backgroundColor = [UIColor whiteColor];
    _calendarView.layer.cornerRadius = boxRadius;
    _calendarView.layer.borderWidth = boxBorderWidth;
    _calendarView.layer.borderColor = boxBorderColor.CGColor;
    
    XTCalendarPageViewController *calendarPageView = [[XTCalendarPageViewController alloc] initWithNibName:nil bundle:nil];
    
    calendarPageView.view.frame = CGRectMake(5, 5, boxWidth-10, 1.05*boxWidth-10);
    
    calendarPageView.pageController.view.frame = CGRectMake(0, 0, boxWidth-10, 1.05*boxWidth-10);
    
    [_calendarView addSubview:calendarPageView.view];
    
    [calendarPageView SetDataForUser:data.userID];
    
    [self setContentSize:CGSizeMake(_width, boxMarginTop+340+1.05*boxWidth+tabBarHeight)];
    
    //[_profileSummary addSubview:_profilePicture];
    [_profileSummary addSubview:line];
    [_profileSummary addSubview:statsLabel];
    [_profileSummary addSubview:_month];
    [_profileSummary addSubview:_season];
    [_profileSummary addSubview:_total];
    [_profileSummary addSubview:_tab];
    [_profileSummary addSubview:timeTitleLabel];
    [_profileSummary addSubview:toursTitleLabel];
    [_profileSummary addSubview:distanceTitleLabel];
    [_profileSummary addSubview:altitudeTitleLabel];
    /*[_profileSummary addSubview:timeImage];
    [_profileSummary addSubview:numberOfToursImage];
    [_profileSummary addSubview:distanceImage];
    [_profileSummary addSubview:altitudeImage];*/
    [_profileSummary addSubview:_toursLabel];
    [_profileSummary addSubview:_timeLabel];
    [_profileSummary addSubview:_distanceLabel];
    [_profileSummary addSubview:_altitudeLabel];
    [_profileSummary addSubview:yearlyStatistics.view];
    [self addSubview:_profileSummary];
    [self addSubview:_calendarView];
    [self addSubview:_profilePicture];
    [self addSubview:profilePictureBackground];
    
    _userStatistics = nil;
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_user_statistics.php?uid=%@", data.userID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfiguration.timeoutIntervalForRequest = 10.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message: @"Da ist etwas schief gelaufen. Stelle sicher, dass du Verbindung zum Internet hast." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
        XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
        
        _userStatistics = [request GetUserStatistics:responseData];
        
        _toursLabel.text = [NSString stringWithFormat:@"%li",(long)_userStatistics.monthlyNumberOfTours];
        _timeLabel.text = [self GetFormattedTimeString:_userStatistics.monthlyTime];
        _distanceLabel.text = [NSString stringWithFormat:@"%.1f km",_userStatistics.monthlyDistance];
        _altitudeLabel.text = [NSString stringWithFormat:@"%.1f km",_userStatistics.monthlyAltitude/1000.0];
    }];
    
    [sessionTask resume];
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
        
        _userStatistics = [request GetUserStatistics:data.userID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _toursLabel.text = [NSString stringWithFormat:@"%li",(long)_userStatistics.monthlyNumberOfTours];
            _timeLabel.text = [self GetFormattedTimeString:_userStatistics.monthlyTime];
            _distanceLabel.text = [NSString stringWithFormat:@"%.1f km",_userStatistics.monthlyDistance];
            _altitudeLabel.text = [NSString stringWithFormat:@"%.1f km",_userStatistics.monthlyAltitude/1000.0];
        });
    });*/
}

- (void)dealloc {
    [_profileSummary release];
    [_profilePicture release];
    [_calendarView release];
    [_month release];
    [_season release];
    [_total release];
    [_timeLabel release];
    [_toursLabel release];
    [_distanceLabel release];
    [_altitudeLabel release];
    [_tab release];
    [_userStatistics release];
    [super dealloc];
}

- (void)ShowMonthlyStatistics:(id)sender
{
    float position = _month.frame.origin.x;
    
    [self MoveTabTo:position];
    
    [_month setTitleColor:[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f] forState:UIControlStateNormal];
    [_season setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_total setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    _toursLabel.text = [NSString stringWithFormat:@"%li",(long)_userStatistics.monthlyNumberOfTours];
    _timeLabel.text = [self GetFormattedTimeString:_userStatistics.monthlyTime];
    if (_userStatistics.monthlyDistance >= 100) {_distanceLabel.text = [NSString stringWithFormat:@"%.0f km",_userStatistics.monthlyDistance];}
    else {_distanceLabel.text = [NSString stringWithFormat:@"%.1f km",_userStatistics.monthlyDistance];}
    if (_userStatistics.monthlyAltitude/1000.0 >= 100) {_altitudeLabel.text = [NSString stringWithFormat:@"%.0f km",_userStatistics.monthlyAltitude/1000.0];}
    else {_altitudeLabel.text = [NSString stringWithFormat:@"%.1f km",_userStatistics.monthlyAltitude/1000.0];}
}

- (void)ShowSeasonalStatistics:(id)sender
{
    float position = _season.frame.origin.x;
    
    [self MoveTabTo:position];
    
    [_month setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_season setTitleColor:[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f] forState:UIControlStateNormal];
    [_total setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    _toursLabel.text = [NSString stringWithFormat:@"%li",(long)_userStatistics.seasonalNumberOfTours];
    _timeLabel.text = [self GetFormattedTimeString:_userStatistics.seasonalTime];
    if (_userStatistics.seasonalDistance >= 100) {_distanceLabel.text = [NSString stringWithFormat:@"%.0f km",_userStatistics.seasonalDistance];}
    else {_distanceLabel.text = [NSString stringWithFormat:@"%.1f km",_userStatistics.seasonalDistance];}
    if (_userStatistics.seasonalAltitude/1000.0 >= 100) {_altitudeLabel.text = [NSString stringWithFormat:@"%.0f km",_userStatistics.seasonalAltitude/1000.0];}
    else {_altitudeLabel.text = [NSString stringWithFormat:@"%.1f km",_userStatistics.seasonalAltitude/1000.0];}
}

- (void)ShowTotalStatistics:(id)sender
{
    float position = _total.frame.origin.x;
    
    [self MoveTabTo:position];
    
    [_month setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_season setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_total setTitleColor:[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f] forState:UIControlStateNormal];
    
    _toursLabel.text = [NSString stringWithFormat:@"%li",(long)_userStatistics.totalNumberOfTours];
    _timeLabel.text = [self GetFormattedTimeString:_userStatistics.totalTime];
    if (_userStatistics.totalDistance >= 100) {_distanceLabel.text = [NSString stringWithFormat:@"%.0f km",_userStatistics.totalDistance];}
    else { _distanceLabel.text = [NSString stringWithFormat:@"%.1f km",_userStatistics.totalDistance];}
    if (_userStatistics.totalAltitude/1000.0 >= 100) {_altitudeLabel.text = [NSString stringWithFormat:@"%.0f km",_userStatistics.totalAltitude/1000.0];}
    else {_altitudeLabel.text = [NSString stringWithFormat:@"%.1f km",_userStatistics.totalAltitude/1000.0];}
}

- (void)MoveTabTo:(float)position
{
    CGRect frame = _tab.frame;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _tab.frame = CGRectMake(position, frame.origin.y, frame.size.width, frame.size.height);
    } completion:nil];
}

- (NSString*) GetFormattedTimeString:(NSInteger)time
{
    NSString *formattedString;
    
    if (time >= 360000) {formattedString = [NSString stringWithFormat:@"%.0fd %.0fh",floor(time/86400),round((time/86400-floor(time/86400))*24)];}
    else if (time < 360000 && time >= 3600) {formattedString = [NSString stringWithFormat:@"%.0fh %.0fm",floor(time/3600), round((time/3600-floor(time/3600))*60)];}
    else {formattedString = [NSString stringWithFormat:@"%lim",time/60];}
    
    return formattedString;
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

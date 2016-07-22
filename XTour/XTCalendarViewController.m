//
//  XTCalendarViewController.m
//  XTour
//
//  Created by Manuel Weber on 26/09/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import "XTCalendarViewController.h"

@interface XTCalendarViewController ()

@end

@implementation XTCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    //float height = screenBound.size.height;
    
    _calendarWidth = width - 30;
    _calendarHeight = 1.05*(width - 30);
    
    _calendarActiveColor = [[UIColor alloc] initWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    
    _monthTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, _calendarWidth-100, 20)];
    
    _monthTitle.textAlignment = NSTextAlignmentCenter;
    
    NSArray *days = [NSArray arrayWithObjects:@"Mo",@"Di",@"Mi",@"Do",@"Fr",@"Sa",@"So", nil];
    
    float stp = 290/7;
    for (int i = 0; i < 7; i++) {
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*stp, 40, stp, 20)];
        
        dayLabel.text = [days objectAtIndex:i];
        
        dayLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:dayLabel];
        
        [dayLabel release];
    }
    
    [self.view addSubview:_monthTitle];
    
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width-30, (width-30)*1.05)];
    
    _detailView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.95f];
    
    _detailTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 200, 20)];
    
    _timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, width-20, 15)];
    
    _timeTitleLabel.text = @"Dauer";
    _timeTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _timeTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    
    _distanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, (width-20)/2, 15)];
    
    _distanceTitleLabel.text = @"Distanz";
    _distanceTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _distanceTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    
    _altitudeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2, 120, (width-20)/2, 15)];
    
    _altitudeTitleLabel.text = @"Höhendifferenz";
    _altitudeTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _altitudeTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, width-20, 40)];
    
    _timeLabel.text = @"--";
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:35.0f];
    
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 140, (width-20)/2, 25)];
    
    _distanceLabel.text = @"--";
    _distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:25.0f];
    
    _altitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2, 140, (width-20)/2, 25)];
    
    _altitudeLabel.text = @"--";
    _altitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:25.0f];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _closeButton.frame = CGRectMake(_detailView.frame.size.width-35, 5, 30, 30);
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"cleanup_icon@3x.png"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(CloseDetailView:) forControlEvents:UIControlEventTouchUpInside];
    
    _tourDescription = [[UITextView alloc] initWithFrame:CGRectMake(5, 170, _detailView.frame.size.width-10, _detailView.frame.size.height-170-30)];
    
    _tourDescription.editable = NO;
    _tourDescription.layer.borderColor = [[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f] CGColor];
    _tourDescription.layer.borderWidth = 1.0f;
    _tourDescription.layer.cornerRadius = 5.0f;
    _tourDescription.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    
    _detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _detailButton.frame = CGRectMake((_detailView.frame.size.width)/2-50, _detailView.frame.size.height-30, 100, 30);
    [_detailButton setTitle:@"Details" forState:UIControlStateNormal];
    [_detailButton addTarget:self action:@selector(ShowFullTourDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [_detailView addSubview:_detailTitleLabel];
    [_detailView addSubview:_timeTitleLabel];
    [_detailView addSubview:_distanceTitleLabel];
    [_detailView addSubview:_altitudeTitleLabel];
    [_detailView addSubview:_timeLabel];
    [_detailView addSubview:_distanceLabel];
    [_detailView addSubview:_altitudeLabel];
    [_detailView addSubview:_closeButton];
    [_detailView addSubview:_tourDescription];
    [_detailView addSubview:_detailButton];
    [self.view addSubview:_detailView];
    
    [_detailView setHidden:YES];
    [_detailTitleLabel setHidden:YES];
    [_timeTitleLabel setHidden:YES];
    [_distanceTitleLabel setHidden:YES];
    [_altitudeTitleLabel setHidden:YES];
    [_timeLabel setHidden:YES];
    [_distanceLabel setHidden:YES];
    [_altitudeLabel setHidden:YES];
    [_closeButton setHidden:YES];
    [_tourDescription setHidden:YES];
    [_detailButton setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LoadCalendarAtIndex:(NSUInteger)index
{
    NSArray *months = [NSArray arrayWithObjects:@"Januar",@"Februar",@"März",@"April",@"Mai",@"Juni",@"Juli",@"August",@"September",@"Oktober",@"November",@"Dezember", nil];
    
    int monthInt = index % 12;
    
    if (monthInt > 11) {return;}
    
    NSUInteger year = 2015 + index/12;
    
    NSString *month = [months objectAtIndex:monthInt];
    
    _monthTitle.text = [NSString stringWithFormat:@"%@ %lu",month,(unsigned long)year];
    
    NSString *time = [NSString stringWithFormat:@"%04lu-%02d-01 00:00:01",(unsigned long)year,monthInt+1];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *monthDate = [formatter dateFromString:time];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    
    NSCalendar *c = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponent = [c components:NSCalendarUnitWeekday fromDate:monthDate];
    
    NSInteger weekday = dateComponent.weekday - 2;
    if (weekday == -1) {weekday = 6;}
    
    NSRange daysRange = [c rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:monthDate];
    
    NSInteger numberOfDays = daysRange.length;
    
    float dayLabelwidth = _calendarWidth/7;
    float dayLabelheight = _calendarWidth/7;
    
    NSInteger daysCount = 1;
    for (int i = 0; i < 42; i++) {
        if (i < weekday) {continue;}
        if (daysCount > numberOfDays) {continue;}
        
        int column = i % 7;
        int row = i/7;
        
        float dayLabelx = column*dayLabelwidth;
        float dayLabely = row*dayLabelheight;
        
        NSString *dateString = [NSString stringWithFormat:@"%04li-%02li-%02li",(long)year,(long)monthInt+1,(long)daysCount];
        
        if (_calendarData && [_calendarData objectForKey:dateString]) {
            NSInteger buttonTag = year*10000+(monthInt+1)*100+daysCount;
            
            UIButton *dayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            dayButton.frame = CGRectMake(dayLabelx, dayLabely+55, dayLabelwidth, dayLabelheight);
            dayButton.backgroundColor = _calendarActiveColor;
            [dayButton setTitle:[NSString stringWithFormat:@"%02ld",(long)daysCount] forState:UIControlStateNormal];
            [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            dayButton.layer.cornerRadius = dayLabelwidth/2;
            [dayButton setTag:buttonTag];
            [dayButton addTarget:self action:@selector(ShowTourDetail:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([dateString isEqualToString:currentDate]) {
                dayButton.layer.borderColor = [[UIColor redColor] CGColor];
                dayButton.layer.borderWidth = 2;
            }
            
            [self.view addSubview:dayButton];
        }
        else {
            UIView *dayLabelView = [[UIView alloc] initWithFrame:CGRectMake(dayLabelx, dayLabely+55, dayLabelwidth, dayLabelheight)];
            
            dayLabelView.backgroundColor = [UIColor clearColor];
            dayLabelView.layer.cornerRadius = dayLabelwidth/2;
            
            UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dayLabelwidth, dayLabelheight)];
            
            dayLabel.text = [NSString stringWithFormat:@"%02ld",(long)daysCount];
            
            dayLabel.textColor = [UIColor grayColor];
            
            dayLabel.textAlignment = NSTextAlignmentCenter;
            
            if ([dateString isEqualToString:currentDate]) {
                dayLabelView.layer.borderColor = [[UIColor redColor] CGColor];
                dayLabelView.layer.borderWidth = 2;
            }
            
            [dayLabelView addSubview:dayLabel];
            
            [self.view addSubview:dayLabelView];
            
            [dayLabel release];
            [dayLabelView release];
        }
        
        daysCount++;
    }
}

- (void) ShowTourDetail:(UIButton*)button
{
    double buttonTag = (double)[button tag];
    
    double year = floor(buttonTag/10000);
    double month = floor((buttonTag/10000 - year)*100);
    double day = ((buttonTag/10000 - year)*100 - month)*100;
    
    NSString *dateString = [NSString stringWithFormat:@"%04.0f-%02.0f-%02.0f",year,month,day];
    
    XTTourInfo *currentTour = [_calendarData objectForKey:dateString];
    
    if (!currentTour) {return;}
    
    _detailView.frame = button.frame;
    
    [_detailView setHidden:NO];
    
    [self.view bringSubviewToFront:_detailView];
    
    [_detailButton setTag:[button tag]];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_detailView.frame = CGRectMake(0, 0, _calendarWidth, _calendarHeight);} completion:^(BOOL finished) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"dd.MM.yyyy"];
        
        NSString *formattedDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTour.date]];
        
        NSUInteger tm = currentTour.totalTime;
        
        NSString *TimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                                       lround(floor(tm / 3600.)) % 100,
                                       lround(floor(tm / 60.)) % 60,
                                       lround(floor(tm)) % 60];
        
        _detailTitleLabel.text = [NSString stringWithFormat:@"Tour vom %@",formattedDate];
        _timeLabel.text = [NSString stringWithFormat:@"%@",TimeString];
        _distanceLabel.text = [NSString stringWithFormat:@"%.1f km",currentTour.distance];
        _altitudeLabel.text = [NSString stringWithFormat:@"%.1f m",currentTour.altitude];
        
        if ([currentTour.tourDescription isEqualToString:@""]) {_tourDescription.text = @"Keine Beschreibung zu dieser Tour vorhanden.";}
        else {_tourDescription.text = currentTour.tourDescription;}
        
        [_detailTitleLabel setHidden:NO];
        [_timeTitleLabel setHidden:NO];
        [_distanceTitleLabel setHidden:NO];
        [_altitudeTitleLabel setHidden:NO];
        [_timeLabel setHidden:NO];
        [_distanceLabel setHidden:NO];
        [_altitudeLabel setHidden:NO];
        [_closeButton setHidden:NO];
        [_tourDescription setHidden:NO];
        [_detailButton setHidden:NO];
        
        [formatter release];
    }];
}

- (void) ShowFullTourDetail:(UIButton*)button
{
    double buttonTag = (double)[button tag];
    
    double year = floor(buttonTag/10000);
    double month = floor((buttonTag/10000 - year)*100);
    double day = ((buttonTag/10000 - year)*100 - month)*100;
    
    NSString *dateString = [NSString stringWithFormat:@"%04.0f-%02.0f-%02.0f",year,month,day];
    
    XTTourInfo *currentTour = [_calendarData objectForKey:dateString];
    
    if (!currentTour) {return;}
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    XTTourDetailView *detailView = [[XTTourDetailView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    detailView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    [detailView Initialize:currentTour fromServer:YES withOffset:70 andContentOffset:0];
    
    if (!navigationView) {navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:detailView title:@"Touren Detail" isFirstView:YES];}
    else {
        [navigationView ClearContentView];
        
        [navigationView.contentView addSubview:detailView];
    }
    
    XTNavigationViewContainer *lastNavigationViewContainer = [self lastNavigationViewContainer];
    
    [lastNavigationViewContainer.view addSubview:navigationView.view];
    
    [navigationView ShowView];
    
    [detailView LoadTourDetail:currentTour fromServer:YES];
    
    [detailView release];
}

- (XTNavigationViewContainer *) lastNavigationViewContainer {
    // convenience function for casting and to "mask" the recursive function
    return (XTNavigationViewContainer *)[self traverseResponderChainForUIViewController:self];
}

- (id) traverseResponderChainForUIViewController:(id)sender {
    id nextResponder = [sender nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        if ([nextResponder isKindOfClass:[XTNavigationViewContainer class]]) {
            NSLog(@"Found last navigation view container");
            return nextResponder;
        }
        else {
            return [self traverseResponderChainForUIViewController:nextResponder];
        }
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [self traverseResponderChainForUIViewController:nextResponder];
    } else {
        return nil;
    }
}

- (void) CloseDetailView:(id)sender
{
    [_detailView setHidden:YES];
    [_detailTitleLabel setHidden:YES];
    [_timeTitleLabel setHidden:YES];
    [_distanceTitleLabel setHidden:YES];
    [_altitudeTitleLabel setHidden:YES];
    [_timeLabel setHidden:YES];
    [_distanceLabel setHidden:YES];
    [_altitudeLabel setHidden:YES];
    [_closeButton setHidden:YES];
    [_tourDescription setHidden:YES];
    [_detailButton setHidden:YES];
    
    [self.view sendSubviewToBack:_detailView];
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

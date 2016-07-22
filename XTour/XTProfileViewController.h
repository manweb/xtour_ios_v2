//
//  XTProfileViewController.h
//  XTour
//
//  Created by Manuel Weber on 03/06/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTCalendarPageViewController.h"
#import "XTUserStatistics.h"
#import "XTServerRequestHandler.h"
#import "XTYearlyStatisticsViewController.h"

@interface XTProfileViewController : UIScrollView
{
    XTDataSingleton *data;
    XTYearlyStatisticsViewController *yearlyStatistics;
}

@property (nonatomic) float width;
@property (retain, nonatomic) UIView *profileSummary;
@property (retain, nonatomic) UIView *calendarView;
@property (retain, nonatomic) UIImageView *profilePicture;
@property (retain, nonatomic) UIButton *month;
@property (retain, nonatomic) UIButton *season;
@property (retain, nonatomic) UIButton *total;
@property (retain, nonatomic) UILabel *timeLabel;
@property (retain, nonatomic) UILabel *toursLabel;
@property (retain, nonatomic) UILabel *distanceLabel;
@property (retain, nonatomic) UILabel *altitudeLabel;
@property (retain, nonatomic) UIView *tab;
@property (retain, nonatomic) XTUserStatistics *userStatistics;

- (void)initialize;
- (void)ShowMonthlyStatistics:(id)sender;
- (void)ShowSeasonalStatistics:(id)sender;
- (void)ShowTotalStatistics:(id)sender;
- (NSString*)GetFormattedTimeString:(NSInteger)time;

@end

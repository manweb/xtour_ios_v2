//
//  XTCalendarViewController.h
//  XTour
//
//  Created by Manuel Weber on 26/09/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTTourInfo.h"
#import "XTNavigationViewContainer.h"
#import "XTTourDetailView.h"

@interface XTCalendarViewController : UIViewController
{
    XTNavigationViewContainer *navigationView;
}

@property (nonatomic,retain) UILabel *monthTitle;
@property (nonatomic) NSUInteger index;
@property (nonatomic) float calendarWidth;
@property (nonatomic) float calendarHeight;
@property (nonatomic,retain) UIColor *calendarActiveColor;
@property (nonatomic,retain) NSMutableDictionary *calendarData;
@property (nonatomic,retain) UIView *detailView;
@property (nonatomic,retain) UILabel *detailTitleLabel;
@property (nonatomic,retain) UILabel *timeTitleLabel;
@property (nonatomic,retain) UILabel *distanceTitleLabel;
@property (nonatomic,retain) UILabel *altitudeTitleLabel;
@property (nonatomic,retain) UILabel *timeLabel;
@property (nonatomic,retain) UILabel *distanceLabel;
@property (nonatomic,retain) UILabel *altitudeLabel;
@property (nonatomic,retain) UIButton *closeButton;
@property (nonatomic,retain) UITextView *tourDescription;
@property (nonatomic,retain) UIButton *detailButton;

- (void)LoadCalendarAtIndex:(NSUInteger)index;
- (void)ShowTourDetail:(UIButton*)button;
- (void)CloseDetailView:(id)sender;

@end

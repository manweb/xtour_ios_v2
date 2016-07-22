//
//  XTSummaryViewController.h
//  XTour
//
//  Created by Manuel Weber on 25/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTFileUploader.h"
#import "GoogleMaps/GoogleMaps.h"
#import "XTXMLParser.h"
#import "XTTourInfo.h"
#import "XTTourDetailView.h"
#import "DXStarRatingView.h"
#import "XTPointingNotificationView.h"

@interface XTSummaryViewController : UIViewController <UIScrollViewDelegate>
{
    XTDataSingleton *data;
    XTTourDetailView *detailView;
    GMSMapView *mapView;
    DXStarRatingView *ratingView;
}

- (IBAction)Close;
- (IBAction)Back:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *header;
@property (retain, nonatomic) IBOutlet UIView *header_shadow;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;
@property (retain, nonatomic) UIView *mapViewContainer;
@property (retain, nonatomic) UIView *summaryViewContainer;
@property (retain, nonatomic) UIView *imageViewContainer;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) UIImageView *TimeIcon;
@property (retain, nonatomic) UIImageView *DistanceIcon;
@property (retain, nonatomic) UIImageView *UpIcon;
@property (retain, nonatomic) UIImageView *DownIcon;
@property (retain, nonatomic) UILabel *TimeLabel;
@property (retain, nonatomic) UILabel *AltitudeLabel;
@property (retain, nonatomic) UILabel *UpLabel;
@property (retain, nonatomic) UILabel *DownLabel;

@end

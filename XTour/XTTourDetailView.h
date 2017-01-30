//
//  XTTourDetailView.h
//  XTour
//
//  Created by Manuel Weber on 02/05/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "XTServerRequestHandler.h"
#import "XTTourInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XTSummaryImageViewController.h"
#import "XTGraphPageViewController.h"
#import "XTDataSingleton.h"
#import "XTXMLParser.h"
#import "XTPeakFinder.h"
#import "XTUserComment.h"
@import GoogleMaps;

@interface XTTourDetailView : UIScrollView <UITableViewDelegate, UITableViewDataSource>
{
    GMSMapView *mapView;
    XTDataSingleton *data;
}

@property (retain, nonatomic) NSMutableArray *coordinateArray;
@property (retain, nonatomic) NSMutableArray *startStopCoordinates;
@property (retain, nonatomic) NSMutableArray *tourImages;
@property (retain, nonatomic) NSMutableArray *tourFiles;
@property (retain, nonatomic) NSMutableArray *tourComments;
@property (retain, nonatomic) UIView *loadingView;
@property (retain, nonatomic) UIActivityIndicatorView *activityView;
@property (retain, nonatomic) UIView *mapViewContainer;
@property (retain, nonatomic) UIView *summaryViewContainer;
@property (retain, nonatomic) UIView *imageViewContainer;
@property (retain, nonatomic) UIView *descriptionViewContainer;
@property (retain, nonatomic) UIView *graphViewContainer;
@property (retain, nonatomic) UIView *mountainPeakViewContainer;
@property (retain, nonatomic) UIView *mountainPeakExtendedView;
@property (retain, nonatomic) UITableView *mountainPeakMoreView;
@property (retain, nonatomic) UIVisualEffectView *blurEffectView;
@property (retain, nonatomic) UIView *noImagesViewContainer;
@property (retain, nonatomic) UIView *noDescriptionViewContainer;
@property (retain, nonatomic) UITextView *descriptionView;
@property (retain, nonatomic) UIImageView *profilePicture;
@property (retain, nonatomic) UILabel *TimeTitleLabel;
@property (retain, nonatomic) UILabel *DistanceTitleLabel;
@property (retain, nonatomic) UILabel *SpeedTitleLabel;
@property (retain, nonatomic) UILabel *UpTitleLabel;
@property (retain, nonatomic) UILabel *DownTitleLabel;
@property (retain, nonatomic) UILabel *HighestPointTitleLabel;
@property (retain, nonatomic) UILabel *LowestPointTitleLabel;
@property (retain, nonatomic) UILabel *UpRateTitleLabel;
@property (retain, nonatomic) UILabel *DownRateTitleLabel;
@property (retain, nonatomic) UILabel *TimeLabel;
@property (retain, nonatomic) UILabel *DistanceLabel;
@property (retain, nonatomic) UILabel *SpeedLabel;
@property (retain, nonatomic) UILabel *UpLabel;
@property (retain, nonatomic) UILabel *DownLabel;
@property (retain, nonatomic) UILabel *HighestPointLabel;
@property (retain, nonatomic) UILabel *LowestPointLabel;
@property (retain, nonatomic) UILabel *UpRateLabel;
@property (retain, nonatomic) UILabel *DownRateLabel;
@property (retain, nonatomic) UIImageView *MountainPeakIcon;
@property (retain, nonatomic) UIButton *MountainPeakMore;
@property (retain, nonatomic) UILabel *MountainPeakTitleLabel;
@property (retain, nonatomic) UILabel *MountainPeakCoordinatesLabel;
@property (retain, nonatomic) UILabel *MountainPeakAltitudeLabel;
@property (retain, nonatomic) UILabel *noPeakFoundLabel;
@property (retain, nonatomic) NSString *mountainPeak;
@property (retain, nonatomic) NSMutableArray *morePeaks;
@property (retain, nonatomic) UITextField *enterMountainPeak;
@property (nonatomic) NSInteger viewOffset;
@property (nonatomic) NSInteger viewContentOffset;
@property (nonatomic) BOOL hasDescription;
@property (retain,nonatomic) NSString *currentTourID;
@property (retain,nonatomic) UITextView *enterCommentTextView;
@property (retain,nonatomic) UILabel *enterCommentTitle;
@property (retain,nonatomic) UIButton *enterComment;
@property (nonatomic) bool didSelectRow;

- (void) Initialize:(XTTourInfo *) tourInfo fromServer:(BOOL)server withOffset:(NSInteger)offset andContentOffset:(NSInteger)offsetContent;
- (void) LoadTourDetail:(XTTourInfo *) tourInfo fromServer:(BOOL) server;
- (void) UpdateView:(XTTourInfo*) tourInfo fromServer:(BOOL)server;
- (void) EnterComment:(id)sender;
- (void) ShowMorePeaks:(id)sender;
- (void) keyboardWasShown:(NSNotification *) notification;
- (void) keyboardWillHide:(NSNotification *) notification;

@end

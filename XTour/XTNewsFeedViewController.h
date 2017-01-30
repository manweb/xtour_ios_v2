//
//  XTNewsFeedViewController.h
//  XTour
//
//  Created by Manuel Weber on 16/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTServerRequestHandler.h"
#import "XTNewsFeedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XTNavigationViewContainer.h"
#import "XTTourDetailView.h"
#import "XTTourInfo.h"
@import GoogleMaps;

@interface XTNewsFeedViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    XTDataSingleton *data;
    XTServerRequestHandler *ServerHandler;
    UIRefreshControl *refreshControl;
    XTNavigationViewContainer *navigationView;
}

@property (nonatomic,retain) NSMutableArray *news_feed;
@property (nonatomic,retain) NSMutableArray *profile_pictures;
@property (nonatomic,retain) UIView *filterTab;
@property (nonatomic,retain) UIButton *filterAll;
@property (nonatomic,retain) UIButton *filterMine;
@property (nonatomic,retain) UIButton *filterBest;
@property (nonatomic,retain) NSString *UID;
@property (nonatomic) int filter;
@property (nonatomic) NSInteger clickedButton;
@property (nonatomic,retain) UIActivityIndicatorView *appendData;
@property (nonatomic,retain) UIVisualEffectView *blurEffectView;
@property (nonatomic,retain) UIView *previewSummary;
@property (nonatomic,retain) UIView *previewSummaryContainer1;
@property (nonatomic,retain) UIView *previewSummaryContainer2;
@property (nonatomic,retain) UIView *previewMapView;
@property (nonatomic,retain) UIView *previewGraphView;
@property (nonatomic,retain) GMSMapView *map;
@property (nonatomic,retain) NSMutableArray *polylines;
@property (nonatomic,retain) UIView *loadingView;
@property (nonatomic,retain) UIImageView *previewUpArrow;
@property (nonatomic,retain) UIImageView *profilePicture;
@property (nonatomic,retain) UILabel *previewTitle;
@property (nonatomic,retain) UILabel *previewTime;
@property (nonatomic,retain) UILabel *previewAltitude;
@property (nonatomic,retain) UILabel *previewDistance;
@property (nonatomic,retain) UIView *gradientOverlay;
@property (nonatomic,retain) UITextView *previewTourDescription;
@property (nonatomic,retain) UILabel *TimeLabel;
@property (nonatomic,retain) UILabel *DistanceLabel;
@property (nonatomic,retain) UILabel *SpeedLabel;
@property (nonatomic,retain) UILabel *UpLabel;
@property (nonatomic,retain) UILabel *DownLabel;
@property (nonatomic,retain) UILabel *HighestPointLabel;
@property (nonatomic,retain) UILabel *LowestPointLabel;
@property (nonatomic,retain) UIImageView *graph;
@property (nonatomic,retain) XTTourInfo *currentPreviewTour;
@property (nonatomic) CGPoint tapPoint;
@property (nonatomic) CGRect frameOrigin;
@property (nonatomic) bool mapWasShown;
@property (nonatomic,retain) NSURLSessionTask *previewSessionTask;
@property (nonatomic,retain) NSURLSessionTask *previewSessionTask2;
@property (nonatomic,retain) UIView *noConnectionView;

- (void) refreshNewsFeed;
- (void) appendDataAndReload;
- (void) SelectAll:(id)sender;
- (void) SelectMine:(id)sender;
- (void) SelectBest:(id)sender;
- (void) MoveTabTo:(float)position;

@end

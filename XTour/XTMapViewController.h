//
//  XTSecondViewController.h
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTLoginViewController.h"
#import "XTWarningsInfo.h"
#import "XTServerRequestHandler.h"
#import "XTProfileViewController.h"
#import "XTNavigationViewContainer.h"
#import "XTAddWarningViewController.h"
@import GoogleMaps;

@interface XTMapViewController : UIViewController <UIActionSheetDelegate, GMSMapViewDelegate>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
    XTWarningsInfo *warningInfo;
    XTServerRequestHandler *request;
    XTAddWarningViewController *addWarningView;
}

@property (retain, nonatomic) IBOutlet UIView *header;
@property (retain, nonatomic) IBOutlet UIView *header_shadow;
@property (retain, nonatomic) IBOutlet UILabel *timerLabel;
@property (retain, nonatomic) NSTimer *pollingTimer;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) UIView *centerView;
@property (retain, nonatomic) UIButton *centerButton;
@property (retain, nonatomic) UIView *addWarningBackground;
@property (retain, nonatomic) UIButton *addWarningButton;
@property (retain, nonatomic) UITextView *addWarningText;
@property (retain, nonatomic) UIView *changeMapBackground;
@property (retain, nonatomic) UIButton *changeMap;
@property (retain, nonatomic) UIView *followTourView;
@property (retain, nonatomic) UILabel *followTourTitle;
@property (retain, nonatomic) UILabel *followTourTime;
@property (retain, nonatomic) UILabel *followTourDistance;
@property (retain, nonatomic) UILabel *followTourAltitude;
@property (retain, nonatomic) UIButton *removeFollowTour;
@property (retain, nonatomic) UIView *upLineView;
@property (retain, nonatomic) UIView *downLineView;
@property (retain, nonatomic) UILabel *upLineLabel;
@property (retain, nonatomic) UILabel *downLineLabel;
@property (retain, nonatomic) GMSMapView *mapView;
@property (retain, nonatomic) GMSMutablePath *path;
@property (retain, nonatomic) GMSPolyline *polyline;
@property (retain, nonatomic) GMSCameraUpdate *cameraUpdate;
@property (retain, nonatomic) GMSMarker *tempMarker;
@property (retain, nonatomic) NSMutableArray *polylines;
@property (retain, nonatomic) NSMutableArray *savedPolylines;
@property (nonatomic) NSUInteger lastRunStatus;
@property (nonatomic) bool mapHasMoved;
@property (nonatomic) bool addWarning;
@property (nonatomic) float width;
@property (nonatomic) float height;

- (void)LoadLogin:(id)sender;
- (void)ShowLoginOptions:(id)sender;
- (void)LoginViewDidClose:(id)sender;
- (void)AddWarning:(id)sender;
- (void)EnterWarning:(id)sender;
- (void)CancelEnterWarning:(id)sender;
- (void)ChangeMapType:(id)sender;
- (void)RemoveFollowTour:(id)sender;
- (void)centerMap:(id)sender;

@end

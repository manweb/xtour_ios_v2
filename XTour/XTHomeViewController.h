//
//  XTFirstViewController.h
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#include <CoreLocation/CoreLocation.h>
#include "XTXMLParser.h"
#import "XTLoginViewController.h"
#import "XTSummaryViewController.h"
#import "XTBackgroundTaskManager.h"
#import "XTNavigationViewContainer.h"
#import "XTProfileViewController.h"
#import "XTNotificationViewController.h"
#import "XTPointingNotificationView.h"
#import "XTWarningsInfo.h"
#import "XTAddWarningViewController.h"
@import GoogleMaps;

@interface XTHomeViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GMSMapViewDelegate>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
    XTSummaryViewController *summary;
    XTWarningsInfo *warningInfo;
    XTAddWarningViewController *addWarningView;
}

@property (retain, nonatomic) IBOutlet UIView *header;
@property (retain, nonatomic) IBOutlet UIView *header_shadow;
@property (retain, nonatomic) IBOutlet UIView *timerSection;
@property (retain, nonatomic) IBOutlet UIView *distanceSection;
@property (retain, nonatomic) IBOutlet UIView *altitudeSection;
@property (retain, nonatomic) IBOutlet UIView *locationSection;
@property (retain, nonatomic) IBOutlet UIView *distanceSectionSeparator;
@property (retain, nonatomic) IBOutlet UIView *altitudeSectionSeparator;
@property (retain, nonatomic) IBOutlet UIImageView *timerIcon;
@property (retain, nonatomic) IBOutlet UIImageView *distanceIcon;
@property (retain, nonatomic) IBOutlet UIImageView *altitudeIcon;
@property (retain, nonatomic) IBOutlet UIImageView *locationIcon;
@property (retain, nonatomic) IBOutlet UILabel *timerLabel;
@property (retain, nonatomic) IBOutlet UILabel *longLabel;
@property (retain, nonatomic) IBOutlet UILabel *latLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceRateLabel;
@property (retain, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (retain, nonatomic) IBOutlet UILabel *altitudeRateLabel;
@property (retain, nonatomic) IBOutlet UILabel *elevationLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalDistanceLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalAltitudeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *altitudeRateIcon;
@property (retain, nonatomic) UILabel *GPSSignalLabel;
@property (retain, nonatomic) CLGeocoder *geocoder;
@property (retain, nonatomic) CLPlacemark *placemark;
@property (retain, nonatomic) IBOutlet UIButton *StartButton;
@property (retain, nonatomic) IBOutlet UIButton *StopButton;
@property (retain, nonatomic) IBOutlet UIButton *PauseButton;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIImageView *GPSSignal;
@property (retain, nonatomic) NSTimer *pollingTimer;
@property (retain, nonatomic) NSTimer *locationStartTimer;
@property (retain, nonatomic) NSTimer *locationStopTimer;
@property (nonatomic) NSInteger runStatus;
@property (nonatomic) double oldAccuracy;
@property (nonatomic) NSInteger recoveryTimer;
@property (nonatomic) bool didReachInitialAccuracy;
@property (nonatomic) bool didRecoverTour;
@property (nonatomic) bool writeRecoveryFile;
@property (retain, nonatomic) CLLocation *bestLocation;
@property (retain, nonatomic) XTBackgroundTaskManager *backgroundTaskManager;
@property (retain, nonatomic) NSString *up_button_icon;
@property (retain, nonatomic) NSString *down_button_icon;
@property (retain, nonatomic) UIView *warningNotification;

@property (retain, nonatomic) UIView *centerView;
@property (retain, nonatomic) UIButton *centerButton;
@property (retain, nonatomic) UIView *addWarningBackground;
@property (retain, nonatomic) UIButton *addWarningButton;
@property (retain, nonatomic) UITextView *addWarningText;
@property (retain, nonatomic) UIView *changeMapBackground;
@property (retain, nonatomic) UIButton *changeMap;
@property (retain, nonatomic) UIView *addPictureBackground;
@property (retain, nonatomic) UIButton *addPictureButton;
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
@property(retain, nonatomic) UIImagePickerController *ImagePicker;
@property(nonatomic) BOOL didPickImage;
@property(nonatomic) BOOL hasInitializedIcons;
@property (retain, nonatomic) IBOutlet UIView *locationBackground;

- (IBAction)startUpTour:(id)sender;
- (IBAction)startDownTour:(id)sender;
- (IBAction)pauseTour:(id)sender;
- (void)startLocationUpdate;
- (void)stopLocationUpdate:(bool)saveLocation;
- (void)stopLocationUpdate;
- (void)LoadLogin:(id)sender;
- (void)ShowLoginOptions:(id)sender;
- (void)LoginViewDidClose:(id)sender;
- (void)UpdateDisplayWithLocation:(CLLocation*)location;
- (void)SaveCurrentLocation:(CLLocation*)location;
- (void)ResetTour;
- (void)FinishTour:(bool)batteryIsLow;

- (void)AddWarning:(id)sender;
- (void)EnterWarning:(id)sender;
- (void)CancelEnterWarning:(id)sender;
- (void)ChangeMapType:(id)sender;
- (void)RemoveFollowTour:(id)sender;
- (void)centerMap:(id)sender;
- (void)UpdateMap:(CLLocation*)location;
- (void) LoadCamera:(id)sender;

@end

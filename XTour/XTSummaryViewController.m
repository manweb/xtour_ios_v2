//
//  XTSummaryViewController.m
//  XTour
//
//  Created by Manuel Weber on 25/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTSummaryViewController.h"

@interface XTSummaryViewController ()

@end

@implementation XTSummaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _header.frame = CGRectMake(0, 0, width, 69);
    _header_shadow.frame = CGRectMake(0, 69, width, 1);
    
    _closeButton.frame = CGRectMake(width-100, 30, 80, 30);
    
    _closeButton.layer.cornerRadius = 15.0;
    _closeButton.layer.borderWidth = 1.0;
    _closeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    data = [XTDataSingleton singleObj];
    
    XTTourInfo *tourInfo = [[XTTourInfo alloc] init];
    tourInfo.tourID = data.tourID;
    tourInfo.userID = data.userID;
    tourInfo.profilePicture = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
    tourInfo.date = [data.TotalStartTime timeIntervalSince1970];
    tourInfo.userName = @"";
    tourInfo.totalTime = data.totalTime;
    tourInfo.longitude = data.StartLocation.coordinate.longitude;
    tourInfo.latitude = data.StartLocation.coordinate.latitude;
    tourInfo.distance = data.sumDistance;
    tourInfo.altitude = data.sumCumulativeAltitude;
    tourInfo.descent = data.sumCumulativeDescent;
    tourInfo.highestPoint = data.sumhighestPoint.altitude;
    tourInfo.lowestPoint = data.sumlowestPoint.altitude;
    tourInfo.tourDescription = @"";
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    detailView = [[XTTourDetailView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    detailView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    UIView *ratingViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, height-tabBarHeight-70, width, 50)];
    ratingViewContainer.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    
    ratingView = [[DXStarRatingView alloc] initWithFrame:CGRectMake(20, 5, width, 40)];
    [ratingView setStars:0 callbackBlock:^(NSNumber *newRating) {
        data.tourRating = [newRating integerValue];
    }];
    
    [ratingViewContainer addSubview:ratingView];
    
    [self.view addSubview:detailView];
    [self.view addSubview:ratingViewContainer];
    
    [self.view bringSubviewToFront:_header];
    [self.view bringSubviewToFront:_header_shadow];
    
    [detailView Initialize:tourInfo fromServer:NO withOffset:70 andContentOffset:0];
    
    [detailView LoadTourDetail:tourInfo fromServer:NO];
    
    [detailView release];
    [ratingViewContainer release];
    [ratingView release];
    [tourInfo release];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(ShowNotification) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ShowNotification
{
    XTPointingNotificationView *notification = [[XTPointingNotificationView alloc] initWithSize:CGSizeMake(self.view.frame.size.width-40, 40) pointingAt:CGPointMake(_closeButton.frame.origin.x+_closeButton.frame.size.width/2, 60) direction:1 message:@"Nicht vergessen Tour abzuschliessen!"];
    
    [self.view addSubview:notification];
    
    [notification animateWithTimeout:5];
}

- (IBAction)Close {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (detailView.hasDescription) {data.tourDescription = detailView.descriptionView.text;}
        data.mountainPeak = detailView.mountainPeak;
        [data CreateXMLForCategory:@"sum"];
        [data WriteImageInfo];
        
        data.runStatus = 5;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [data ResetAll];
            
            XTFileUploader *uploader = [[XTFileUploader alloc] init];
            [uploader UploadGPXFiles];
            [uploader UploadImages];
            [uploader UploadImageInfo];
        });
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [_TimeLabel release];
    [_AltitudeLabel release];
    [_UpLabel release];
    [_DownLabel release];
    [_scrollView release];
    [_TimeIcon release];
    [_DistanceIcon release];
    [_UpIcon release];
    [_DownIcon release];
    [_mapViewContainer release];
    [_summaryViewContainer release];
    [_imageViewContainer release];
    [_header release];
    [_header_shadow release];
    [_closeButton release];
    [super dealloc];
}
@end

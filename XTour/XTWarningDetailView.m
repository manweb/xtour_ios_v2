//
//  XTWarningDetailView.m
//  XTour
//
//  Created by Manuel Weber on 21/01/16.
//  Copyright © 2016 Manuel Weber. All rights reserved.
//

#import "XTWarningDetailView.h"

@interface XTWarningDetailView ()

@end

@implementation XTWarningDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    float boxRadius = 5.f;
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    _backgroundView.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurEffectView.frame = self.view.frame;
    _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [_blurEffectView setHidden:YES];
    
    [_backgroundView addSubview:_blurEffectView];
    
    _cellView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, width-20, 100)];
    
    _cellView.backgroundColor = [UIColor whiteColor];
    _cellView.layer.cornerRadius = boxRadius;
    
    [_cellView setHidden:YES];
    
    UIImageView *warningIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    
    warningIcon.image = [UIImage imageNamed:@"warning_icon@3x.png"];
    
    _warningTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 235, 20)];
    
    _warningTitle.font = [UIFont fontWithName:@"Helvetica-BoldMT" size:12];
    _warningTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    _warningDescription = [[UITextView alloc] initWithFrame:CGRectMake(60, 25, 235, 60)];
    
    _warningDescription.font = [UIFont fontWithName:@"Helvetica" size:12];
    _warningDescription.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
    [_warningDescription setEditable:NO];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    closeButton.frame = CGRectMake(width-45, 5, 20, 20);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_icon@3x.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(Close:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cellView addSubview:warningIcon];
    [_cellView addSubview:_warningTitle];
    [_cellView addSubview:_warningDescription];
    [_cellView addSubview:closeButton];
    
    _mapViewContainer = [[UIView alloc] initWithFrame:CGRectMake(10, 155, width-20, 200)];
    
    _descriptionViewContainer = [[UIView alloc] initWithFrame:CGRectMake(10, 360, width-20, 150)];
    
    _mapViewContainer.backgroundColor = [UIColor whiteColor];
    _mapViewContainer.layer.cornerRadius = boxRadius;
    
    _descriptionViewContainer.backgroundColor = [UIColor whiteColor];
    _descriptionViewContainer.layer.cornerRadius = boxRadius;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.770809 longitude:8.377733 zoom:6];
    if (!mapView) {mapView = [GMSMapView mapWithFrame:CGRectMake(5, 5, width - 30, 190) camera:camera];}
    
    mapView.mapType = kGMSTypeTerrain;
    
    mapView.myLocationEnabled = YES;
    
    [_mapViewContainer addSubview:mapView];
    
    _descriptionTextField = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, width-30, 140)];
    
    _descriptionTextField.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    _descriptionTextField.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
    [_descriptionTextField setEditable:NO];
    [_descriptionTextField setScrollEnabled:YES];
    
    [_descriptionViewContainer addSubview:_descriptionTextField];
    
    [_mapViewContainer setAlpha:0.0];
    
    [_descriptionViewContainer setAlpha:0.0];
    
    [_backgroundView addSubview:_cellView];
    [_backgroundView addSubview:_mapViewContainer];
    [_backgroundView addSubview:_descriptionViewContainer];
    
    [self.view addSubview:_backgroundView];
    
    [warningIcon release];
    
    _categories = [[NSMutableArray alloc] initWithObjects:@"Lawinenabgang",@"Instabile Unterlage",@"Spalten",@"Steinschlag",@"Sonst etwas", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) LoadInfo:(XTWarningsInfo *)warningsInfo withFrame:(CGRect)frame
{
    _cellView.frame = CGRectMake(frame.origin.x, frame.origin.y+21, frame.size.width, frame.size.height);
    
    [_cellView setHidden:NO];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[warningsInfo.submitDate integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *formattedDate = [formatter stringFromDate:date];
    
    if ([[_categories objectAtIndex:warningsInfo.category] isEqualToString:@"Sonst etwas"]) {_warningTitle.text = @"Gefahrenstelle";}
    else {_warningTitle.text = [_categories objectAtIndex:warningsInfo.category];}
    _warningDescription.text = [NSString stringWithFormat:@"Eingetragen von %@ am %@. Distanz zur Gefahrenstelle: %.1f km",warningsInfo.userName,formattedDate,warningsInfo.distance];
    
    _descriptionTextField.text = warningsInfo.comment;
    
    GMSMarker *Marker = [[GMSMarker alloc] init];
    
    Marker.position = CLLocationCoordinate2DMake(warningsInfo.latitude, warningsInfo.longitude);
    Marker.icon = [UIImage imageNamed:@"ski_pole_warning@3x.png"];
    Marker.groundAnchor = CGPointMake(0.88, 1.0);
    Marker.map = mapView;
    
    [mapView setCamera:[GMSCameraPosition cameraWithLatitude:warningsInfo.latitude longitude:warningsInfo.longitude zoom:14]];
}

- (void) Animate
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        [_blurEffectView setHidden:NO];
        
        CGRect cellFrame = _cellView.frame;
        
        _cellView.frame = CGRectMake(cellFrame.origin.x, 50, cellFrame.size.width, cellFrame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
            [_mapViewContainer setAlpha:1.0];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
                [_descriptionViewContainer setAlpha:1.0];
            } completion:NULL
             ];
        }];}];
}

- (void) Close:(id)sender
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        [_backgroundView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
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

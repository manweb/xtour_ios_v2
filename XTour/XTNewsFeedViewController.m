//
//  XTNewsFeedViewController.m
//  XTour
//
//  Created by Manuel Weber on 16/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTNewsFeedViewController.h"

@interface XTNewsFeedViewController ()

@end

@implementation XTNewsFeedViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [UITabBarController new];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    data = [XTDataSingleton singleObj];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    UIView *header_shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 20, width, 1)];
    
    header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    // Register cell classes
    [self.collectionView registerClass:[XTNewsFeedCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(61, 0, tabBarHeight, 0)];
    
    // Do any additional setup after loading the view.
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 21, width, 40)];
    
    filterView.backgroundColor = [UIColor whiteColor];
    filterView.alpha = 0.9f;
    
    _filterTab = [[UIView alloc] initWithFrame:CGRectMake(5, 28, 100, 2)];
    
    _filterTab.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    
    _filterAll = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _filterAll.frame = CGRectMake(5, 10, 100, 16);
    [_filterAll setTitle:@"Alle" forState:UIControlStateNormal];
    [_filterAll setTitleColor:[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f] forState:UIControlStateNormal];
    [_filterAll addTarget:self action:@selector(SelectAll:) forControlEvents:UIControlEventTouchUpInside];
    
    _filterMine = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _filterMine.frame = CGRectMake(width/2-50, 10, 100, 16);
    [_filterMine setTitle:@"Meine" forState:UIControlStateNormal];
    [_filterMine setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterMine addTarget:self action:@selector(SelectMine:) forControlEvents:UIControlEventTouchUpInside];
    
    _filterBest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _filterBest.frame = CGRectMake(width-105, 10, 100, 16);
    [_filterBest setTitle:@"Beste" forState:UIControlStateNormal];
    [_filterBest setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterBest addTarget:self action:@selector(SelectBest:) forControlEvents:UIControlEventTouchUpInside];
    
    [filterView addSubview:_filterAll];
    [filterView addSubview:_filterMine];
    [filterView addSubview:_filterBest];
    [filterView addSubview:_filterTab];
    [self.view addSubview:filterView];
    
    _UID = @"0";
    _filter = 0;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(HandleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //seconds
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
    [lpgr release];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurEffectView.frame = self.view.frame;
    _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [_blurEffectView setHidden:YES];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:_blurEffectView];
    
    _previewSummary = [[UIView alloc] initWithFrame:CGRectMake(10, 10, width-20, 100)];
    
    _previewSummary.backgroundColor = [UIColor whiteColor];
    _previewSummary.layer.cornerRadius = 5.0f;
    _previewSummary.layer.borderWidth = 1.0f;
    _previewSummary.layer.borderColor = [[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f] CGColor];
    [_previewSummary setHidden:YES];
    
    _previewUpArrow = [[UIImageView alloc] initWithFrame:CGRectMake(width/2-15, 10, 30, 30)];
    
    [_previewUpArrow setImage:[UIImage imageNamed:@"arrow_up_preview@3x.png"]];
    [_previewUpArrow setHidden:YES];
    
    _previewMapView = [[UIView alloc] initWithFrame:CGRectMake(10, 120, width-20, 200)];
    
    _previewMapView.backgroundColor = [UIColor whiteColor];
    _previewMapView.layer.cornerRadius = 5.0f;
    _previewMapView.layer.borderWidth = 1.0f;
    _previewMapView.layer.borderColor = [[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f] CGColor];
    [_previewMapView setHidden:YES];
    [_previewMapView setAlpha:0.0];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.770809 longitude:8.377733 zoom:6];
    if (!_map) {_map = [GMSMapView mapWithFrame:CGRectMake(5, 5, width - 30, 190) camera:camera];}
    
    _map.mapType = kGMSTypeTerrain;
    
    [_previewMapView addSubview:_map];
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake((width-20)/2-50, 50, 100, 100)];
    _loadingView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6];
    _loadingView.layer.cornerRadius = 10.0f;
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(20, 20, 60, 60);
    [activityView startAnimating];
    
    [_loadingView addSubview:activityView];
    
    [activityView release];
    
    [_loadingView setHidden:YES];
    
    [_previewMapView addSubview:_loadingView];
    
    _previewGraphView = [[UIView alloc] initWithFrame:CGRectMake(10, 330, width-20, width/320*200+10)];
    
    _previewGraphView.backgroundColor = [UIColor whiteColor];
    _previewGraphView.layer.cornerRadius = 5.0f;
    _previewGraphView.layer.borderWidth = 1.0f;
    _previewGraphView.layer.borderColor = [[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f] CGColor];
    [_previewGraphView setHidden:YES];
    [_previewGraphView setAlpha:0.0];
    
    _profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(8, 25, 50, 50)];
    _previewTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 223, 15)];
    _previewTime = [[UILabel alloc] initWithFrame:CGRectMake(60, 60, 70, 15)];
    _previewAltitude = [[UILabel alloc] initWithFrame:CGRectMake(130, 60, 50, 15)];
    _previewDistance = [[UILabel alloc] initWithFrame:CGRectMake(190, 60, 50, 15)];
    
    _previewTitle.font = [UIFont fontWithName:@"Helvetica" size:12];
    _previewTime.font = [UIFont fontWithName:@"Helvetica" size:10];
    _previewAltitude.font = [UIFont fontWithName:@"Helvetica" size:10];
    _previewDistance.font = [UIFont fontWithName:@"Helvetica" size:10];
    
    _previewTitle.textAlignment = NSTextAlignmentLeft;
    _previewTime.textAlignment = NSTextAlignmentCenter;
    _previewAltitude.textAlignment = NSTextAlignmentCenter;
    _previewDistance.textAlignment = NSTextAlignmentCenter;
    
    _previewTitle.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    
    UIImageView *timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(80, 30, 30, 30)];
    UIImageView *altitudeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(140, 30, 30, 30)];
    UIImageView *distanceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(200, 30, 30, 30)];
    
    timeIcon.image = [UIImage imageNamed:@"clock_icon.png"];
    altitudeIcon.image = [UIImage imageNamed:@"altitude_icon.png"];
    distanceIcon.image = [UIImage imageNamed:@"skier_up_icon.png"];
    
    _previewTourDescription = [[UITextView alloc] initWithFrame:CGRectMake(5, 80, _previewSummary.frame.size.width-10, 60)];
    
    _previewTourDescription.textColor = [UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
    _previewTourDescription.font = [UIFont fontWithName:@"Helvetica" size:12];
    _previewTourDescription.editable = NO;
    _previewTourDescription.scrollEnabled = NO;
    
    _gradientOverlay = [[UIView alloc] initWithFrame:CGRectMake(5, 80, _previewSummary.frame.size.width-10, 60)];
    
    _gradientOverlay.backgroundColor = [UIColor whiteColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _gradientOverlay.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(1.0f, 0.2f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    _gradientOverlay.layer.mask = gradientLayer;
    
    _previewSummaryContainer1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width-20, 140)];
    
    _previewSummaryContainer1.backgroundColor = [UIColor clearColor];
    
    _previewSummaryContainer2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width-20, 140)];
    
    _previewSummaryContainer2.backgroundColor = [UIColor clearColor];
    [_previewSummaryContainer2 setAlpha:0.0];
    
    [_previewSummary addSubview:_profilePicture];
    [_previewSummaryContainer1 addSubview:_previewTitle];
    [_previewSummaryContainer1 addSubview:_previewTime];
    [_previewSummaryContainer1 addSubview:_previewAltitude];
    [_previewSummaryContainer1 addSubview:_previewDistance];
    [_previewSummaryContainer1 addSubview:timeIcon];
    [_previewSummaryContainer1 addSubview:altitudeIcon];
    [_previewSummaryContainer1 addSubview:distanceIcon];
    [_previewSummaryContainer1 addSubview:_previewTourDescription];
    [_previewSummaryContainer1 addSubview:_gradientOverlay];
    
    [_previewSummary addSubview:_previewSummaryContainer1];
    [_previewSummary addSubview:_previewSummaryContainer2];
    
    [timeIcon release];
    [altitudeIcon release];
    [distanceIcon release];
    
    float boxWidth = width-20;
    
    float labelX1 = 5;
    float labelX2 = (boxWidth-10)/3;
    float labelX3 = (boxWidth-10)*2/3;
    
    UILabel *DistanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 58, 100, 15)];
    UILabel *SpeedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 58, 100, 15)];
    UILabel *UpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 58, 100, 15)];
    UILabel *DownTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 100, 100, 15)];
    UILabel *HighestPointTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 100, 100, 15)];
    UILabel *LowestPointTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 100, 100, 15)];
    
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(boxWidth/3-10, 15, boxWidth*2/3-10, 30)];
    _DistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 72, 100, 20)];
    _SpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 72, 100, 20)];
    _UpLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 72, 100, 20)];
    _DownLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 114, 100, 20)];
    _HighestPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 114, 100, 20)];
    _LowestPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 114, 100, 20)];
    
    DistanceTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    SpeedTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    UpTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    DownTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    HighestPointTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    LowestPointTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    
    _TimeLabel.textAlignment = NSTextAlignmentRight;
    
    DistanceTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    SpeedTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    UpTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    DownTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    HighestPointTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    LowestPointTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    
    _TimeLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*32.0f];
    _DistanceLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _SpeedLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _UpLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _DownLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _HighestPointLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _LowestPointLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    
    DistanceTitleLabel.text = @"Distanz";
    SpeedTitleLabel.text = @"Geschwindigkeit";
    UpTitleLabel.text = @"Aufstieg";
    DownTitleLabel.text = @"Abfahrt";
    HighestPointTitleLabel.text = @"Höchster Punkt";
    LowestPointTitleLabel.text = @"Tiefster Punkt";
    
    [_previewSummaryContainer2 addSubview:_TimeLabel];
    [_previewSummaryContainer2 addSubview:DistanceTitleLabel];
    [_previewSummaryContainer2 addSubview:SpeedTitleLabel];
    [_previewSummaryContainer2 addSubview:UpTitleLabel];
    [_previewSummaryContainer2 addSubview:DownTitleLabel];
    [_previewSummaryContainer2 addSubview:HighestPointTitleLabel];
    [_previewSummaryContainer2 addSubview:LowestPointTitleLabel];
    [_previewSummaryContainer2 addSubview:_DistanceLabel];
    [_previewSummaryContainer2 addSubview:_SpeedLabel];
    [_previewSummaryContainer2 addSubview:_UpLabel];
    [_previewSummaryContainer2 addSubview:_DownLabel];
    [_previewSummaryContainer2 addSubview:_HighestPointLabel];
    [_previewSummaryContainer2 addSubview:_LowestPointLabel];
    
    [DistanceTitleLabel release];
    [SpeedTitleLabel release];
    [UpTitleLabel release];
    [DownTitleLabel release];
    [HighestPointTitleLabel release];
    [LowestPointTitleLabel release];
    
    _graph = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, width-30, width/320*152)];
    
    [_previewGraphView addSubview:_graph];
    
    [_blurEffectView addSubview:_previewSummary];
    [_blurEffectView addSubview:_previewUpArrow];
    [_blurEffectView addSubview:_previewMapView];
    [_blurEffectView addSubview:_previewGraphView];
    
    _mapWasShown = false;
    
    _appendData = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    _appendData.frame = CGRectMake(width/2-15, 0, 30, 30);
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height/2-20, width, 40)];
    
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    emptyLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"Keine Internetverbindung";
    
    _noConnectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    UIImageView *noConnectionImage = [[UIImageView alloc] initWithFrame:CGRectMake((width-100)/2, height/2+20, 100, 40)];
    
    [noConnectionImage setImage:[UIImage imageNamed:@"NoConnection@3x.png"]];
    
    [_noConnectionView addSubview:emptyLabel];
    [_noConnectionView addSubview:noConnectionImage];
    
    [emptyLabel release];
    [noConnectionImage release];
    
    [self.view addSubview:header];
    [self.view addSubview:header_shadow];
    
    [header release];
    [header_shadow release];
    
    ServerHandler = [[XTServerRequestHandler alloc] init];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    if (refreshControl == nil) {
        refreshControl = [[UIRefreshControl alloc] init];
    }
    [refreshControl addTarget:self action:@selector(refreshNewsFeed) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    [refreshControl beginRefreshing];
    
    [self refreshNewsFeed];
    
    /*dispatch_queue_t fetch = dispatch_queue_create("fetchQueue", NULL);
    
    dispatch_async(fetch, ^{
        self.news_feed = [ServerHandler GetNewsFeedString:10 forUID:@"0" filterBest:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            
            [refreshControl endRefreshing];
        });
    });
    
    dispatch_release(fetch);*/
}

- (void) viewWillAppear:(BOOL)animated
{
    [navigationView.backButton setHidden:NO];
    [navigationView.navigationTitle setHidden:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [navigationView.backButton setHidden:YES];
    [navigationView.navigationTitle setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_news_feed release];
    [_profile_pictures release];
    [super dealloc];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.news_feed count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XTNewsFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.backgroundColor = [UIColor whiteColor];
    
    XTTourInfo *currentElement = [self.news_feed objectAtIndex:indexPath.row];
    
    NSUInteger timestamp = currentElement.date;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *formattedDate = [formatter stringFromDate:date];
    
    NSUInteger tm = currentElement.totalTime;
    
    NSString *TimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                            lround(floor(tm / 3600.)) % 100,
                            lround(floor(tm / 60.)) % 60,
                            lround(floor(tm)) % 60];
    
    [cell.profilePicture setImageWithURL:[NSURL URLWithString:currentElement.profilePicture] placeholderImage:[UIImage imageNamed:@"profile_icon_gray.png"]];
    
    cell.title.text = [NSString stringWithFormat:@"%@ am %@",currentElement.userName, formattedDate];
    cell.time.text = TimeString;
    cell.altitude.text = [NSString stringWithFormat:@"%.1f m", currentElement.altitude];
    cell.distance.text = [NSString stringWithFormat:@"%.2f km", currentElement.distance];
    cell.tourDescription.text = currentElement.tourDescription;
    
    if ([currentElement.tourDescription isEqualToString:@""]) {
        [cell.tourDescription setHidden:YES];
        [cell.gradientOverlay setHidden:YES];
    }
    else {
        [cell.tourDescription setHidden:NO];
        [cell.gradientOverlay setHidden:NO];
    }
    
    [cell.moreButton addTarget:self action:@selector(ShowOptions:) forControlEvents:UIControlEventTouchUpInside];
    [cell.moreButton setTag:indexPath.row];
    
    [cell SetNumberOfComments:currentElement.numberOfComments andNumberOfPictures:currentElement.numberOfImages];
    
    if ([self.news_feed count] - 1 == indexPath.row) {[self appendDataAndReload];}
    
    [formatter release];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    //float imageOriginX = attributes.frame.origin.x + 8;
    //float imageOriginY = attributes.frame.origin.y + 25 - collectionView.contentOffset.y;
    
    XTTourInfo *currentElement = [self.news_feed objectAtIndex:indexPath.row];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [UITabBarController new];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    XTTourDetailView *detailView = [[XTTourDetailView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    detailView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    [detailView Initialize:currentElement fromServer:YES withOffset:70 andContentOffset:tabBarHeight];
    
    if (!navigationView) {
        navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:detailView title:@"Touren Detail" isFirstView:YES];
        
        //[navigationView.header removeFromSuperview];
        //[navigationView.header_shadow removeFromSuperview];
        //[navigationView.header_background removeFromSuperview];
    }
    else {
        [navigationView ClearContentView];
        
        [navigationView.contentView addSubview:detailView];
    }
    
    [self.view addSubview:navigationView.view];
    
    //[[UIApplication sharedApplication].keyWindow addSubview:navigationView.backButton];
    
    //XTNavigationViewContainer *lastNavigationViewContainer = [self lastNavigationViewContainer];
    
    //[lastNavigationViewContainer.view addSubview:navigationView.view];
    
    //[self.view addSubview:navigationView.view];
    
    [navigationView ShowView];
    
    [navigationView.loginButton setImage:nil forState:UIControlStateNormal];
    [navigationView.loginButton setBackgroundImage:[UIImage imageNamed:@"dots_icon_white@3x.png"] forState:UIControlStateNormal];
    [navigationView.loginButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [navigationView.loginButton addTarget:self action:@selector(ShowOptionsWithNoDetail:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView.loginButton setTag:indexPath.row];
    
    [detailView LoadTourDetail:currentElement fromServer:YES];
    
    [detailView release];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    
    float boxWidth = width - 20;
    float height;
    
    XTTourInfo *currentElement = [self.news_feed objectAtIndex:indexPath.row];
    if ([currentElement.tourDescription isEqualToString:@""]) {height = 100;}
    else {height = 140;}
    
    return CGSizeMake(boxWidth, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (void) refreshNewsFeed
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_news_feed_string.php?num=%i&uid=%@&filter=%i", 10, _UID, _filter];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfiguration.timeoutIntervalForRequest = 10.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
        if (error) {
            self.collectionView.backgroundView = _noConnectionView;
            
            [refreshControl endRefreshing];
            
            return;
        }
        
        self.collectionView.backgroundView = nil;
        
        self.news_feed = [ServerHandler GetNewsFeedString:(NSData*)responseData];
        
        [self.collectionView reloadData];
        
        [refreshControl endRefreshing];
    }];
    
    [sessionTask resume];
    
    /*dispatch_queue_t fetch = dispatch_queue_create("fetchQueue", NULL);
    
    dispatch_async(fetch, ^{
        self.news_feed = [ServerHandler GetNewsFeedString:10 forUID:_UID filterBest:_filter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            
            [refreshControl endRefreshing];
        });
    });
    
    dispatch_release(fetch);*/
}

- (void) appendDataAndReload
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_news_feed_string.php?num=%i&start=%lu&uid=%@&filter=%i", 10, (unsigned long)[self.news_feed count], _UID, _filter];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfiguration.timeoutIntervalForRequest = 10.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message: @"Da ist etwas schief gelaufen. Stelle sicher, dass du Verbindung zum Internet hast." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            //[refreshControl endRefreshing];
            
            return;
        }
        
        NSMutableArray *append_data = [ServerHandler GetNewsFeedString:(NSData*)responseData];
        
        [self.news_feed addObjectsFromArray:append_data];
        
        [self.collectionView reloadData];
        
        //[refreshControl endRefreshing];
    }];
    
    [sessionTask resume];
}

- (void)SelectAll:(id)sender
{
    float position = _filterAll.frame.origin.x;
    
    [self MoveTabTo:position];
    
    [_filterAll setTitleColor:[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f] forState:UIControlStateNormal];
    [_filterMine setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterBest setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    _UID = @"0";
    _filter = 0;
    
    [self refreshNewsFeed];
}

- (void)SelectMine:(id)sender
{
    if (!data.loggedIn) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Du musst dich einloggen um deine Touren anzuzeigen. Klicke auf das Profil-Icon." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        return;
    }
    
    float position = _filterMine.frame.origin.x;
    
    [self MoveTabTo:position];
    
    [_filterAll setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterMine setTitleColor:[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f] forState:UIControlStateNormal];
    [_filterBest setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    _UID = data.userID;
    _filter = 0;
    
    [self refreshNewsFeed];
}

- (void)SelectBest:(id)sender
{
    float position = _filterBest.frame.origin.x;
    
    [self MoveTabTo:position];
    
    [_filterAll setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterMine setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterBest setTitleColor:[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f] forState:UIControlStateNormal];
    
    _UID = @"0";
    _filter = 1;
    
    [self refreshNewsFeed];
}

- (void)MoveTabTo:(float)position
{
    CGRect frame = _filterTab.frame;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _filterTab.frame = CGRectMake(position, frame.origin.y, frame.size.width, frame.size.height);
    } completion:nil];
}

- (void) ShowOptions:(id)sender
{
    _clickedButton = [(UIButton*)sender tag];
    
    XTTourInfo *currentElement = [self.news_feed objectAtIndex:_clickedButton];
    
    if ([currentElement.userID isEqualToString:data.userInfo.userID]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:@"Tour löschen" otherButtonTitles:@"Tour verstecken", @"Zur Wunschliste", @"Zeige Details", nil];
        
        [actionSheet showInView:self.view];
        
        [actionSheet release];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:nil otherButtonTitles:@"Zur Wunschliste", @"Zeige Details", nil];
        
        [actionSheet showInView:self.view];
        
        [actionSheet release];
    }
}

- (void) ShowOptionsWithNoDetail:(id)sender
{
    _clickedButton = [(UIButton*)sender tag];
    
    XTTourInfo *currentElement = [self.news_feed objectAtIndex:_clickedButton];
    
    if ([currentElement.userID isEqualToString:data.userInfo.userID]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:@"Tour löschen" otherButtonTitles:@"Tour verstecken", @"Zur Wunschliste", nil];
        
        [actionSheet showInView:self.view];
        
        [actionSheet release];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:nil otherButtonTitles:@"Zur Wunschliste", nil];
        
        [actionSheet showInView:self.view];
        
        [actionSheet release];
    }
}

- (void) HandleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    /*CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForRowAtPoint:p];
    
    XTTourInfo *currentTour = [_news_feed objectAtIndex:indexPath.row];
    
    NSLog(@"Selected tour: %f",currentTour.distance);*/
    
    float scrollPosition = self.collectionView.contentOffset.y+110;
    
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Getting cell for position %f",p.y);
        
        NSInteger index = [self indexOfCellAtPosition:p.y];
        
        _currentPreviewTour = [_news_feed objectAtIndex:index];
        
        NSUInteger timestamp = _currentPreviewTour.date;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy"];
        NSString *formattedDate = [formatter stringFromDate:date];
        
        NSUInteger tm = _currentPreviewTour.totalTime;
        
        NSString *TimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                                lround(floor(tm / 3600.)) % 100,
                                lround(floor(tm / 60.)) % 60,
                                lround(floor(tm)) % 60];
        
        [_profilePicture setImageWithURL:[NSURL URLWithString:_currentPreviewTour.profilePicture] placeholderImage:[UIImage imageNamed:@"profile_icon_gray.png"]];
        
        _previewTitle.text = [NSString stringWithFormat:@"%@ am %@",_currentPreviewTour.userName, formattedDate];
        _previewTime.text = TimeString;
        _previewAltitude.text = [NSString stringWithFormat:@"%.1f m", _currentPreviewTour.altitude];
        _previewDistance.text = [NSString stringWithFormat:@"%.2f km", _currentPreviewTour.distance];
        _previewTourDescription.text = _currentPreviewTour.tourDescription;
        
        float distance = _currentPreviewTour.distance;
        float time = (float)_currentPreviewTour.totalTime/3600.0;
        float speed = distance/time;
        
        NSString *distanceUnit = @"km";
        NSString *speedUnit = @"km/h";
        
        if (distance < 10.0) {
            distance *= 1000.0;
            distanceUnit = @"m";
        }
        
        if (speed < 10.0) {
            speed *= 1000.0;
            speedUnit = @"m/h";
        }
        
        _TimeLabel.text = TimeString;
        _DistanceLabel.text = [NSString stringWithFormat:@"%.1f %@", distance, distanceUnit];
        _SpeedLabel.text = [NSString stringWithFormat:@"%.1f %@", speed, speedUnit];
        _UpLabel.text = [NSString stringWithFormat:@"%.1f m", _currentPreviewTour.altitude];
        _DownLabel.text = [NSString stringWithFormat:@"%.1f m", _currentPreviewTour.descent];
        _HighestPointLabel.text = [NSString stringWithFormat:@"%.1f m", _currentPreviewTour.highestPoint];
        _LowestPointLabel.text = [NSString stringWithFormat:@"%.1f m", _currentPreviewTour.lowestPoint];
        
        if ([_currentPreviewTour.tourDescription isEqualToString:@""]) {
            [_previewTourDescription setHidden:YES];
            [_gradientOverlay setHidden:YES];
        }
        else {
            [_previewTourDescription setHidden:NO];
            [_gradientOverlay setHidden:NO];
        }
        
        NSURL *graphURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.xtour.ch/users/%@/tours/%@/%@_graph1.png", _currentPreviewTour.userID, _currentPreviewTour.tourID, _currentPreviewTour.tourID]];
        
        [_graph setImageWithURL:graphURL placeholderImage:nil];
        
        NSLog(@"%f",_currentPreviewTour.distance);
        
        CGRect cellFrame = [self frameForCellAtIndex:index scrollPosition:scrollPosition];
        
        _frameOrigin = cellFrame;
        
        _tapPoint = p;
        
        NSLog(@"%f %f %f %f",cellFrame.origin.x,cellFrame.origin.y,cellFrame.size.width,cellFrame.size.height);
        
        _previewSummary.frame = cellFrame;
        
        _previewUpArrow.frame = CGRectMake((cellFrame.size.width+20)/2-15, cellFrame.origin.y-35, 30, 30);
        
        [_blurEffectView setHidden:NO];
        
        [_previewSummary setHidden:NO];
        
        [_previewUpArrow setHidden:NO];
        
        [_previewMapView setHidden:NO];
        
        [_previewGraphView setHidden:NO];
        
        _profilePicture.frame = CGRectMake(8, 25, 50, 50);
        
        [_previewSummaryContainer1 setAlpha:1.0];
        
        [_previewSummaryContainer2 setAlpha:0.0];
        
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
            if (_frameOrigin.size.height < 140) {
                _previewSummary.frame = CGRectMake(_frameOrigin.origin.x, _frameOrigin.origin.y-40, _frameOrigin.size.width, 140);
                
                _previewUpArrow.frame = CGRectMake((cellFrame.size.width+20)/2-15, cellFrame.origin.y-75, 30, 30);
            }
            
            _profilePicture.frame = CGRectMake(5, 5, 50, 50);
            
            [_previewSummaryContainer1 setAlpha:0.0];
        } completion:^(BOOL finished) {
            if (_frameOrigin.size.height < 140) {_frameOrigin = CGRectMake(cellFrame.origin.x, cellFrame.origin.y-40, cellFrame.size.width, 140);}
            
            [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
                [_previewSummaryContainer2 setAlpha:1.0];
            } completion:nil];
        }];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        float distance = _tapPoint.y - p.y;
        
        float rangeLowMapView = 0;
        float rangeUpMapView = (_frameOrigin.origin.y - 40)/2;
        
        float rangeLowGraphView = rangeUpMapView;
        float rangeUpGraphView = _frameOrigin.origin.y - 40;
        
        float previewMapViewAlpha = 1.0/(rangeUpMapView-rangeLowMapView)*distance + 1.0 - 1.0/(rangeUpMapView-rangeLowMapView)*rangeUpMapView;
        if (previewMapViewAlpha > 1) {previewMapViewAlpha = 1;}
        if (previewMapViewAlpha < 0) {previewMapViewAlpha = 0;}
        
        float previewGraphViewAlpha = 1.0/(rangeUpGraphView-rangeLowGraphView)*distance + 1.0 - 1.0/(rangeUpGraphView-rangeLowGraphView)*rangeUpGraphView;
        if (previewGraphViewAlpha > 1) {previewGraphViewAlpha = 1;}
        if (previewGraphViewAlpha < 0) {previewGraphViewAlpha = 0;}
        
        if (distance < 0) {distance /= 8;}
        
        float previewSummaryY = _frameOrigin.origin.y - distance;
        
        if (previewSummaryY < 40) {
            float overshoot = 40 - previewSummaryY;
            
            previewSummaryY += overshoot;
            previewSummaryY -= overshoot/8;
        }
        
        float previewUpArrowAlpha = 1.0;
        
        if (previewSummaryY < 50) {previewUpArrowAlpha = 1.0/10.0*previewSummaryY + 1.0 - 1.0/10.0*50;}
        
        _previewSummary.frame = CGRectMake(_frameOrigin.origin.x, previewSummaryY, _frameOrigin.size.width, _frameOrigin.size.height);
        
        _previewUpArrow.frame = CGRectMake((_frameOrigin.size.width+20)/2-15, previewSummaryY-35, 30, 30);
        
        [_previewUpArrow setAlpha:previewUpArrowAlpha];
        
        _previewMapView.frame = CGRectMake(_frameOrigin.origin.x, previewSummaryY + 150, _frameOrigin.size.width, 200);
        
        _previewGraphView.frame = CGRectMake(_frameOrigin.origin.x, previewSummaryY + 360, _frameOrigin.size.width, (_frameOrigin.size.width+20)/320*150+10);
        
        [_previewMapView setAlpha:previewMapViewAlpha];
        
        [_previewGraphView setAlpha:previewGraphViewAlpha];
        
        if (previewMapViewAlpha > 0 && !_mapWasShown) {
            [self LoadTourCoordinates:_currentPreviewTour];
            
            _mapWasShown = true;
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
            [_blurEffectView setAlpha:0.0];
            
            [_previewSummary setAlpha:0.0];
            
            [_previewUpArrow setAlpha:0.0];
            
            [_previewMapView setAlpha:0.0];
            
            [_previewGraphView setAlpha:0.0];
            
            _previewSummary.frame = CGRectMake(_frameOrigin.origin.x, _frameOrigin.origin.y, _frameOrigin.size.width, _frameOrigin.size.height);
            
            _previewUpArrow.frame = CGRectMake((_frameOrigin.size.width+20)/2-15, _frameOrigin.origin.y-35, 30, 30);
            
            _previewMapView.frame = CGRectMake(_frameOrigin.origin.x, _frameOrigin.origin.y+_frameOrigin.size.height+10, _frameOrigin.size.width, 200);
            
            _previewGraphView.frame = CGRectMake(_frameOrigin.origin.x, _frameOrigin.origin.y+_frameOrigin.size.height+220, _frameOrigin.size.width, _frameOrigin.size.width/320*150+10);
        } completion:^(BOOL finished) {
            [_blurEffectView setHidden:YES];
            [_previewSummary setHidden:YES];
            [_previewUpArrow setHidden:YES];
            [_previewMapView setHidden:YES];
            [_previewGraphView setHidden:YES];
            
            [_blurEffectView setAlpha:1.0];
            
            [_previewSummary setAlpha:1.0];
            
            [_previewUpArrow setAlpha:1.0];
            
            [self CancelSessionTask];
            
            _mapWasShown = false;
        }];
    }
}

- (NSInteger) indexOfCellAtPosition:(float)position
{
    float yPosition = 0;
    NSInteger i = 0;
    
    while (position > yPosition && i < [_news_feed count]) {
        XTTourInfo *currentTour = [_news_feed objectAtIndex:i];
        
        if ([currentTour.tourDescription isEqualToString:@""]) {yPosition += 110;}
        else {yPosition += 150;}
        
        i++;
    }
    
    return i-1;
}

- (CGRect) frameForCellAtIndex:(NSInteger)index scrollPosition:(float)scroll
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    
    float yPosition = 0;
    float cellHeight = 0;
    
    for (int i = 0; i < index+1; i++) {
        XTTourInfo *currentTour = [_news_feed objectAtIndex:i];
        
        if ([currentTour.tourDescription isEqualToString:@""]) {cellHeight = 100; yPosition += 110;}
        else {cellHeight = 140; yPosition += 150;}
    }
    
    CGRect cellFrame = CGRectMake(10, yPosition-cellHeight+110-scroll, width-20, cellHeight);
    
    return cellFrame;
}

- (void) LoadTourCoordinates:(XTTourInfo*)tourInfo
{
    NSString *tourID = tourInfo.tourID;
    
    [_loadingView setHidden:NO];
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_tour_coordinates_string.php?tid=%@", tourID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfiguration.timeoutIntervalForRequest = 10.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    self.previewSessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
        [_loadingView setHidden:YES];
        
        XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
        
        [request ProcessTourCoordinates:(NSData*)responseData];
        
        NSMutableArray *tourFiles = request.tourFilesType;
        NSMutableArray *coordinateArray = request.tourFilesCoordinates;
        
        float minLon = 1e6;
        float maxLon = -1e6;
        float minLat = 1e6;
        float maxLat = -1e6;
        
        GMSMutablePath *currentPath = [[GMSMutablePath alloc] init];
        if (!_polylines) {_polylines = [[NSMutableArray alloc] init];}
        
        [_polylines removeAllObjects];
        
        for (int i = 0; i < [coordinateArray count]; i++) {
            [currentPath removeAllCoordinates];
            
            NSMutableArray *coordinate = [coordinateArray objectAtIndex:i];
            
            for (int k = 0; k < [coordinate count]; k++) {
                CLLocation *location = [coordinate objectAtIndex:k];
                [currentPath addCoordinate:location.coordinate];
                
                if (location.coordinate.longitude < minLon) {minLon = location.coordinate.longitude;}
                if (location.coordinate.longitude > maxLon) {maxLon = location.coordinate.longitude;}
                if (location.coordinate.latitude < minLat) {minLat = location.coordinate.latitude;}
                if (location.coordinate.latitude > maxLat) {maxLat = location.coordinate.latitude;}
            }
            
            GMSPolyline *polyline = [[GMSPolyline alloc] init];
            [polyline setPath:currentPath];
            if ([[tourFiles objectAtIndex:i] containsString:@"up"]) {polyline.strokeColor = [UIColor colorWithRed:41.0f/255.0f green:127.0f/255.0f blue:199.0f/255.0f alpha:1.0f];}
            else {polyline.strokeColor = [UIColor colorWithRed:199.0f/255.0f green:74.0F/255.0f blue:41.0f/255.0f alpha:1.0f];}
            polyline.strokeWidth = 3.f;
            
            [_polylines addObject:polyline];
            GMSPolyline *currentPolyline = [_polylines objectAtIndex:i];
            
            currentPolyline.map = _map;
        }
        
        GMSMarker *startPoint = [[GMSMarker alloc] init];
        
        startPoint.position = CLLocationCoordinate2DMake(tourInfo.latitude, tourInfo.longitude);
        startPoint.icon = [UIImage imageNamed:@"markerIcon_green@3x.png"];
        startPoint.groundAnchor = CGPointMake(0.5,0.5);
        startPoint.map = _map;
        
        if ([coordinateArray count] == 1) {
            NSMutableArray *coordinate = [coordinateArray objectAtIndex:0];
            
            CLLocation *location = [coordinate lastObject];
            
            GMSMarker *startPoint = [[GMSMarker alloc] init];
            
            startPoint.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
            startPoint.icon = [UIImage imageNamed:@"markerIcon_red@3x.png"];
            startPoint.groundAnchor = CGPointMake(0.5,0.5);
            startPoint.map = _map;
        }
        
        GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:[[GMSCoordinateBounds alloc]initWithCoordinate:CLLocationCoordinate2DMake(minLat, minLon) coordinate:CLLocationCoordinate2DMake(maxLat, maxLon)] withPadding:50.0f];
        [_map moveCamera:cameraUpdate];
    }];
    
    [self.previewSessionTask resume];
}

- (void) CancelSessionTask
{
    if (self.previewSessionTask.state == NSURLSessionTaskStateRunning) {[self.previewSessionTask cancel];}
    
    for (int i = 0; i < [_polylines count]; i++) {
        GMSPolyline *currentPolyline = [_polylines objectAtIndex:i];
        
        currentPolyline.map = nil;
    }
    
    [_map clear];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    XTTourInfo *currentElement = [self.news_feed objectAtIndex:_clickedButton];
    
    if ([buttonTitle isEqualToString:@"Tour löschen"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bestätige" message:@"Bist du sicher, dass du diese Tour löschen willst?" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Löschen", nil];
        
        [alert show];
    }
    if ([buttonTitle isEqualToString:@"Tour verstecken"]) {
        NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/hide_tour.php?tid=%@", currentElement.tourID];
        NSURL *url = [NSURL URLWithString:requestString];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        sessionConfiguration.timeoutIntervalForRequest = 10.0;
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message: @"Da ist etwas schief gelaufen. Stelle sicher, dass du Verbindung zum Internet hast." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
                return;
            }
            
            NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            if ([response isEqualToString:@"true"]) {
                [self refreshNewsFeed];
            }
        }];
        
        [sessionTask resume];
    }
    if ([buttonTitle isEqualToString:@"Zur Wunschliste"]) {
        NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/generate_wishlist.php?tid=%@", currentElement.tourID];
        NSURL *url = [NSURL URLWithString:requestString];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        sessionConfiguration.timeoutIntervalForRequest = 10.0;
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message: @"Da ist etwas schief gelaufen. Stelle sicher, dass du Verbindung zum Internet hast." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
                return;
            }
            
            NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            if ([response isEqualToString:@"true"]) {
                NSInteger timestamp = (NSInteger)[[NSDate date] timeIntervalSince1970];
                
                NSString *remoteFile = [NSString stringWithFormat:@"http://www.xtour.ch/users/%@/tours/%@/Wishlist_%@.gpx",currentElement.userID,currentElement.tourID,currentElement.tourID];
                NSString *localFile = [NSString stringWithFormat:@"/Wishlist_%@_%li.gpx",currentElement.tourID,(long)timestamp];
                
                [ServerHandler DownloadFile:remoteFile to:localFile];
            }
        }];
        
        [sessionTask resume];
    }
    if ([buttonTitle isEqualToString:@"Zeige Details"]) {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        float width = screenBound.size.width;
        float height = screenBound.size.height;
        
        UITabBarController *tabBarController = [UITabBarController new];
        CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
        
        XTTourDetailView *detailView = [[XTTourDetailView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        detailView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
        
        [detailView Initialize:currentElement fromServer:YES withOffset:70 andContentOffset:tabBarHeight];
        
        if (!navigationView) {
            navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:detailView title:@"Touren Detail" isFirstView:YES];
            
            //[navigationView.header removeFromSuperview];
            //[navigationView.header_shadow removeFromSuperview];
            //[navigationView.header_background removeFromSuperview];
        }
        else {
            [navigationView ClearContentView];
            
            [navigationView.contentView addSubview:detailView];
        }
        
        //[[UIApplication sharedApplication].keyWindow addSubview:navigationView.backButton];
        
        XTNavigationViewContainer *lastNavigationViewContainer = [self lastNavigationViewContainer];
        
        [lastNavigationViewContainer.view addSubview:navigationView.view];
        
        //[self.view addSubview:navigationView.view];
        
        [navigationView ShowView];
        
        [detailView LoadTourDetail:currentElement fromServer:YES];
        
        [detailView release];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Löschen"]) {
        XTTourInfo *currentElement = [self.news_feed objectAtIndex:_clickedButton];
        
        NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/delete_tour.php?tid=%@", currentElement.tourID];
        NSURL *url = [NSURL URLWithString:requestString];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        sessionConfiguration.timeoutIntervalForRequest = 10.0;
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message: @"Da ist etwas schief gelaufen. Stelle sicher, dass du Verbindung zum Internet hast." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
                return;
            }
            
            NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            if ([response isEqualToString:@"true"]) {
                [self refreshNewsFeed];
            }
        }];
        
        [sessionTask resume];
        
        [navigationView HideView];
    }
}

- (XTNavigationViewContainer *) lastNavigationViewContainer {
    // convenience function for casting and to "mask" the recursive function
    return (XTNavigationViewContainer *)[self traverseResponderChainForUIViewController:self];
}

- (id) traverseResponderChainForUIViewController:(id)sender {
    id nextResponder = [sender nextResponder];
    if ([nextResponder isKindOfClass:[XTNavigationViewContainer class]]) {
        NSLog(@"Found last navigation view container");
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [self traverseResponderChainForUIViewController:nextResponder];
    } else {
        return nil;
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

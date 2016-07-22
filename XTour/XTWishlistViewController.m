//
//  XTWishlistViewController.m
//  XTour
//
//  Created by Manuel Weber on 07/12/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import "XTWishlistViewController.h"

@interface XTWishlistViewController ()

@end

@implementation XTWishlistViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UITabBarController *tabBarController = [UITabBarController new];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    // Register cell classes
    [self.collectionView registerClass:[XTWishlistViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(70, 0, tabBarHeight, 0)];
    
    // Do any additional setup after loading the view.
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    data = [XTDataSingleton singleObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    if (!_tourInfos) {_tourInfos = [[NSMutableArray alloc] init];}
    
    [_tourInfos removeAllObjects];
    
    NSMutableArray *GPXFiles = [[NSMutableArray alloc] init];
    
    GPXFiles = [data GetWishlistGPXFiles];
    
    for (int i = 0; i < [GPXFiles count]; i++) {
        XTXMLParser *parser = [[XTXMLParser alloc] init];
        
        [parser ReadGPXFile:[GPXFiles objectAtIndex:i]];
        
        XTTourInfo *tourInfo = [[XTTourInfo alloc] init];
        
        tourInfo.userID = [parser GetValueFromFile:@"userid"];
        tourInfo.tourID = [parser GetValueFromFile:@"tourid"];
        tourInfo.date = [[parser GetValueFromFile:@"date"] integerValue];
        tourInfo.totalTime = [[parser GetValueFromFile:@"TotalTime"] integerValue];
        tourInfo.distance = [[parser GetValueFromFile:@"TotalDistance"] floatValue];
        tourInfo.altitude = [[parser GetValueFromFile:@"TotalAltitude"] floatValue];
        tourInfo.descent = [[parser GetValueFromFile:@"TotalDescent"] floatValue];
        tourInfo.highestPoint = [[parser GetValueFromFile:@"HighestPoint"] floatValue];
        tourInfo.lowestPoint = [[parser GetValueFromFile:@"LowestPoint"] floatValue];
        tourInfo.mountainPeak = [parser GetValueFromFile:@"MountainPeak"];
        
        [_tourInfos addObject:tourInfo];
        
        [tourInfo release];
        [parser release];
    }
    
    [GPXFiles release];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([_tourInfos count] == 0) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        UITextView *messageLbl = [[UITextView alloc] initWithFrame:CGRectMake(10,self.view.bounds.size.height/2-50,self.view.bounds.size.width-20,100)];
        
        messageLbl.backgroundColor = [UIColor clearColor];
        messageLbl.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        messageLbl.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        messageLbl.text = @"Keine Touren in der Wunschliste.\n\nUm Touren hinzuzufügen gehe zum Touren feed und klicke auf \"Zur Wunschliste\"";
        messageLbl.textAlignment = NSTextAlignmentCenter;
        [messageLbl setEditable:NO];
        [messageLbl setScrollEnabled:NO];
        
        [backgroundView addSubview:messageLbl];
        
        self.collectionView.backgroundView = backgroundView;
        
        return 0;
    }
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_tourInfos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTWishlistViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.backgroundColor = [UIColor whiteColor];
    
    XTTourInfo *currentElement = [self.tourInfos objectAtIndex:indexPath.row];
    
    NSString *formattedDate = [self GetTimeForWishlist:currentElement.tourID];
    
    NSUInteger tm = currentElement.totalTime;
    
    NSString *TimeString = [NSString stringWithFormat:@"%02lih %.0fm",
                            lround(floor(tm / 3600.)) % 100,
                            floor((lround(floor(tm / 60.)) % 60)/10.)*10.];
    
    cell.title.text = [NSString stringWithFormat:@"Hinzugefügt am %@", formattedDate];
    cell.time.text = TimeString;
    
    cell.mountainPeak.text = currentElement.mountainPeak;
    
    if (currentElement.distance < 10) {cell.distance.text = [NSString stringWithFormat:@"%.0f m", 1000*currentElement.distance];}
    else {cell.distance.text = [NSString stringWithFormat:@"%.1f km", currentElement.distance];}
    
    cell.altitude.text = [NSString stringWithFormat:@"%.0f m", currentElement.altitude];
    cell.highestPoint.text = [NSString stringWithFormat:@"%.0f m", currentElement.highestPoint];
    
    cell.moreButton.tag = indexPath.row;
    cell.startButton.tag = indexPath.row;
    
    [cell.moreButton addTarget:self action:@selector(ShowOptions:) forControlEvents:UIControlEventTouchUpInside];
    [cell.startButton addTarget:self action:@selector(StartTour:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([currentElement.tourID isEqualToString:data.followTourInfo.tourID]) {
        cell.overlayText.text = @"Folge dieser Tour";
        
        [cell.overlay setHidden:NO];
        
        cell.startButton.frame = CGRectMake(cell.frame.size.width-45, 71, 30, 30);
        [cell.startButton setBackgroundImage:[UIImage imageNamed:@"close_icon@3x.png"] forState:UIControlStateNormal];
        [cell.startButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
        [cell.startButton addTarget:self action:@selector(RemoveTour:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    
    float boxWidth = width - 20;
    float height = 120;
    
    return CGSizeMake(boxWidth, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (void) ShowOptions:(id)sender
{
    _clickedButton = [(UIButton*)sender tag];
    
    XTTourInfo *currentElement = [self.tourInfos objectAtIndex:_clickedButton];
    
    NSString *filename = [self GetWishlistFile:currentElement.tourID];
    
    bool result = [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
    
    if (result) {[_tourInfos removeObjectAtIndex:_clickedButton];}
    
    [self.collectionView reloadData];
}

- (void) StartTour:(id)sender
{
    _clickedButton = [(UIButton*)sender tag];
    
    XTWishlistViewCell *cell = (XTWishlistViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_clickedButton inSection:0]];
    
    cell.overlayText.text = @"Tour hinzugefügt";
    
    [cell.overlay setHidden:NO];
    
    cell.startButton.frame = CGRectMake(cell.frame.size.width-45, 71, 30, 30);
    [cell.startButton setBackgroundImage:[UIImage imageNamed:@"close_icon@3x.png"] forState:UIControlStateNormal];
    [cell.startButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [cell.startButton addTarget:self action:@selector(RemoveTour:) forControlEvents:UIControlEventTouchUpInside];
    
    XTTourInfo *currentElement = [self.tourInfos objectAtIndex:_clickedButton];
    
    NSString *filename = [self GetWishlistFile:currentElement.tourID];
    
    XTXMLParser *parser = [[XTXMLParser alloc] init];
    
    [parser ReadGPXFile:filename];
    
    NSInteger numberOfTracks = [parser GetNumberOfTracksInFile];
    
    data.followTourInfo = currentElement;
    
    if (!data.followTourInfo.tracks) {data.followTourInfo.tracks = [[NSMutableArray alloc] init];}
    
    [data.followTourInfo.tracks removeAllObjects];
    
    GMSMutablePath *currentPath = [[GMSMutablePath alloc] init];
    for (int i = 0; i < numberOfTracks; i++) {
        [currentPath removeAllCoordinates];
        
        NSMutableArray *coordinate = [parser GetLocationDataFromFileAtIndex:i];
        
        for (int k = 0; k < [coordinate count]; k++) {
            CLLocation *location = [coordinate objectAtIndex:k];
            [currentPath addCoordinate:location.coordinate];
        }
        
        GMSPolyline *polyline = [[GMSPolyline alloc] init];
        [polyline setPath:currentPath];
        if ([[parser GetTrackTypeAtIndex:i] containsString:@"up"]) {polyline.strokeColor = [UIColor greenColor];}
        else {polyline.strokeColor = [UIColor yellowColor];}
        polyline.strokeWidth = 3.f;
        
        [data.followTourInfo.tracks addObject:polyline];
    }
}

- (void) RemoveTour:(id)sender
{
    _clickedButton = [(UIButton*)sender tag];
    
    XTWishlistViewCell *cell = (XTWishlistViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_clickedButton inSection:0]];
    
    [cell.overlay setHidden:YES];
    
    data.followTourInfo = nil;
    
    cell.startButton.frame = CGRectMake(cell.frame.size.width-55, 71, 50, 28);
    [cell.startButton setBackgroundImage:[UIImage imageNamed:@"start_tour_icon@3x.png"] forState:UIControlStateNormal];
    [cell.startButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [cell.startButton addTarget:self action:@selector(StartTour:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSString *)GetWishlistFile:(NSString *)tourID
{
    NSString *searchFilename = [NSString stringWithFormat:@"Wishlist_%@",tourID];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *listOfFiles = [fileManager contentsOfDirectoryAtPath:[data GetDocumentFilePathForFile:@"/" CheckIfExist:NO] error:nil];
    
    NSString *filename = nil;
    
    for (int i = 0; i < [listOfFiles count]; i++) {
        if ([[listOfFiles objectAtIndex:i] containsString:searchFilename]) {filename = [NSString stringWithFormat:@"%@/%@",[data GetDocumentFilePathForFile:@"/" CheckIfExist:NO],[listOfFiles objectAtIndex:i]]; break;}
    }
    
    return filename;
}

- (NSString *)GetTimeForWishlist:(NSString *)tourID
{
    NSString *filename = [self GetWishlistFile:tourID];
    
    NSString *timestampStringTMP = [[filename componentsSeparatedByString:@"_"] objectAtIndex:2];
    NSString *timestampString = [[timestampStringTMP componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSInteger timestamp = [timestampString integerValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *formattedDate = [formatter stringFromDate:date];
    
    return formattedDate;
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

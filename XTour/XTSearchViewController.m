//
//  XTSearchViewController.m
//  XTour
//
//  Created by Manuel Weber on 08/01/16.
//  Copyright © 2016 Manuel Weber. All rights reserved.
//

#import "XTSearchViewController.h"

@interface XTSearchViewController ()

@end

@implementation XTSearchViewController

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
    
    // Register cell classes
    [self.collectionView registerClass:[XTNewsFeedCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerClass:[XTCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(110, 0, tabBarHeight, 0)];
    
    // Do any additional setup after loading the view.
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, width, 40)];
    
    searchView.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:0.9];
    
    UIView *searchFieldBackground = [[UIView alloc] initWithFrame:CGRectMake(20, 5, width-40, 30)];
    
    searchFieldBackground.backgroundColor = [UIColor whiteColor];
    searchFieldBackground.layer.borderWidth = 1.0f;
    searchFieldBackground.layer.cornerRadius = 5.0f;
    searchFieldBackground.layer.borderColor = [[UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0f] CGColor];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, width-50, 30)];
    
    _searchField.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _searchField.textAlignment = NSTextAlignmentCenter;
    _searchField.text = @"Suche Touren und Personen";
    
    [searchFieldBackground addSubview:_searchField];
    
    [searchView addSubview:searchFieldBackground];
    
    [self.view addSubview:searchView];
    
    [searchView release];
    
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
    
    _noToursFoundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    _messageLbl = [[UITextView alloc] initWithFrame:CGRectMake(10,self.view.bounds.size.height/2-50,self.view.bounds.size.width-20,100)];
    
    _messageLbl.backgroundColor = [UIColor clearColor];
    _messageLbl.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    _messageLbl.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _messageLbl.text = [NSString stringWithFormat:@"Im Umkreis von %.0fkm wurden keine Touren gefunden.\n\nHerunterziehen um zu aktualisieren",data.profileSettings.toursRadius];
    _messageLbl.textAlignment = NSTextAlignmentCenter;
    [_messageLbl setEditable:NO];
    [_messageLbl setScrollEnabled:NO];
    
    [_noToursFoundView addSubview:_messageLbl];
    
    ServerHandler = [[XTServerRequestHandler alloc] init];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    if (refreshControl == nil) {
        refreshControl = [[UIRefreshControl alloc] init];
    }
    [refreshControl addTarget:self action:@selector(refreshNewsFeed) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    [refreshControl beginRefreshing];
    
    [self refreshNewsFeed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //[[UIApplication sharedApplication].keyWindow addSubview:navigationView.backButton];
    
    XTNavigationViewContainer *lastNavigationViewContainer = [self lastNavigationViewContainer];
    
    [lastNavigationViewContainer.view addSubview:navigationView.view];
    
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

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XTCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    
    header.frame = CGRectMake(0, 0, width, 30);
    
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width, 20)];
    
    headerTitle.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    headerTitle.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    headerTitle.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.section == 0) {headerTitle.text = @"Touren in deiner Umgebung";}
    
    if ([self.news_feed count] == 0) {headerTitle.text = @"";}
    
    [header addSubview:headerTitle];
    
    [headerTitle release];
    
    return header;
}

- (void) refreshNewsFeed
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_closeby_tours_string.php?num=%i&uid=%@&lon=%f&lat=%f&radius=%f", 10, data.userID, data.CurrentLocation.coordinate.longitude, data.CurrentLocation.coordinate.latitude, data.profileSettings.toursRadius];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfiguration.timeoutIntervalForRequest = 10.0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *URLResponse, NSError *error) {
        if (error) {
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message: @"Da ist etwas schief gelaufen. Stelle sicher, dass du Verbindung zum Internet hast." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //[alert show];
            
            self.collectionView.backgroundView = _noConnectionView;
            
            [refreshControl endRefreshing];
            
            return;
        }
        
        self.news_feed = [ServerHandler GetNewsFeedString:(NSData*)responseData];
        
        if ([self.news_feed count] > 0) {self.collectionView.backgroundView = nil;}
        else {
            _messageLbl.text = [NSString stringWithFormat:@"Im Umkreis von %.0fkm wurden keine Touren gefunden.\n\nHerunterziehen um zu aktualisieren",data.profileSettings.toursRadius];
            
            self.collectionView.backgroundView = _noToursFoundView;
        }
        
        [self.collectionView reloadData];
        
        [refreshControl endRefreshing];
    }];
    
    [sessionTask resume];
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

- (void)keyboardWasShown:(NSNotification *)notification
{
    if ([_searchField.text isEqualToString:@"Suche Touren und Personen"]) {
        _searchField.textAlignment = NSTextAlignmentLeft;
        _searchField.text = @"";
    }
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    if ([_searchField.text isEqualToString:@""]) {
        _searchField.textAlignment = NSTextAlignmentCenter;
        _searchField.text = @"Suche Touren und Personen";
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchField endEditing:YES];
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

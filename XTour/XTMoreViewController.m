//
//  XTMoreViewController.m
//  XTour
//
//  Created by Manuel Weber on 19/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTMoreViewController.h"

@interface XTMoreViewController ()

@end

@implementation XTMoreViewController

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
    // Do any additional setup after loading the view.
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _header.frame = CGRectMake(0, 0, width, 69);
    _header_shadow.frame = CGRectMake(0, 69, width, 1);
    
    _loginButton.frame = CGRectMake(width-50, 25, 40, 40);
    
    [_tableView setContentInset:UIEdgeInsetsMake(100, 0, 0, 0)];
    
    data = [XTDataSingleton singleObj];
    
    //_listOfFiles = [data GetAllImages];
    
    NSArray *tableItems1 = [NSArray arrayWithObjects:@"Profil", @"Einstellungen", @"Touren feed", @"Wunschliste", @"Touren suchen", nil];
    NSArray *tableItems2 = [NSArray arrayWithObjects:@"Ausloggen", nil];
    NSArray *tableIcons1 = [NSArray arrayWithObjects:@"profile_icon_small@3x.png", @"settings_icon@3x.png", @"news_feed_icon@3x.png", @"wishlist_icon@3x.png", @"tour_search_icon@3x.png", nil];
    NSArray *tableIcons2 = [NSArray arrayWithObjects:@"logout@3x.png", nil];
    
    _listOfFiles = [[NSDictionary alloc] initWithObjectsAndKeys:tableItems1, @"Allgemein", tableItems2, @"Beta testing", nil];
    
    _listOfIcons = [[NSDictionary alloc] initWithObjectsAndKeys:tableIcons1, @"Allgemein", tableIcons2, @"Beta testing", nil];
    
    _sectionTitles = [[NSArray alloc] initWithObjects:@"Allgemein", @"Beta testing", nil];
    
    /*_listOfFiles = [[NSMutableArray alloc] init];
    [_listOfFiles addObject:@"Profil"];
    [_listOfFiles addObject:@"Einstellungen"];
    [_listOfFiles addObject:@"News feed"];
    [_listOfFiles addObject:@"Dateien hochladen (beta)"];
    [_listOfFiles addObject:@"Aufräumen (beta)"];
    [_listOfFiles addObject:@"Wunschliste"];
    
    _listOfIcons = [[NSMutableArray alloc] init];
    [_listOfIcons addObject:@"profile_icon_small@3x.png"];
    [_listOfIcons addObject:@"settings_icon@3x.png"];
    [_listOfIcons addObject:@"news_feed_icon@3x.png"];
    [_listOfIcons addObject:@"upload_icon@3x.png"];
    [_listOfIcons addObject:@"cleanup_icon@3x.png"];
    [_listOfIcons addObject:@"wishlist_icon@3x.png"];*/
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(2*width, 70, width, height-70-tabBarHeight)];
    _detailView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_detailView];
    
    self.tableView.frame = CGRectMake(0, 0, width, height);
    
    self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self LoginViewDidClose:nil];
    
    if (navigationView.view.frame.origin.x == 0) {
        [navigationView.backButton setHidden:NO];
        [navigationView.navigationTitle setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (navigationView.view.frame.origin.x == 0) {
        [navigationView.backButton setHidden:YES];
        [navigationView.navigationTitle setHidden:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitles count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [_sectionTitles objectAtIndex:section];
    NSArray *sectionItems = [_listOfFiles objectForKey:sectionTitle];
    
    return [sectionItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    
    NSString *sectionTitle = [_sectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionItems = [_listOfFiles objectForKey:sectionTitle];
    NSArray *sectionIcons = [_listOfIcons objectForKey:sectionTitle];
    
    cell.textLabel.text = [sectionItems objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[sectionIcons objectAtIndex:indexPath.row]];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0 && data.loggedIn) {cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;}
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 3) {
            NSInteger numberOfWishlistFiles = [data GetNumberOfWishlistFiles];
            
            if (numberOfWishlistFiles > 0) {
                float numberWidth = 40;
                if (numberOfWishlistFiles >= 10 && numberOfWishlistFiles < 100) {numberWidth = 45;}
                if (numberOfWishlistFiles >= 100) {numberWidth = 50;}
                
                UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-numberWidth-10, cell.frame.size.height/2-15, numberWidth, 30)];
                
                accessoryView.layer.cornerRadius = 15.0f;
                accessoryView.backgroundColor = [UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0f];
                
                UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, numberWidth, 30)];
                
                numberLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
                numberLabel.textColor = [UIColor whiteColor];
                numberLabel.textAlignment = NSTextAlignmentCenter;
                numberLabel.text = [NSString stringWithFormat:@"%li",(long)numberOfWishlistFiles];
                
                [accessoryView addSubview:numberLabel];
                
                cell.accessoryView = accessoryView;
                
                [accessoryView release];
            }
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {cell.textLabel.textColor = [UIColor redColor];}
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    //UITabBarController *tabBarController = [super tabBarController];
    //CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    if (!data.loggedIn) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Du musst dich einloggen um deine Touren anzuzeigen. Klicke auf das Profil-Icon." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        
                        [alert show];
                        [alert release];
                        
                        return;
                    }
                    
                    XTProfileViewController *profile = [[XTProfileViewController alloc] initWithFrame:CGRectMake(0, 0, width, height)];
                    
                    [profile initialize];
                    
                    navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:profile title:data.userInfo.userName isFirstView:YES];
                    
                    [self.view addSubview:navigationView.view];
                    
                    [navigationView ShowView];
                    
                    [profile release];
                }
                    
                    break;
                case 1:
                {
                    XTSettingsViewController *settings = [[XTSettingsViewController alloc] initWithNibName:nil bundle:nil];
                    
                    settings.view.frame = CGRectMake(0, 0, width, height);
                    
                    navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:settings.view title:@"Einstellungen" isFirstView:YES];
                    
                    [self.view addSubview:navigationView.view];
                    
                    [navigationView ShowView];
                }
                    
                    break;
                case 2:
                {
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    [layout setItemSize:CGSizeMake(300, 100)];
                    XTNewsFeedViewController *collection = [[XTNewsFeedViewController alloc] initWithCollectionViewLayout:layout];
                    collection.view.frame = CGRectMake(0, 0, width, height);
                    
                    navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:collection.view title:@"Touren feed" isFirstView:YES];
                    
                    [self.view addSubview:navigationView.view];
                    
                    [navigationView ShowView];
                    
                    [layout release];
                }
                    break;
                case 3:
                {
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    [layout setItemSize:CGSizeMake(300, 100)];
                    XTWishlistViewController *collection = [[XTWishlistViewController alloc] initWithCollectionViewLayout:layout];
                    collection.view.frame = CGRectMake(0, 0, width, height);
                    
                    navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:collection.view title:@"Wunschliste" isFirstView:YES];
                    
                    [self.view addSubview:navigationView.view];
                    
                    [navigationView ShowView];
                    
                    [layout release];
                }
                    break;
                case 4:
                {
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    [layout setItemSize:CGSizeMake(300, 100)];
                    [layout setHeaderReferenceSize:CGSizeMake(width, 30)];
                    XTSearchViewController *collection = [[XTSearchViewController alloc] initWithCollectionViewLayout:layout];
                    collection.view.frame = CGRectMake(0, 0, width, height);
                    
                    navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:collection.view title:@"Suche" isFirstView:YES];
                    
                    [self.view addSubview:navigationView.view];
                    
                    [navigationView ShowView];
                    
                    [layout release];
                }
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [data Logout];
                    break;
            }
            break;
    }
    
    //[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_detailView.frame = CGRectMake(0, 70, width, height-70-tabBarHeight);} completion:^(bool finished) {[_backButton setHidden:NO];}];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 5)];
    /*UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 100, 20)];
    
    lblTitle.font = [UIFont fontWithName:@"Helvetica" size:16];
    lblTitle.textColor = [UIColor colorWithRed:150.0F/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = [_sectionTitles objectAtIndex:section];
    
    [viewHeader addSubview:lblTitle];
    
    [lblTitle release];*/
    
    return viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (void)dealloc {
    [_loginButton release];
    [_header release];
    [_header_shadow release];
    [_tableView release];
    [super dealloc];
}
- (void)LoadLogin:(id)sender {
    if (login) {[login.view removeFromSuperview];}
    
    login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:login.view];
    [login animate];
}

- (void)ShowLoginOptions:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginViewDidClose:) name:@"LoginViewDismissed" object:nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Du bist eingelogged als %@",data.userInfo.userName] delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:@"Ausloggen" otherButtonTitles:@"Profil anzeigen", nil];
    
    [actionSheet showInView:self.view];
}

- (void) LoginViewDidClose:(id)sender
{
    [_loginButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(ShowLoginOptions:) forControlEvents:UIControlEventTouchUpInside];
        
        [img release];
    }
    else {
        [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(LoadLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Ausloggen"]) {[data Logout];}
    else if ([buttonTitle isEqualToString:@"Profil anzeigen"]) {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        float width = screenBound.size.width;
        float height = screenBound.size.height;
        
        XTProfileViewController *profile = [[XTProfileViewController alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        
        [profile initialize];
        
        navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:profile title:data.userInfo.userName isFirstView:YES];
        
        [self.view addSubview:navigationView.view];
        
        [navigationView ShowView];
        
        [profile release];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginViewDismissed" object:nil userInfo:nil];
}

@end

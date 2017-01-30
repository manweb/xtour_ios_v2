//
//  XTMoreViewController.h
//  XTour
//
//  Created by Manuel Weber on 19/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTLoginViewController.h"
#import "XTNewsFeedViewController.h"
#import "XTNavigationViewContainer.h"
#import "XTFileUploader.h"
#import "XTSettingsViewController.h"
#import "XTProfileViewController.h"
#import "XTWishlistViewController.h"
#import "XTSearchViewController.h"

@interface XTMoreViewController : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>
{
    XTDataSingleton *data;
    XTNavigationViewContainer *navigationView;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *header;
@property (retain, nonatomic) IBOutlet UIView *header_shadow;
@property(nonatomic,retain) NSDictionary *listOfFiles;
@property(nonatomic,retain) NSDictionary *listOfIcons;
@property(nonatomic,retain) NSArray *sectionTitles;
@property(nonatomic,retain) UIView *detailView;

@end

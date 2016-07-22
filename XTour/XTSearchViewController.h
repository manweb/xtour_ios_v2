//
//  XTSearchViewController.h
//  XTour
//
//  Created by Manuel Weber on 08/01/16.
//  Copyright © 2016 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTSearchViewCell.h"
#import "XTNewsFeedCell.h"
#import "XTDataSingleton.h"
#import "XTServerRequestHandler.h"
#import "XTNavigationViewContainer.h"
#import "XTTourInfo.h"
#import "XTTourDetailView.h"
#import "XTCollectionHeaderView.h"

@interface XTSearchViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>
{
    XTDataSingleton *data;
    XTServerRequestHandler *ServerHandler;
    UIRefreshControl *refreshControl;
    XTNavigationViewContainer *navigationView;
}

@property (nonatomic,retain) UITextField *searchField;
@property (nonatomic,retain) NSMutableArray *news_feed;
@property (nonatomic) NSInteger clickedButton;
@property (nonatomic,retain) UIView *noConnectionView;
@property (nonatomic,retain) UIView *noToursFoundView;
@property (nonatomic,retain) UITextView *messageLbl;

@end

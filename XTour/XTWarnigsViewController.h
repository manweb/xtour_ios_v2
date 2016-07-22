//
//  XTWarnigsViewController.h
//  XTour
//
//  Created by Manuel Weber on 22/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTLoginViewController.h"
#import "XTWarningsInfo.h"
#import "XTServerRequestHandler.h"
#import "XTWarningCell.h"
#import "XTProfileViewController.h"
#import "XTNavigationViewContainer.h"
#import "XTWarningDetailView.h"

@interface XTWarnigsViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
    UIRefreshControl *refreshControl;
    XTWarningDetailView *warningDetailView;
}

@property (retain, nonatomic) UIView *header;
@property (retain, nonatomic) UIView *header_shadow;
@property (retain, nonatomic) UIButton *loginButton;
@property (retain, nonatomic) NSMutableArray *warningsArray;
@property (retain, nonatomic) NSMutableArray *categories;
@property (retain, nonatomic) UIView *noConnectionView;
@property (retain, nonatomic) UIView *noWarningsView;
@property (retain, nonatomic) UITextView *messageLbl;

- (void)LoadLogin:(id)sender;
- (void)UpdateWarnings:(id)sender;

@end

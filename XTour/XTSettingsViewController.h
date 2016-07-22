//
//  XTSettingsViewController.h
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"

@interface XTSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    XTDataSingleton *data;
}

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) UITextView *info;
@property (nonatomic,retain) NSDictionary *tableArrays;
@property (nonatomic,retain) NSArray *sectionTitles;
@property (nonatomic,retain) NSArray *sectionFooter;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic,retain) UISlider *sliderWarning;
@property (nonatomic,retain) UISlider *sliderTours;
@property (nonatomic,retain) UILabel *WarningValue;
@property (nonatomic,retain) UILabel *ToursValue;

- (void)switchSaveImagesChanged:(id)sender;
- (void)switchAnonymousChanged:(id)sender;
- (void)switchSafetyChanged:(id)sender;
- (void)switchBatterySafeModusChanged:(id)sender;
- (void)WarningRadiusChanged:(id)sender;
- (void)ToursRadiusChanged:(id)sender;

@end

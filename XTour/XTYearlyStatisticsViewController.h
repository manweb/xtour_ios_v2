//
//  XTYearlyStatisticsViewController.h
//  XTour
//
//  Created by Manuel Weber on 11/10/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTServerRequestHandler.h"
#import "XTDataSingleton.h"

@interface XTYearlyStatisticsViewController : UIViewController
{
    XTDataSingleton *data;
}

@property(nonatomic, retain) NSMutableArray *weekViews;

- (void) LoadData;

@end

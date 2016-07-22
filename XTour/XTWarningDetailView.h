//
//  XTWarningDetailView.h
//  XTour
//
//  Created by Manuel Weber on 21/01/16.
//  Copyright © 2016 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTWarningsInfo.h"
@import GoogleMaps;

@interface XTWarningDetailView : UIViewController
{
    GMSMapView *mapView;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) UIView *cellView;
@property(nonatomic, retain) UILabel *warningTitle;
@property(nonatomic, retain) UITextView *warningDescription;
@property (nonatomic,retain) NSMutableArray *categories;
@property (nonatomic,retain) UIView *mapViewContainer;
@property (nonatomic,retain) UIView *descriptionViewContainer;
@property (nonatomic,retain) UITextView *descriptionTextField;
@property (nonatomic,retain) UIVisualEffectView *blurEffectView;

- (void) LoadInfo:(XTWarningsInfo *)warningsInfo withFrame:(CGRect)frame;
- (void) Animate;

@end

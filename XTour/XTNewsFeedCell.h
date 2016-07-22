//
//  XTNewsFeedCell.h
//  XTour
//
//  Created by Manuel Weber on 16/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTNewsFeedCell : UICollectionViewCell

@property(nonatomic, retain) UILabel *title;
@property(nonatomic, retain) UILabel *time;
@property(nonatomic, retain) UILabel *altitude;
@property(nonatomic, retain) UILabel *distance;
@property(nonatomic, retain) UIImageView *profilePicture;
@property(nonatomic, retain) UIImageView *timeIcon;
@property(nonatomic, retain) UIImageView *altitudeIcon;
@property(nonatomic, retain) UIImageView *distanceIcon;
@property(nonatomic, retain) UITextView *tourDescription;
@property(nonatomic, retain) UIView *gradientOverlay;
@property(nonatomic, retain) UIButton *moreButton;
@property(nonatomic, retain) UIImageView *comments;
@property(nonatomic, retain) UIImageView *pictures;
@property(nonatomic, retain) UILabel *numberOfComments;
@property(nonatomic, retain) UILabel *numberOfPictures;

- (void) SetNumberOfComments:(NSInteger)numberOfComments andNumberOfPictures:(NSInteger)numberOfPictures;
- (void) HideInfo;
- (void) ShowInfo;

@end

//
//  XTWishlistViewCell.h
//  XTour
//
//  Created by Manuel Weber on 07/12/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTWishlistViewCell : UICollectionViewCell

@property (nonatomic,retain) UIImageView *icon;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *timeLabel;
@property (nonatomic,retain) UILabel *altitudeLabel;
@property (nonatomic,retain) UILabel *distanceLabel;
@property (nonatomic,retain) UILabel *highestPointLabel;
@property (nonatomic,retain) UILabel *mountainPeakLabel;
@property (nonatomic,retain) UILabel *title;
@property (nonatomic,retain) UILabel *time;
@property (nonatomic,retain) UILabel *altitude;
@property (nonatomic,retain) UILabel *distance;
@property (nonatomic,retain) UILabel *highestPoint;
@property (nonatomic,retain) UILabel *mountainPeak;
@property (nonatomic,retain) UIButton *moreButton;
@property (nonatomic,retain) UIButton *startButton;
@property (nonatomic,retain) UIView *overlay;
@property (nonatomic,retain) UILabel *overlayText;

@end

//
//  XTImageDetailView.h
//  XTour
//
//  Created by Manuel Weber on 25/05/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTImageInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XTImageEditViewController.h"
#import "XTDataSingleton.h"

@interface XTImageDetailView : UIView <UIActionSheetDelegate>
{
    XTImageEditViewController *imageEdit;
    XTImageInfo *image;
    XTDataSingleton *data;
}

@property (retain,nonatomic) UIImageView *imageView;
@property(retain, nonatomic) UIView *coordinatesBackground;
@property(retain, nonatomic) UIView *commentBackground;
@property(retain, nonatomic) UILabel *imgLongitudeLabel;
@property(retain, nonatomic) UILabel *imgLatitudeLabel;
@property(retain, nonatomic) UILabel *imgElevationLabel;
@property(retain, nonatomic) UILabel *imgCommentLabel;
@property(retain, nonatomic) UIImageView *compassImage;
@property(retain, nonatomic) UIButton *editIcon;
@property(retain, nonatomic) UIButton *deleteIcon;
@property (nonatomic) CGRect cellRect;
@property (nonatomic) CGFloat fullWidth;
@property (nonatomic) CGFloat fullHeight;
@property (nonatomic) CGFloat yOffset;
@property (nonatomic) CGFloat xOffset;
@property (nonatomic) NSUInteger imageID;

- (id)initWithFrame:(CGRect)frame fromPosition:(CGRect)originRect withImage:(XTImageInfo*)imageInfo andImageID:(NSUInteger)ID;
- (NSString*)GetFormattedLongitude:(float)longitude;
- (NSString*)GetFormattedLatitude:(float)latitude;
- (void)animate;
- (void)close:(id)sender;

@end

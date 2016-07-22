//
//  XTSummaryImageViewController.h
//  XTour
//
//  Created by Manuel Weber on 14/05/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "XTImageInfo.h"
#import "XTImageDetailView.h"

@interface XTSummaryImageViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}

@property (retain, nonatomic) NSMutableArray *images;
@property (retain, nonatomic) UIImageView *selectedImageView;
@property (retain, nonatomic) UIImageView *background;
@property(retain, nonatomic) UILabel *imgLongitudeLabel;
@property(retain, nonatomic) UILabel *imgLatitudeLabel;
@property(retain, nonatomic) UILabel *imgElevationLabel;
@property(retain, nonatomic) UILabel *imgCommentLabel;
@property(retain, nonatomic) UIImageView *compassImage;
@property (nonatomic) CGRect cellRect;
@property(retain, nonatomic) NSIndexPath *selectedIndexPath;

@end

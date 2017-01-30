//
//  XTCameraViewController.h
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTLoginViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "XTImageInfo.h"
#import "XTImageDetailView.h"
#import "XTProfileViewController.h"
#import "XTNavigationViewContainer.h"

@interface XTCameraViewController : UICollectionViewController <UIActionSheetDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    XTDataSingleton *data;
}

@property(retain, nonatomic) NSMutableArray *ImageArray;
@property(retain, nonatomic) UIButton *CameraIcon;
@property(retain, nonatomic) UIImagePickerController *ImagePicker;
@property(retain, nonatomic) UIImageView *selectedImageView;
@property(retain, nonatomic) UIImageView *background;
@property(retain, nonatomic) UILabel *imgLongitudeLabel;
@property(retain, nonatomic) UILabel *imgLatitudeLabel;
@property(retain, nonatomic) UILabel *imgElevationLabel;
@property(retain, nonatomic) UILabel *imgCommentLabel;
@property(retain, nonatomic) UIImageView *compassImage;
@property(nonatomic) CGRect cellRect;
@property(retain, nonatomic) NSIndexPath *selectedIndexPath;
@property(nonatomic) BOOL didPickImage;

- (void) LoadCamera:(id)sender;

@end

//
//  XTImageEditViewController.h
//  XTour
//
//  Created by Manuel Weber on 25/05/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTImageInfo.h"
#import "XTServerRequestHandler.h"

@interface XTImageEditViewController : UIViewController
{
    XTDataSingleton *data;
    XTImageInfo *imageInfo;
}

@property (retain,nonatomic) UIView *imageEditView;
@property (retain,nonatomic) UITextView *imageInfoComment;
@property (retain, nonatomic) UIButton *loginButton;
@property (retain, nonatomic) UIButton *cancelButton;
@property (nonatomic) NSUInteger imageID;
@property (retain, nonatomic) UIVisualEffectView *blurEffectView;

- (id) initWithImageInfo:(XTImageInfo*)imageInfo andID:(NSUInteger)ID;
- (void)Cancel;
- (void) animate;
- (void) ShowView;
- (void) HideView;

@end

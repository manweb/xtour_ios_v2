//
//  XTNavigationViewContainer.h
//  XTour
//
//  Created by Manuel Weber on 28/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTLoginViewController.h"

@interface XTNavigationViewContainer : UIViewController <UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
}

@property (retain, nonatomic) UIView *header;
@property (retain, nonatomic) UIView *header_shadow;
@property (retain, nonatomic) UIView *header_background;
@property (retain, nonatomic) UIButton *loginButton;
@property(nonatomic,retain) UIButton *backButton;
@property(nonatomic,retain) UILabel *navigationTitle;
@property(nonatomic,retain) UIView *contentView;
@property(nonatomic) float width;
@property(nonatomic) float height;
@property(nonatomic) float tabBarHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil view:(UIView*)navigationView title:(NSString*)navigationTitle isFirstView:(bool)firstView;
- (void) LoadLogin:(id)sender;
- (void) ShowLoginOptions:(id)sender;
- (void) LoginViewDidClose:(id)sender;
- (void) ShowView;
- (void) HideView;
- (void) back:(id)sender;
- (void) ClearContentView;

@end

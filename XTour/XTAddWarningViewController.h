//
//  XTAddWarningViewController.h
//  XTour
//
//  Created by Manuel Weber on 13/01/16.
//  Copyright © 2016 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTWarningsInfo.h"
#import "XTServerRequestHandler.h"

@interface XTAddWarningViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    XTDataSingleton *data;
    XTServerRequestHandler *request;
}

@property (nonatomic,retain) UIPickerView *pickerView;
@property (nonatomic,retain) UIVisualEffectView *blurEffectView;
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIView *addWarningView;
@property (nonatomic,retain) UITextView *warningComment;
@property (nonatomic,retain) UIButton *cancelButton;
@property (nonatomic,retain) UIButton *loginButton;
@property (nonatomic,retain) XTWarningsInfo *warning;
@property (nonatomic,retain) NSMutableArray *categories;
@property (nonatomic,retain) UIButton *warning1;
@property (nonatomic,retain) UIButton *warning2;
@property (nonatomic,retain) UIButton *warning3;
@property (nonatomic,retain) UIButton *warning4;
@property (nonatomic,retain) UIButton *warning5;
@property (nonatomic,retain) UIView *selectedWarning;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil warningInfo:(XTWarningsInfo *)warning;
- (void) Enter;
- (void) Cancel;
- (void) animate;
- (void) ShowView;
- (void) HideView;

@end

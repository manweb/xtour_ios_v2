//
//  XTImageDetailView.m
//  XTour
//
//  Created by Manuel Weber on 25/05/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTImageDetailView.h"

@implementation XTImageDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame fromPosition:(CGRect)originRect withImage:(XTImageInfo*)imageInfo andImageID:(NSUInteger)ID
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        
        _cellRect = originRect;
        
        image = imageInfo;
        _imageID = ID;
        
        data = [XTDataSingleton singleObj];
        
        if (!_imageView) {_imageView = [[UIImageView alloc] initWithFrame:originRect];}
        UIImageView *selectedImage = [[UIImageView alloc] init];
        
        if ([imageInfo.Filename containsString:@"http://www.xtour.ch"]) {
            [selectedImage setImageWithURL:[NSURL URLWithString:imageInfo.Filename]];
        }
        else {selectedImage.image = [UIImage imageWithContentsOfFile:imageInfo.Filename];}
        
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = true;
        _imageView.image = selectedImage.image;
        
        CGFloat imgWidth = selectedImage.image.size.width;
        CGFloat imgHeight = selectedImage.image.size.height;
        
        CGFloat screenWidth = frame.size.width;
        CGFloat screenHeight = frame.size.height;
        
        _fullWidth = screenWidth;
        _fullHeight = imgHeight/imgWidth*_fullWidth;
        _yOffset = screenHeight/2. - _fullHeight/2.;
        _xOffset = 0;
        
        _coordinatesBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 50)];
        
        _coordinatesBackground.backgroundColor = [UIColor blackColor];
        
        _commentBackground = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-50, screenWidth, 50)];
        
        _commentBackground.backgroundColor = [UIColor blackColor];
        
        if (!_compassImage) {
            _compassImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
            _compassImage.image = [UIImage imageNamed:@"compass_icon_white.png"];
        }
        
        if (!_imgLongitudeLabel) {
            _imgLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 100, 20)];
            _imgLongitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            _imgLongitudeLabel.textColor = [UIColor whiteColor];
        }
        
        if (!_imgLatitudeLabel) {
            _imgLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 25, 100, 20)];
            _imgLatitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            _imgLatitudeLabel.textColor = [UIColor whiteColor];
        }
        
        if (!_imgElevationLabel) {
            _imgElevationLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 100, 20)];
            _imgElevationLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            _imgElevationLabel.textColor = [UIColor whiteColor];
        }
        
        if (imageInfo.Longitude) {_imgLongitudeLabel.text = [self GetFormattedLongitude:imageInfo.Longitude];}
        else {_imgLongitudeLabel.text = @"";}
        
        if (imageInfo.Latitude) {_imgLatitudeLabel.text = [self GetFormattedLatitude:imageInfo.Latitude];}
        else {_imgLatitudeLabel.text = @"";}
        
        if (imageInfo.Elevation) {_imgElevationLabel.text = [NSString stringWithFormat:@"%.0f müm",imageInfo.Elevation];}
        else {_imgLongitudeLabel.text = @"";}
        
        if (!_imgCommentLabel) {
            _imgCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 20)];
            _imgCommentLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            _imgCommentLabel.textColor = [UIColor whiteColor];
        }
        
        if (imageInfo.Comment) {_imgCommentLabel.text = imageInfo.Comment;}
        else {_imgCommentLabel.text = @"Noch kein Kommentar";}
        
        if (!_editIcon) {
            _editIcon = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-30, 5, 25, 25)];
            [_editIcon setBackgroundImage:[UIImage imageNamed:@"edit_icon.png"] forState:UIControlStateNormal];
            [_editIcon addTarget:self action:@selector(EditImageInfo:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (!_deleteIcon) {
            _deleteIcon = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-30, 15, 25, 25)];
            [_deleteIcon setBackgroundImage:[UIImage imageNamed:@"delete_icon.png"] forState:UIControlStateNormal];
            [_deleteIcon addTarget:self action:@selector(DeleteImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_coordinatesBackground setHidden:YES];
        [_commentBackground setHidden:YES];
        
        [_coordinatesBackground addSubview:_compassImage];
        [_coordinatesBackground addSubview:_imgLongitudeLabel];
        [_coordinatesBackground addSubview:_imgLatitudeLabel];
        [_coordinatesBackground addSubview:_imgElevationLabel];
        if ([imageInfo.userID isEqualToString:data.userID]) {[_coordinatesBackground addSubview:_deleteIcon];}
        [_commentBackground addSubview:_imgCommentLabel];
        if ([imageInfo.userID isEqualToString:data.userID]) {[_commentBackground addSubview:_editIcon];}
        
        [self addSubview:_imageView];
        [self addSubview:_coordinatesBackground];
        [self addSubview:_commentBackground];
        
        [selectedImage release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishEditingImageInfo:) name:@"ImageInfoEditingFinished" object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [_imageView release];
    [_coordinatesBackground release];
    [_commentBackground release];
    [_imgLongitudeLabel release];
    [_imgLatitudeLabel release];
    [_imgElevationLabel release];
    [_imgCommentLabel release];
    [_compassImage release];
    [_editIcon release];
    [_deleteIcon release];
    [super dealloc];
}

- (void)animate
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _imageView.frame = CGRectMake(_xOffset-10, _yOffset-10, _fullWidth+20, _fullHeight+20);
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    } completion:^(BOOL finished)
     {
         UITapGestureRecognizer *tapRecognition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
         tapRecognition.numberOfTapsRequired = 1;
         
         _imageView.userInteractionEnabled = YES;
         
         [_imageView addGestureRecognizer:tapRecognition];
         [UIView animateWithDuration:0.2f animations:^(void) {
             _imageView.frame = CGRectMake(_xOffset, _yOffset, _fullWidth, _fullHeight);
             
             [_coordinatesBackground setHidden:NO];
             [_commentBackground setHidden:NO];
         }];
     }];
}

- (void)close:(id)sender
{
    [_coordinatesBackground removeFromSuperview];
    [_commentBackground removeFromSuperview];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _imageView.frame = CGRectMake(_cellRect.origin.x + 3, _cellRect.origin.y + 3, _cellRect.size.width - 6, _cellRect.size.height - 6);
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^(void) {
            _imageView.frame = _cellRect;
        } completion:^(BOOL finished) {
            [_imageView removeFromSuperview];
            [self removeFromSuperview];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageDetailViewDismissed" object:nil userInfo:nil];
        }];
    }];
}

- (void)EditImageInfo:(id)sender
{
    if (imageEdit) {[imageEdit.view removeFromSuperview];}
    
    imageEdit = [[XTImageEditViewController alloc] initWithImageInfo:image andID:_imageID];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:imageEdit.view];
    [imageEdit animate];
}

- (void)DeleteImage:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Möchtest du dieses Foto wirklich löschen?" delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:@"Löschen" otherButtonTitles:nil, nil];
    
    [actionSheet showInView:self];
}

- (void)didFinishEditingImageInfo:(id)sender
{
    _imgCommentLabel.text = [data GetImageInfoAt:_imageID].Comment;
    
    if ([_imgCommentLabel.text isEqualToString:@""]) {_imgCommentLabel.text = @"Noch kein Kommentar";}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Löschen"]) {
        [data DeleteImageAtIndex:_imageID];
        
        [self close:nil];
    }
}

- (NSString*)GetFormattedLongitude:(float)longitude
{
    NSString *lonEW;
    if (longitude < 0) {lonEW = @"W"; longitude = fabs(longitude);}
    else {lonEW = @"E";}
    
    NSString *lonString = [NSString stringWithFormat:@"%.0f°%.0f'%.1f\" %s",
                           floor(longitude),
                           floor((longitude - floor(longitude)) * 60),
                           ((longitude - floor(longitude)) * 60 - floor((longitude - floor(longitude)) * 60)) * 60, [lonEW UTF8String]];
    
    return lonString;
}

- (NSString*)GetFormattedLatitude:(float)latitude
{
    NSString *latNS;
    if (latitude < 0) {latNS = @"S"; latitude = fabs(latitude);}
    else {latNS = @"N";}
    
    NSString *latString = [NSString stringWithFormat:@"%.0f°%.0f'%.1f\" %s",
                           floor(latitude),
                           floor((latitude - floor(latitude)) * 60),
                           ((latitude - floor(latitude)) * 60 - floor((latitude - floor(latitude)) * 60)) * 60, [latNS UTF8String]];
    
    return latString;
}

@end

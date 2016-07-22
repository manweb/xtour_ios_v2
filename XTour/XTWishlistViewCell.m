//
//  XTWishlistViewCell.m
//  XTour
//
//  Created by Manuel Weber on 07/12/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import "XTWishlistViewCell.h"

@implementation XTWishlistViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        float boxRadius = 5.f;
        float boxBorderWidth = 1.0f;
        UIColor *boxBorderColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 22, 40, 40)];
        
        _icon.image = [UIImage imageNamed:@"wishlist_icon@3x.png"];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, frame.size.width/2, 14)];
        
        _title.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        _title.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 43, frame.size.width/2-55, 12)];
        
        _timeLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        
        _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        
        _timeLabel.text = @"Dauer";
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2+5, 43, frame.size.width/2-60, 12)];
        
        _distanceLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        
        _distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        
        _distanceLabel.text = @"Distanz";
        
        _altitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 80, frame.size.width/2-55, 12)];
        
        _altitudeLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        
        _altitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        
        _altitudeLabel.text = @"Höhendifferenz";
        
        _highestPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2+5, 80, frame.size.width/2-60, 12)];
        
        _highestPointLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        
        _highestPointLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        
        _highestPointLabel.text = @"Höchster Punkt";
        
        _mountainPeak = [[UILabel alloc] initWithFrame:CGRectMake(55, 22, frame.size.width-110, 18)];
        
        _mountainPeak.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(55, 58, frame.size.width/2-55, 15)];
        
        _time.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        
        _distance = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2+5, 58, frame.size.width/2-60, 16)];
        
        _distance.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        
        _altitude = [[UILabel alloc] initWithFrame:CGRectMake(55, 95, frame.size.width/2-55, 15)];
        
        _altitude.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        
        _highestPoint = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2+5, 95, frame.size.width/2-60, 15)];
        
        _highestPoint.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        _moreButton.frame = CGRectMake(frame.size.width-40, 25, 20, 20);
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"delete_icon_gray@3x.png"] forState:UIControlStateNormal];
        
        _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        _startButton.frame = CGRectMake(frame.size.width-55, 71, 50, 28);
        [_startButton setBackgroundImage:[UIImage imageNamed:@"start_tour_icon@3x.png"] forState:UIControlStateNormal];
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-56, 10, 1, 100)];
        
        verticalLine.backgroundColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-55, 60, 50, 1)];
        
        horizontalLine.backgroundColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        
        _overlay = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width-250)/2, 10, 250, 50)];
        
        _overlay.backgroundColor = [UIColor blackColor];
        _overlay.layer.cornerRadius = boxRadius;
        [_overlay setAlpha:0.8];
        [_overlay setHidden:YES];
        
        _overlayText = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 240, 40)];
        
        _overlayText.backgroundColor = [UIColor clearColor];
        _overlayText.textColor = [UIColor whiteColor];
        _overlayText.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        _overlayText.text = @"Folge dieser Tour";
        _overlayText.textAlignment = NSTextAlignmentCenter;
        
        [_overlay addSubview:_overlayText];
        
        [self addSubview:_icon];
        [self addSubview:_title];
        [self addSubview:_timeLabel];
        [self addSubview:_distanceLabel];
        [self addSubview:_altitudeLabel];
        [self addSubview:_highestPointLabel];
        [self addSubview:_mountainPeak];
        [self addSubview:_time];
        [self addSubview:_distance];
        [self addSubview:_altitude];
        [self addSubview:_highestPoint];
        [self addSubview:_moreButton];
        [self addSubview:_startButton];
        [self addSubview:verticalLine];
        [self addSubview:horizontalLine];
        [self addSubview:_overlay];
        
        [verticalLine release];
        [horizontalLine release];
        
        self.layer.borderWidth = boxBorderWidth;
        self.layer.borderColor = boxBorderColor.CGColor;
        self.layer.cornerRadius = boxRadius;
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [_icon release];
    [_title release];
    [_timeLabel release];
    [_distanceLabel release];
    [_altitudeLabel release];
    [_highestPointLabel release];
    [_mountainPeak release];
    [_time release];
    [_distance release];
    [_altitude release];
    [_highestPoint release];
    [_moreButton release];
    [_startButton release];
}

@end

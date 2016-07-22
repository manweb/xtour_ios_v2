//
//  XTWarningCell.m
//  XTour
//
//  Created by Manuel Weber on 05/07/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTWarningCell.h"

@implementation XTWarningCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        float boxRadius = 5.f;
        float boxBorderWidth = 1.0f;
        UIColor *boxBorderColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        
        UIImageView *warningIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        
        warningIcon.image = [UIImage imageNamed:@"warning_icon@3x.png"];
        
        _warningTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 235, 20)];
        
        _warningTitle.font = [UIFont fontWithName:@"Helvetica-BoldMT" size:12];
        _warningTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
        
        _warningDescription = [[UITextView alloc] initWithFrame:CGRectMake(60, 25, 235, 60)];
        
        _warningDescription.font = [UIFont fontWithName:@"Helvetica" size:12];
        _warningDescription.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
        [_warningDescription setEditable:NO];
        [_warningDescription setUserInteractionEnabled:NO];
        
        [self addSubview:warningIcon];
        [self addSubview:_warningTitle];
        [self addSubview:_warningDescription];
        
        self.layer.borderWidth = boxBorderWidth;
        self.layer.borderColor = boxBorderColor.CGColor;
        self.layer.cornerRadius = boxRadius;
        
        [warningIcon release];
    }
    
    return self;
}

- (void)dealloc {
    [_warningTitle release];
    [_warningDescription release];
    [super dealloc];
}

@end

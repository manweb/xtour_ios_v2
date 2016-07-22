//
//  XTWarningsInfo.m
//  XTour
//
//  Created by Manuel Weber on 17/06/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTWarningsInfo.h"

@implementation XTWarningsInfo

- (void) ClearData
{
    _userID = nil;
    _tourID = nil;
    _userName = nil;
    _submitDate = nil;
    _category = 0;
    _longitude = 0;
    _latitude = 0;
    _elevation = 0;
    _comment = nil;
    _distance = 0;
}

@end

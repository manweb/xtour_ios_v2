//
//  XTSettings.m
//  XTour
//
//  Created by Manuel Weber on 12/09/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTSettings.h"

@implementation XTSettings

- (id) init
{
    _equipment = 0;
    _saveOriginalImage = true;
    _anonymousTracking = false;
    _safetyModus = false;
    _warningRadius = 20.0f;
    _toursRadius = 20.0f;
    _batterySafeMode = false;
    
    return [super init];
}

@end

//
//  XTUserStatistics.m
//  XTour
//
//  Created by Manuel Weber on 01/10/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import "XTUserStatistics.h"

@implementation XTUserStatistics

- (id) init
{
    _monthlyNumberOfTours = 0;
    _monthlyTime = 0;
    _monthlyDistance = 0;
    _monthlyAltitude = 0;
    _seasonalNumberOfTours = 0;
    _seasonalTime = 0;
    _seasonalDistance = 0;
    _seasonalAltitude = 0;
    _totalNumberOfTours = 0;
    _totalTime = 0;
    _totalDistance = 0;
    _totalAltitude = 0;
    
    return [super init];
}

@end

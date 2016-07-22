//
//  XTUserStatistics.h
//  XTour
//
//  Created by Manuel Weber on 01/10/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTUserStatistics : NSObject

@property (nonatomic) NSInteger monthlyNumberOfTours;
@property (nonatomic) NSInteger monthlyTime;
@property (nonatomic) float monthlyDistance;
@property (nonatomic) float monthlyAltitude;
@property (nonatomic) NSInteger seasonalNumberOfTours;
@property (nonatomic) NSInteger seasonalTime;
@property (nonatomic) float seasonalDistance;
@property (nonatomic) float seasonalAltitude;
@property (nonatomic) NSInteger totalNumberOfTours;
@property (nonatomic) NSInteger totalTime;
@property (nonatomic) float totalDistance;
@property (nonatomic) float totalAltitude;

@end

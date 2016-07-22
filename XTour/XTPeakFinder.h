//
//  XTPeakFinder.h
//  XTour
//
//  Created by Manuel Weber on 26/11/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface XTPeakFinder : NSObject

@property (nonatomic,retain) NSString *peakName;
@property (nonatomic) float peakLongitude;
@property (nonatomic) float peakLatitude;
@property (nonatomic) float peakAltitude;
@property (nonatomic) float distance;
@property (nonatomic,retain) NSMutableArray *peaksArray;

- (void) FindPeakAtLongitude:(float)longitude latitude:(float)latitude country:(NSString*)country;
- (NSString*) GetPeakName;
- (NSMutableArray*) GetPeak;
- (float) GetPeakLongitude;
- (float) GetPeakLatitude;
- (float) GetPeakAltitude;
- (NSMutableArray*) GetAlternativePeaks;
- (float) CalculateHaversineDistanceForPoint:(NSArray*)p1 and:(NSArray*)p2;

@end

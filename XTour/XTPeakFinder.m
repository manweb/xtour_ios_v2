//
//  XTPeakFinder.m
//  XTour
//
//  Created by Manuel Weber on 26/11/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import "XTPeakFinder.h"

@implementation XTPeakFinder

- (void) FindPeakAtLongitude:(float)longitude latitude:(float)latitude country:(NSString *)country
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filename = [mainBundle pathForResource:@"mountain_peaks_ch" ofType:@"xml"];
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filename];
    GDataXMLDocument *mountainPeaksFile = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    GDataXMLElement *mountainPeaks = [[mountainPeaksFile.rootElement elementsForName:@"MountainPeaks"] objectAtIndex:0];
    
    NSArray *peaks = [mountainPeaks elementsForName:@"Peak"];
    
    _distance = 1e6;
    _peaksArray = [[NSMutableArray alloc] init];
    NSString *name;
    float lon;
    float lat;
    float alt;
    for (int i = 0; i < [peaks count]; i++) {
        GDataXMLElement *peak = [peaks objectAtIndex:i];
        
        name = [[[peak elementsForName:@"Name"] objectAtIndex:0] stringValue];
        lon = [[[[peak elementsForName:@"Longitude"] objectAtIndex:0] stringValue] floatValue];
        lat = [[[[peak elementsForName:@"Latitude"] objectAtIndex:0] stringValue] floatValue];
        alt = [[[[peak elementsForName:@"Altitude"] objectAtIndex:0] stringValue] floatValue];
        
        float d = [self CalculateHaversineDistanceForPoint:[NSArray arrayWithObjects:[NSNumber numberWithFloat:longitude], [NSNumber numberWithFloat:latitude], nil] and:[NSArray arrayWithObjects:[NSNumber numberWithFloat:lon], [NSNumber numberWithFloat:lat], nil]];

        if (d < _distance) {
            _peakName = name;
            _peakLongitude = lon;
            _peakLatitude = lat;
            _peakAltitude = alt;
            
            _distance = d;
        }
        
        if (d < 5.0) {
            NSArray *arrTMP = [NSArray arrayWithObjects:name, [NSNumber numberWithFloat:lon], [NSNumber numberWithFloat:lat], [NSNumber numberWithFloat:alt], [NSNumber numberWithFloat:d], nil];
            
            [_peaksArray addObject:arrTMP];
        }
    }
}

- (NSMutableArray*) GetPeak
{
    NSMutableArray *peak = nil;
    
    if (_distance < 1.0) {
        peak = [NSMutableArray arrayWithObjects:[NSString stringWithString:_peakName], [NSNumber numberWithFloat:_peakLongitude], [NSNumber numberWithFloat:_peakLatitude], [NSNumber numberWithFloat:_peakAltitude], [NSNumber numberWithFloat:_distance], nil];
    }
    
    return peak;
}

- (NSString*) GetPeakName
{
    return _peakName;
}

- (float) GetPeakLongitude
{
    return _peakLongitude;
}

- (float) GetPeakLatitude
{
    return _peakLatitude;
}

- (float) GetPeakAltitude
{
    return _peakAltitude;
}

- (NSMutableArray*) GetAlternativePeaks
{
    return _peaksArray;
}

- (float) CalculateHaversineDistanceForPoint:(NSArray *)p1 and:(NSArray *)p2
{
    float longitude1 = M_PI / 180.0 * [[p1 objectAtIndex:0] floatValue];
    float latitude1 = M_PI / 180.0 * [[p1 objectAtIndex:1] floatValue];
    float longitude2 = M_PI / 180.0 * [[p2 objectAtIndex:0] floatValue];
    float latitude2 = M_PI / 180.0 * [[p2 objectAtIndex:1] floatValue];
    
    double r = 6371.0;
    
    double h_phi1_phi2 = sin((latitude2 - latitude1)/2.0)*sin((latitude2 - latitude1)/2.0);
    double h_lambda1_lambda2 = sin((longitude2 - longitude1)/2.0)*sin((longitude2 - longitude1)/2.0);
    
    double d = 2*r*asin(sqrt(h_phi1_phi2 + cos(latitude1)*cos(latitude2)*h_lambda1_lambda2));
    
    return d;
}

@end

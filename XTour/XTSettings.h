//
//  XTSettings.h
//  XTour
//
//  Created by Manuel Weber on 12/09/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTSettings : NSObject

@property (nonatomic) NSInteger equipment;
@property (nonatomic) bool saveOriginalImage;
@property (nonatomic) bool anonymousTracking;
@property (nonatomic) bool safetyModus;
@property (nonatomic) float warningRadius;
@property (nonatomic) float toursRadius;
@property (nonatomic) bool batterySafeMode;

@end

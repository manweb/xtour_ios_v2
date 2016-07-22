//
//  XTTourInfo.h
//  XTour
//
//  Created by Manuel Weber on 05/05/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTTourInfo : NSObject

@property (retain, nonatomic) NSString *tourID;
@property (retain, nonatomic) NSString *userID;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *profilePicture;
@property (nonatomic) NSUInteger date;
@property (nonatomic) NSUInteger totalTime;
@property (nonatomic) float altitude;
@property (nonatomic) float distance;
@property (nonatomic) float descent;
@property (nonatomic) float lowestPoint;
@property (nonatomic) float highestPoint;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (retain, nonatomic) NSString *country;
@property (retain, nonatomic) NSString *province;
@property (retain, nonatomic) NSString *tourDescription;
@property (nonatomic) NSInteger tourRating;
@property (retain, nonatomic) NSString *mountainPeak;
@property (retain,nonatomic) NSMutableArray *tracks;
@property (nonatomic) NSInteger numberOfComments;
@property (nonatomic) NSInteger numberOfImages;

@end

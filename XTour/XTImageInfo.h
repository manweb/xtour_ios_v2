//
//  XTImageInfo.h
//  XTour
//
//  Created by Manuel Weber on 22/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTImageInfo : NSObject

@property (retain,nonatomic) NSString *userID;
@property (retain,nonatomic) NSString *tourID;
@property (retain,nonatomic) NSString *Filename;
@property (nonatomic) float Longitude;
@property (nonatomic) float Latitude;
@property (nonatomic) float Elevation;
@property (retain,nonatomic) NSString *Comment;
@property (retain,nonatomic) NSDate *Date;

@end

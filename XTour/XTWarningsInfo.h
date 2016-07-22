//
//  XTWarningsInfo.h
//  XTour
//
//  Created by Manuel Weber on 17/06/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTWarningsInfo : NSObject

@property(nonatomic, retain) NSString *userID;
@property(nonatomic, retain) NSString *tourID;
@property(nonatomic, retain) NSString *userName;
@property(nonatomic, retain) NSString *submitDate;
@property(nonatomic) NSUInteger category;
@property(nonatomic) float longitude;
@property(nonatomic) float latitude;
@property(nonatomic) float elevation;
@property(nonatomic, retain) NSString *comment;
@property(nonatomic) float distance;

- (void) ClearData;

@end

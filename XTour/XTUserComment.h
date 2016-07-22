//
//  XTUserComment.h
//  XTour
//
//  Created by Manuel Weber on 17/01/16.
//  Copyright © 2016 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTUserComment : NSObject

@property (nonatomic,retain) NSString *userID;
@property (nonatomic,retain) NSString *tourID;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic) NSInteger commentDate;
@property (nonatomic,retain) NSString *comment;

@end

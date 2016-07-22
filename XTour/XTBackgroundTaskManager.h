//
//  XTBackgroundTaskManager.h
//  XTour
//
//  Created by Manuel Weber on 06/10/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTBackgroundTaskManager : NSObject

@property (nonatomic, retain)NSMutableArray* bgTaskIdList;
@property (assign) UIBackgroundTaskIdentifier masterTaskId;

+ (instancetype)sharedBackgroundTaskManager;

- (UIBackgroundTaskIdentifier)beginNewBackgroundTask;
- (void)endAllBackgroundTasks;

@end

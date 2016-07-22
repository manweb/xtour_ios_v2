//
//  XTFileUploader.h
//  XTour
//
//  Created by Manuel Weber on 25/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTDataSingleton.h"
#import "XTAppDelegate.h"

@interface XTFileUploader : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate>
{
    XTDataSingleton *data;
}

@property (nonatomic,retain) NSURLSession *session;
@property (nonatomic,retain) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic,retain) NSMutableURLRequest *request;
@property (nonatomic,retain) NSMutableDictionary *backgroundTasks;
@property (nonatomic) NSUInteger backgroundTaskStartTime;
@property (nonatomic) bool sendNotification;
@property (nonatomic) bool hasUnfinishedTasks;

- (NSArray *) GetTourDirList;
- (NSArray *) GetFileList;
- (NSArray *) GetImageList;
- (void) UploadGPXFiles;
- (void) UploadImages;
- (void) UploadImageInfo;
- (void) UploadFile:(NSString *) filename;

@end

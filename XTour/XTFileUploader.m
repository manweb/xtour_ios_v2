//
//  XTFileUploader.m
//  XTour
//
//  Created by Manuel Weber on 25/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTFileUploader.h"

@implementation XTFileUploader : NSObject

- (XTFileUploader *) init
{
    if (self = [super init]) {
        data = [XTDataSingleton singleObj];
        
        NSInteger randomNumber = arc4random() % 1000000;
        
        _sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSString stringWithFormat:@"xtour.ch-BackgroundSession-%li",(long)randomNumber]];
        
        _session = [NSURLSession sessionWithConfiguration:_sessionConfiguration delegate:self delegateQueue:nil];
        
        NSURL *url = [NSURL URLWithString:@"http://www.xtour.ch/file_upload.php"];
        
        _request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
        [_request setHTTPMethod:@"POST"];
        [_request addValue:@"multipart/form-data, boundary=XTourFormBoundary" forHTTPHeaderField: @"Content-Type"];
        
        _backgroundTaskStartTime = [[NSDate date] timeIntervalSince1970];
        
        _backgroundTasks = [[NSMutableDictionary alloc] init];
        
        _sendNotification = false;
        
        _hasUnfinishedTasks = false;
    }
    
    return self;
}

- (NSArray *) GetTourDirList
{
    NSString *path = [data GetDocumentFilePathForFile:@"/tours" CheckIfExist:NO];
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    return directoryContent;
}

- (NSArray *) GetFileList
{
    NSArray *ListOfTourDir = [self GetTourDirList];
    NSString *pathTMP = [data GetDocumentFilePathForFile:@"/tours" CheckIfExist:NO];
    NSString *path = [pathTMP stringByAppendingString:@"/"];
    NSMutableArray *fileList = [[[NSMutableArray alloc] init] autorelease];
    
    for (int i = 0; i < [ListOfTourDir count]; i++) {
        NSString *currentFileTMP = [path stringByAppendingString:[ListOfTourDir objectAtIndex:i]];
        NSString *currentFile = [currentFileTMP stringByAppendingString:@"/"];
        
        NSArray *currentDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentFile error:NULL];
        for (int k = 0; k < [currentDirectory count]; k++) {
            if ([[currentDirectory objectAtIndex:k] isEqualToString:@"images"]) {continue;}
            
            NSString *absFilePath = [currentFile stringByAppendingString:[currentDirectory objectAtIndex:k]];
            [fileList addObject:absFilePath];
        }
    }
    
    return fileList;
}

- (NSArray *) GetImageList
{
    NSArray *ListOfTourDir = [self GetTourDirList];
    NSString *pathTMP = [data GetDocumentFilePathForFile:@"/tours" CheckIfExist:NO];
    NSString *path = [pathTMP stringByAppendingString:@"/"];
    NSMutableArray *fileList = [[[NSMutableArray alloc] init] autorelease];
    
    for (int i = 0; i < [ListOfTourDir count]; i++) {
        NSString *currentFileTMP = [path stringByAppendingString:[ListOfTourDir objectAtIndex:i]];
        NSString *currentFile = [currentFileTMP stringByAppendingString:@"/images/"];
        
        NSArray *currentDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentFile error:NULL];
        for (int k = 0; k < [currentDirectory count]; k++) {
            NSString *absFilePath = [currentFile stringByAppendingString:[currentDirectory objectAtIndex:k]];
            [fileList addObject:absFilePath];
        }
    }
    
    return fileList;
}

- (void) UploadGPXFiles
{
    NSMutableArray *GPXFiles = [data GetAllGPXFiles];
    
    for (int i = 0; i < [GPXFiles count]; i++) {
        [self UploadFile:[GPXFiles objectAtIndex:i]];
    }
}

- (void) UploadImages
{
    NSMutableArray *ImageFiles = [data GetAllImages];
    
    for (int i = 0; i < [ImageFiles count]; i++) {
        if ([[ImageFiles objectAtIndex:i] containsString:@"_original"]) {continue;}
        [self UploadFile:[ImageFiles objectAtIndex:i]];
    }
}

- (void) UploadImageInfo
{
    NSMutableArray *ImageInfoFiles = [data GetAllImageInfoFiles];
    
    for (int i = 0; i < [ImageInfoFiles count]; i++) {
        [self UploadFile:[ImageInfoFiles objectAtIndex:i]];
    }
}

- (void) UploadFile:(NSString *) filename
{
    NSString *boundary = @"XTourFormBoundary";
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",data.userID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"files\"; filename=\"%@\"\r\n",filename] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if ([[filename pathExtension] isEqualToString:@"jpg"]) {
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:filename], 1)];
    }
    else {
        [body appendData:[@"Content-Type: text/plain\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithContentsOfFile:filename]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *taskFileName = [filename stringByAppendingString:@".tmp"];
    
    [body writeToFile:taskFileName atomically:YES];
    
    NSURLSessionTask *dataTask = [_session uploadTaskWithRequest:_request fromFile:[NSURL fileURLWithPath:taskFileName]];
    
    NSLog(@"Starting background task %@",taskFileName);
    
    [dataTask resume];
    
    [_backgroundTasks setObject:taskFileName forKey:[NSString stringWithFormat:@"BackgroundTask-%lu",(unsigned long)dataTask.taskIdentifier]];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)responseData
{
    NSString * str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    if ([str containsString:@"Error:"]) {
        NSLog(@"There was a problem uploading a file. Error message: %@",str);
        
        _hasUnfinishedTasks = true;
    }
    else {
        NSLog(@"File %@ was uploaded to the server.",str);
        
        [data RemoveFile:str];
        
        if ([[str pathExtension] isEqualToString:@"jpg"]) {
            NSString *imageOriginal = [str stringByReplacingOccurrencesOfString:@".jpg" withString:@"_original.jpg"];
            
            [data RemoveFile:imageOriginal];
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {NSLog(@"Task %@ failed.",task);}
    else {
        NSLog(@"Task %@ completed.",task);
        
        NSString *taskFileName = [_backgroundTasks objectForKey:[NSString stringWithFormat:@"BackgroundTask-%lu",(unsigned long)task.taskIdentifier]];
        
        [[NSFileManager defaultManager] removeItemAtPath:taskFileName error:nil];
        
        if (!_sendNotification) {
            if ([[NSDate date] timeIntervalSince1970] - _backgroundTaskStartTime > 900) {_sendNotification = true;}
        }
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"Session with id %@ completed",session.configuration.identifier);
    
    if (_sendNotification && !_hasUnfinishedTasks) {
        XTAppDelegate *appDelegate = (XTAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.backgroundSessionCompletionHandler) {
            void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
            appDelegate.backgroundSessionCompletionHandler = nil;
            completionHandler();
        }
    }
}

@end

//
//  XTServerRequestHandler.m
//  XTour
//
//  Created by Manuel Weber on 08/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTServerRequestHandler.h"

@implementation XTServerRequestHandler

- (NSMutableArray *) GetNewsFeedString:(NSData*)responseData
{
    NSMutableArray *news_feeds = [[[NSMutableArray alloc] init] autorelease];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSArray *news_feed_array = [response componentsSeparatedByString:@";"];
    
    for (int i = 0; i < [news_feed_array count] - 1; i++) {
        NSString *elements = [news_feed_array objectAtIndex:i];
        NSArray *element = [elements componentsSeparatedByString:@","];
        
        if ([element count] < 19) {continue;}
        
        XTTourInfo *tourInfo = [[XTTourInfo alloc] init];
        
        tourInfo.tourID = [element objectAtIndex:0];
        tourInfo.userID = [element objectAtIndex:1];
        tourInfo.userName = [element objectAtIndex:2];
        tourInfo.profilePicture = [element objectAtIndex:3];
        tourInfo.date = [[element objectAtIndex:4] integerValue];
        tourInfo.totalTime = [[element objectAtIndex:5] integerValue];
        tourInfo.altitude = [[element objectAtIndex:6] floatValue];
        tourInfo.distance = [[element objectAtIndex:7] floatValue];
        tourInfo.descent = [[element objectAtIndex:8] floatValue];
        tourInfo.lowestPoint = [[element objectAtIndex:9] floatValue];
        tourInfo.highestPoint = [[element objectAtIndex:10] floatValue];
        tourInfo.latitude = [[element objectAtIndex:11] floatValue];
        tourInfo.longitude = [[element objectAtIndex:12] floatValue];
        tourInfo.country = [element objectAtIndex:13];
        tourInfo.province = [element objectAtIndex:14];
        
        NSString *tourDescriptionEncoded = [element objectAtIndex:15];
        tourDescriptionEncoded = [tourDescriptionEncoded stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        tourInfo.tourDescription = [tourDescriptionEncoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        tourInfo.tourRating = [[element objectAtIndex:16] integerValue];
        tourInfo.numberOfComments = [[element objectAtIndex:17] integerValue];
        tourInfo.numberOfImages = [[element objectAtIndex:18] integerValue];
        
        [news_feeds addObject:tourInfo];
        
        [tourInfo release];
    }
    
    return news_feeds;
}

- (void) ProcessTourCoordinates:(NSData*)responseData
{
    _tourFilesType = [[NSMutableArray alloc] init];
    _tourFilesCoordinates = [[NSMutableArray alloc] init];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSArray *files_array = [response componentsSeparatedByString:@"/"];
    NSMutableArray *files = [NSMutableArray arrayWithArray:files_array];
    [files removeLastObject];
    
    for (int i = 0; i < [files count]; i++) {
        NSString *currentFile = [files objectAtIndex:i];
        
        NSArray *coordinates_array = [currentFile componentsSeparatedByString:@";"];
        NSMutableArray *coordinates = [NSMutableArray arrayWithArray:coordinates_array];
        [coordinates removeLastObject];
        
        NSString *tourType = [coordinates objectAtIndex:0];
        [_tourFilesType addObject:tourType];
        
        NSMutableArray *currentTourCoordinate = [[NSMutableArray alloc] init];
        
        for (int k = 1; k < [coordinates count]; k++) {
            NSString *currentCoordinate = [coordinates objectAtIndex:k];
            
            NSArray *LatLon = [currentCoordinate componentsSeparatedByString:@":"];
            float lon = [[LatLon objectAtIndex:0] floatValue];
            float lat = [[LatLon objectAtIndex:1] floatValue];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
            
            [currentTourCoordinate addObject:location];
        }
        
        [_tourFilesCoordinates addObject:currentTourCoordinate];
        
        [currentTourCoordinate release];
    }
}

- (NSMutableArray *) GetImagesForTour:(NSData*)responseData
{
    NSMutableArray *tour_images = [[NSMutableArray alloc] init];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    if ([response isEqualToString:@",,,,,,,;"]) {return nil;}
    
    NSArray *tour_images_array = [response componentsSeparatedByString:@";"];
    NSMutableArray *tour_images_info = [NSMutableArray arrayWithArray:tour_images_array];
    [tour_images_info removeLastObject];
    
    for (int i = 0; i < [tour_images_info count]; i++) {
        XTImageInfo *imageInfo = [[XTImageInfo alloc] init];
        
        NSString *currentImage = [tour_images_info objectAtIndex:i];
        
        NSArray *imageInfoArray = [currentImage componentsSeparatedByString:@","];
        
        if ([imageInfoArray count] < 8) {continue;}
        
        imageInfo.userID = [imageInfoArray objectAtIndex:0];
        imageInfo.tourID = [imageInfoArray objectAtIndex:1];
        imageInfo.Filename = [imageInfoArray objectAtIndex:2];
        imageInfo.Date = [imageInfoArray objectAtIndex:3];
        imageInfo.Longitude = [[imageInfoArray objectAtIndex:4] floatValue];
        imageInfo.Latitude = [[imageInfoArray objectAtIndex:5] floatValue];
        imageInfo.Elevation = [[imageInfoArray objectAtIndex:6] floatValue];
        imageInfo.Comment = [imageInfoArray objectAtIndex:7];
        
        [tour_images addObject:imageInfo];
        
        [imageInfo release];
    }
    
    return tour_images;
}

- (NSMutableArray *) GetUserCommentsForTour:(NSData*)responseData
{
    NSMutableArray *user_comments = [[NSMutableArray alloc] init];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    if ([response isEqualToString:@",,,,;"]) {return nil;}
    
    NSArray *user_comments_array = [response componentsSeparatedByString:@";"];
    NSMutableArray *user_comments_info = [NSMutableArray arrayWithArray:user_comments_array];
    [user_comments_info removeLastObject];
    
    for (int i = 0; i < [user_comments_info count]; i++) {
        XTUserComment *userComment = [[XTUserComment alloc] init];
        
        NSString *currentComment = [user_comments_info objectAtIndex:i];
        
        NSArray *userCommentArray = [currentComment componentsSeparatedByString:@","];
        
        if ([userCommentArray count] < 5) {continue;}
        
        userComment.userID = [userCommentArray objectAtIndex:0];
        userComment.userName = [userCommentArray objectAtIndex:2];
        userComment.commentDate = [[userCommentArray objectAtIndex:3] integerValue];
        userComment.comment = [userCommentArray objectAtIndex:4];
        
        [user_comments addObject:userComment];
        
        [userComment release];
    }
    
    return user_comments;
}

- (NSMutableArray*) GetWarningsWithinRadius:(NSData*)responseData
{
    NSMutableArray *warnings = [[NSMutableArray alloc] init];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    if ([response isEqualToString:@"false"]) {return nil;}
    
    NSArray *warnings_array = [response componentsSeparatedByString:@";"];
    
    NSMutableArray *warnings_info = [NSMutableArray arrayWithArray:warnings_array];
    [warnings_info removeLastObject];
    
    for (int i = 0; i < [warnings_info count]; i++) {
        XTWarningsInfo *warningsInfo = [[XTWarningsInfo alloc] init];
        
        NSString *currentWarning = [warnings_info objectAtIndex:i];
        
        NSArray *warningsInfoArray = [currentWarning componentsSeparatedByString:@","];
        
        if ([warningsInfoArray count] < 9) {continue;}
        
        warningsInfo.userID = [warningsInfoArray objectAtIndex:0];
        warningsInfo.userName = [warningsInfoArray objectAtIndex:1];
        warningsInfo.submitDate = [warningsInfoArray objectAtIndex:2];
        warningsInfo.longitude = [[warningsInfoArray objectAtIndex:3] floatValue];
        warningsInfo.latitude = [[warningsInfoArray objectAtIndex:4] floatValue];
        warningsInfo.elevation = [[warningsInfoArray objectAtIndex:5] floatValue];
        warningsInfo.category = [[warningsInfoArray objectAtIndex:6] integerValue];
        warningsInfo.comment = [warningsInfoArray objectAtIndex:7];
        warningsInfo.distance = [[warningsInfoArray objectAtIndex:8] floatValue];
        
        [warnings addObject:warningsInfo];
        
        [warningsInfo release];
    }
    
    return warnings;
}

- (XTUserStatistics*) GetUserStatistics:(NSData*)responseData
{
    XTUserStatistics *userStatistics = [[XTUserStatistics alloc] init];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSArray *userStatistics_array = [response componentsSeparatedByString:@";"];
    
    for (int i = 0; i < [userStatistics_array count]; i++) {
        
        if ([userStatistics_array count] > 12) {return nil;}
        
        userStatistics.monthlyNumberOfTours = [[userStatistics_array objectAtIndex:0] integerValue];
        userStatistics.monthlyTime = [[userStatistics_array objectAtIndex:1] integerValue];
        userStatistics.monthlyDistance = [[userStatistics_array objectAtIndex:2] floatValue];
        userStatistics.monthlyAltitude = [[userStatistics_array objectAtIndex:3] floatValue];
        userStatistics.seasonalNumberOfTours = [[userStatistics_array objectAtIndex:4] integerValue];
        userStatistics.seasonalTime = [[userStatistics_array objectAtIndex:5] integerValue];
        userStatistics.seasonalDistance = [[userStatistics_array objectAtIndex:6] floatValue];
        userStatistics.seasonalAltitude = [[userStatistics_array objectAtIndex:7] floatValue];
        userStatistics.totalNumberOfTours = [[userStatistics_array objectAtIndex:8] integerValue];
        userStatistics.totalTime = [[userStatistics_array objectAtIndex:9] integerValue];
        userStatistics.totalDistance = [[userStatistics_array objectAtIndex:10] floatValue];
        userStatistics.totalAltitude = [[userStatistics_array objectAtIndex:11] floatValue];
    }
    
    return userStatistics;
}

- (NSMutableArray *) GetYearlyStatistics:(NSData*)responseData
{
    NSMutableArray *yearlyStatistics = nil;
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSArray *userStatistics_array = [response componentsSeparatedByString:@";"];
    
    if ([userStatistics_array count] != 53) {return nil;}
    
    yearlyStatistics = [[NSMutableArray alloc] initWithArray:userStatistics_array];
    
    [yearlyStatistics removeLastObject];
    
    yearlyStatistics = [[[yearlyStatistics reverseObjectEnumerator] allObjects] mutableCopy];
    
    return yearlyStatistics;
}

- (BOOL) SubmitImageComment:(NSString *)comment forImage:(NSString *)imageID
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/insert_image_comment.php?image=%@&comment=%@", imageID, [comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url]];
    
    [sessionTask resume];
    
    return true;
}

- (BOOL) SubmitWarningInfo:(XTWarningsInfo *)warningInfo
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/insert_warning_info.php?userID=%@&tourID=%@&date=%@&longitude=%.5f&latitude=%.5f&elevation=%.5f&category=%lu&comment=%@", warningInfo.userID, warningInfo.tourID, warningInfo.submitDate, warningInfo.longitude, warningInfo.latitude, warningInfo.elevation, (unsigned long)warningInfo.category, [warningInfo.comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url]];
    
    [sessionTask resume];
    
    return true;
}

- (BOOL) SubmitUserComment:(XTUserComment *)userComment
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/enter_new_comment.php?uid=%@&tid=%@&date=%li&name=%@&comment=%@", userComment.userID, userComment.tourID, (long)userComment.commentDate, [userComment.userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [userComment.comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url]];
    
    [sessionTask resume];
    
    return true;
}

- (void) CheckGraphsForTour:(NSString*)tourID
{
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/create_graphs.php?tid=%@", tourID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url]];
    
    [sessionTask resume];
}

- (void) DownloadFile:(NSString*)filename to:(NSString*)localFile
{
    NSString *requestString = filename;
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error) {
        if (error) {NSLog(@"There was an error downloading the file: %@", filename); return;}
        
        data = [XTDataSingleton singleObj];
        
        NSString *filePath = [data GetDocumentFilePathForFile:localFile CheckIfExist:NO];
        
        [responseData writeToFile:filePath atomically:YES];
    }];
    
    [sessionTask resume];
}

@end

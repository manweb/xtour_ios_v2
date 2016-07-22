//
//  XTFileBrowser.m
//  XTour
//
//  Created by Manuel Weber on 29/12/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTFileBrowser.h"

@implementation XTFileBrowser

- (void) CreateTourDirectory
{
    NSString *tourImagePath = [self GetDocumentFilePathForFile:@"/tours/images" CheckIfExist:NO];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tourImagePath]) {[[NSFileManager defaultManager] createDirectoryAtPath:tourImagePath withIntermediateDirectories:YES attributes:nil error:nil];}
}

- (NSString *) GetDocumentFilePathForFile:(NSString *)filename CheckIfExist:(bool)check
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *FilePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    if (check) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:FilePath]) {return nil;}
    }
    
    return FilePath;
}

- (NSString *) GetTourDocumentPath
{
    NSString *currentTour = [self GetDocumentFilePathForFile:@"/tours/" CheckIfExist:NO];
    
    return currentTour;
}

- (NSString *) GetTourImagePath
{
    NSString *imagePath = [self GetDocumentFilePathForFile:@"/tours/images/" CheckIfExist:NO];
    
    return imagePath;
}

@end

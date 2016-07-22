//
//  XTFileBrowser.h
//  XTour
//
//  Created by Manuel Weber on 29/12/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTFileBrowser : NSObject

- (void) CreateTourDirectory;
- (NSString *) GetDocumentFilePathForFile:(NSString *)filename CheckIfExist:(bool)check;
- (NSString *) GetTourDocumentPath;
- (NSString *) GetTourImagePath;

@end

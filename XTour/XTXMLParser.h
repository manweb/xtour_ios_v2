//
//  XTXMLParser.h
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import <CoreLocation/CoreLocation.h>
#import "XTImageInfo.h"
#import "XTUserInfo.h"
#import "XTSettings.h"

@interface XTXMLParser : NSObject {
    
}

@property(nonatomic,retain) GDataXMLDocument *RecoveredData;
@property(nonatomic,retain) GDataXMLElement *Metadata;
@property(nonatomic,retain) GDataXMLElement *TrackSegment;
@property(nonatomic,retain) GDataXMLElement *Images;
@property(nonatomic,retain) GDataXMLDocument *UserInfo;
@property(nonatomic,retain) NSDateFormatter *formatter;

- (void) SetMetadataString:(NSString *)value forKey:(NSString *)key;
- (void) SetMetadataDouble:(double)value forKey:(NSString *)key withPrecision:(int)precision;
- (void) SetMetadataDate:(NSDate *)date forKey:(NSString *)key;
- (void) SetMetadataBounds:(NSArray *)bounds;
- (void) AddTrackpoint:(CLLocation *)coordinate batteryLevel:(float)level;
- (void) AddTrackpoint:(CLLocation *)coordinate;
- (void) SaveXML:(NSString *)filename;
- (void) SaveRecoveryFile:(NSString *)filename;
- (void) ReadGPXFile:(NSString *)filename;
- (NSString *)GetValueFromFile:(NSString *)element;
- (NSMutableArray *)GetLocationDataFromFile;
- (NSMutableArray *)GetLocationDataFromFileAtIndex:(NSInteger)index;
- (NSString *) GetTrackTypeAtIndex:(NSInteger)index;
- (NSInteger) GetNumberOfTracksInFile;
- (void) AddImageInfo:(XTImageInfo *)imageInfo;
- (void) SaveImageInfo:(NSString *)filename;
- (XTUserInfo*) GetUserInfo:(NSString*)filename;
- (bool) WriteUserSettings:(XTSettings*)settings toFile:(NSString*)filename;
- (XTSettings*) GetUserSettings:(NSString*)filename;

@end

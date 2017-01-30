//
//  XTSingletonTimer.h
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XTXMLParser.h"
#import "XTImageInfo.h"
#import "XTUserInfo.h"
#import "XTWarningsInfo.h"
#import "XTSettings.h"
#import "XTTourInfo.h"
@import GoogleMaps;

@interface XTDataSingleton : NSObject

@property(nonatomic) NSInteger timer;
@property(nonatomic) NSInteger rateTimer;
@property(nonatomic,retain) NSMutableArray *locationData;
@property(nonatomic,retain) NSMutableArray *batteryLevel;
@property(nonatomic,retain) CLLocation *StartLocation;
@property(nonatomic,retain) CLLocation *CurrentLocation;
@property(nonatomic) int totalTime;
@property(nonatomic) double totalDistance;
@property(nonatomic) double totalAltitude;
@property(nonatomic) double totalDescent;
@property(nonatomic) double totalAverageAltitude;
@property(nonatomic) double totalCumulativeAltitude;
@property(nonatomic) double totalAverageDescent;
@property(nonatomic) double totalCumulativeDescent;
@property(nonatomic) double lastAltitude;
@property(nonatomic) double lastDescent;
@property(nonatomic) double averageAltitude;
@property(nonatomic) double sumDistance;
@property(nonatomic) double sumAltitude;
@property(nonatomic) double sumDescent;
@property(nonatomic) double sumAverageAltitude;
@property(nonatomic) double sumCumulativeAltitude;
@property(nonatomic) double sumAverageDescent;
@property(nonatomic) double sumCumulativeDescent;
@property(nonatomic,retain) CLLocation *lowestPoint;
@property(nonatomic,retain) CLLocation *highestPoint;
@property(nonatomic,retain) CLLocation *sumlowestPoint;
@property(nonatomic,retain) CLLocation *sumhighestPoint;
@property(nonatomic) double DistanceRate;
@property(nonatomic) double AltitudeRate;
@property(nonatomic) double rateLastDistance;
@property(nonatomic) double rateLastAltitude;
@property(nonatomic,retain) NSDate *startTime;
@property(nonatomic,retain) NSDate *endTime;
@property(nonatomic,retain) NSDate *TotalStartTime;
@property(nonatomic,retain) NSDate *TotalEndTime;
@property(nonatomic,retain) NSString *tourDescription;
@property(nonatomic) NSInteger tourRating;
@property(nonatomic,retain) NSString *mountainPeak;
@property(nonatomic) NSInteger averageCount;
@property(nonatomic) bool loggedIn;
@property(nonatomic,retain) NSString *userID;
@property(nonatomic,retain) NSString *tourID;
@property(nonatomic) NSInteger upCount;
@property(nonatomic) NSInteger downCount;
@property(nonatomic,retain) NSString *country;
@property(nonatomic,retain) NSString *province;
@property(nonatomic) NSInteger photoCount;
@property(nonatomic) NSInteger lastRunIndex;
@property(nonatomic,retain) NSMutableArray *imageInfo;
@property(nonatomic,retain) XTUserInfo *userInfo;
@property(nonatomic,retain) NSMutableArray *warningInfo;
@property(nonatomic) NSInteger runStatus;
@property(nonatomic) NSInteger runModus;
@property(nonatomic,retain) XTSettings *profileSettings;
@property(nonatomic) bool lowBatteryLevel;
@property(nonatomic,retain) XTTourInfo *followTourInfo;
@property(nonatomic,retain) NSMutableArray *pathSegments;
@property(nonatomic,retain) NSMutableArray *pathSegmentsPath;
@property(nonatomic) bool addedNewTrack;
@property(nonatomic,retain) NSMutableArray *segmentCoordinates;

+ (XTDataSingleton *) singleObj;

- (void) ClearData;
- (void) ResetDataForNewRun;
- (void) ResetAll;
- (void) AddCoordinate:(CLLocation *)p;
- (void) AddDistance:(double)dist andHeight:(double)height;
- (void) AddCurrentPathToSegments:(NSString*)category;
- (void) RemoveLastCoordinate;
- (double) CalculateHaversineForPoint:(CLLocation *)p1 andPoint:(CLLocation *)p2;
- (double) CalculateHaversineForCurrentCoordinate;
- (double) CalculateAltitudeDiffForCurrentCoordinate;
- (NSUInteger) GetNumCoordinates;
- (CLLocation *) GetCoordinatesAtIndex:(NSUInteger)index;
- (CLLocation *) GetLastCoordinates;
- (NSMutableArray *) GetCoordinatesForCurrentRun;
- (void) CreateTourDirectory;
- (NSMutableArray *) GetMinMaxCoordinates;
- (NSMutableArray *) GetCoordinateBounds;
- (void) CreateXMLForCategory:(NSString *)category;
- (void) WriteRecoveryFile;
- (void) RecoverTour;
- (void) RemoveRecoveryFile;
- (NSString *) GetDocumentFilePathForFile:(NSString *)filename CheckIfExist:(bool)check;
- (NSString *) GetTourDocumentPath;
- (NSString *) GetTourImagePath;
- (NSString *) GetNewPhotoName;
- (NSMutableArray *) GetAllGPXFiles;
- (NSMutableArray *) GetGPXFilesForCurrentTour;
- (NSMutableArray *) GetAllImages;
- (NSMutableArray *) GetImagesForCurrentTour;
- (NSMutableArray *) GetAllImageInfoFiles;
- (NSMutableArray *) GetWishlistGPXFiles;
- (NSInteger) GetNumberOfWishlistFiles;
- (void) CleanUpTourDirectory;
- (void) RemoveFile:(NSString*)filename;
- (NSUInteger) GetNumberOfFilesInTourDirectory;
- (void) AddImage:(XTImageInfo *)image;
- (NSUInteger) GetNumImages;
- (XTImageInfo *) GetImageInfoAt:(NSUInteger)index;
- (NSString *) GetImageFilenameAt:(NSUInteger)index;
- (float) GetImageLongitudeAt:(NSUInteger)index;
- (float) GetImageLatitudeAt:(NSUInteger)index;
- (float) GetImageElevationAt:(NSUInteger)index;
- (NSString *) GetImageCommentAt:(NSUInteger)index;
- (NSDate *) GetImageDateAt:(NSUInteger)index;
- (NSString *) GetImageLongitudeStringAt:(NSUInteger)index;
- (NSString *) GetImageLatitudeStringAt:(NSUInteger)index;
- (NSString *) GetImageCoordinateStringAt:(NSUInteger)index;
- (void) WriteImageInfo;
- (XTUserInfo*) GetUserInfo;
- (void) WriteUserSettings;
- (void) GetUserSettings;
- (void) AddWarningInfo:(XTWarningsInfo *)warningInfo;
- (void) CheckLogin;
- (void) Logout;
- (void) DeleteImageAtIndex:(NSUInteger)index;

@end

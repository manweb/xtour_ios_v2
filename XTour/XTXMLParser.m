//
//  XTXMLParser.m
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTXMLParser.h"

@implementation XTXMLParser

@synthesize Metadata;
@synthesize TrackSegment;
@synthesize Images;
@synthesize UserInfo;
@synthesize formatter;

- (XTXMLParser *) init
{
    if (self = [super init]) {
        Metadata = [GDataXMLElement elementWithName:@"Metadata"];
        TrackSegment = [GDataXMLElement elementWithName:@"trkseg"];
        Images = [GDataXMLElement elementWithName:@"images"];
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
    
    [formatter release];
}

- (void) SetMetadataString:(NSString *)value forKey:(NSString *)key
{
    if (!Metadata) {return;}
    
    GDataXMLElement *xmlElement = [GDataXMLElement elementWithName:key stringValue:value];
    
    [Metadata addChild:xmlElement];
}

- (void) SetMetadataDouble:(double)value forKey:(NSString *)key withPrecision:(int)precision
{
    if (!Metadata) {return;}
    
    NSString *precisionFormat = [NSString stringWithFormat:@"%%.%if",precision];
    
    GDataXMLElement *xmlElement = [GDataXMLElement elementWithName:key stringValue:[NSString stringWithFormat:precisionFormat, value]];
    
    [Metadata addChild:xmlElement];
}

- (void) SetMetadataDate:(NSDate *)date forKey:(NSString *)key
{
    if (!Metadata) {return;}
    if (!formatter) {return;}
    
    GDataXMLElement *xmlElement = [GDataXMLElement elementWithName:key stringValue:[formatter stringFromDate:date]];
    
    [Metadata addChild:xmlElement];
}

- (void) SetMetadataBounds:(NSArray *)bounds
{
    if (!Metadata) {return;}
    
    GDataXMLElement *Bounds = [GDataXMLElement elementWithName:@"bounds"];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"minlat" stringValue:[bounds objectAtIndex:0]]];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"minlon" stringValue:[bounds objectAtIndex:1]]];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"maxlat" stringValue:[bounds objectAtIndex:2]]];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"maxlon" stringValue:[bounds objectAtIndex:3]]];
    
    [Metadata addChild:Bounds];
}

- (void) AddTrackpoint:(CLLocation *)coordinate batteryLevel:(float)level
{
    if (!TrackSegment) {return;}
    if (!formatter) {return;}
    
    double lat = coordinate.coordinate.latitude;
    double lon = coordinate.coordinate.longitude;
    double ele = coordinate.altitude;
    NSDate *time = coordinate.timestamp;
    
    NSString *latitude = [[NSString alloc] initWithFormat:@"%f", lat];
    NSString *longitude = [[NSString alloc] initWithFormat:@"%f", lon];
    NSString *elevation = [[NSString alloc] initWithFormat:@"%f", ele];
    NSString *batteryLevel = [[NSString alloc] initWithFormat:@"%f", level];
    
    NSString *timestamp = [formatter stringFromDate:time];
    
    GDataXMLElement *TrackPoint = [GDataXMLElement elementWithName:@"trkpt"];
    [TrackPoint addAttribute:[GDataXMLNode attributeWithName:@"lat" stringValue:latitude]];
    [TrackPoint addAttribute:[GDataXMLNode attributeWithName:@"lon" stringValue:longitude]];
    
    GDataXMLElement *Elevation = [GDataXMLElement elementWithName:@"ele" stringValue:elevation];
    GDataXMLElement *Time = [GDataXMLElement elementWithName:@"time" stringValue:timestamp];
    GDataXMLElement *Battery = [GDataXMLElement elementWithName:@"battery" stringValue:batteryLevel];
    
    [TrackPoint addChild:Elevation];
    [TrackPoint addChild:Time];
    [TrackPoint addChild:Battery];
    [TrackSegment addChild:TrackPoint];
    
    [latitude release];
    [longitude release];
    [elevation release];
}

- (void) AddTrackpoint:(CLLocation *)coordinate
{
    [self AddTrackpoint:coordinate batteryLevel:-1.0];
}

- (void) SaveXML:(NSString *)filename
{
    GDataXMLElement *GPXElement = [GDataXMLNode elementWithName:@"gpx"];
    
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"version" stringValue:@"1.1"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xsi:schemaLocation" stringValue:@"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns" stringValue:@"http://www.topografix.com/GPX/1/1"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:gpxtpx" stringValue:@"http://www.garmin.com/xmlschemas/TrackPointExtension/v1"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:gpxx" stringValue:@"http://www.garmin.com/xmlschemas/GpxExtensions/v3"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:xsi" stringValue:@"http://www.w3.org/2001/XMLSchema-instance"]];
    
    GDataXMLElement *Track = [GDataXMLElement elementWithName:@"trk"];
    [Track addChild:TrackSegment];
    [GPXElement addChild:Metadata];
    [GPXElement addChild:Track];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithRootElement:GPXElement];
    
    NSData *xmlData = doc.XMLData;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    [xmlData writeToFile:documentsPath atomically:YES];
    
    [doc release];
}

- (void) SaveRecoveryFile:(NSString *)filename
{
    GDataXMLElement *GPXElement = [GDataXMLNode elementWithName:@"xml"];
    
    GDataXMLElement *Track = [GDataXMLElement elementWithName:@"trk"];
    [Track addChild:TrackSegment];
    [GPXElement addChild:Metadata];
    [GPXElement addChild:Track];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithRootElement:GPXElement];
    
    NSData *xmlData = doc.XMLData;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    [xmlData writeToFile:documentsPath atomically:YES];
    
    [doc release];
}

- (void) ReadGPXFile:(NSString *)filename
{
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filename];
    _RecoveredData = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    [xmlData release];
}

- (NSString *)GetValueFromFile:(NSString *)element
{
    if (!_RecoveredData) {return nil;}
    
    GDataXMLElement *metadata = [[_RecoveredData.rootElement elementsForName:@"Metadata"] objectAtIndex:0];
    GDataXMLElement *e = [[metadata elementsForName:element] objectAtIndex:0];
    
    return e.stringValue;
}

- (NSMutableArray *)GetLocationDataFromFile
{
    return [self GetLocationDataFromFileAtIndex:0];
}

- (NSMutableArray *) GetLocationDataFromFileAtIndex:(NSInteger)index
{
    if (!_RecoveredData) {return nil;}
    
    GDataXMLElement *trackSegment = [[_RecoveredData.rootElement elementsForName:@"trk"] objectAtIndex:0];
    NSArray *tracks = [trackSegment elementsForName:@"trkseg"];
    
    if (index > [tracks count] - 1) {return nil;}
    
    GDataXMLElement *track = [tracks objectAtIndex:index];
    
    NSArray *trackPoints = [track elementsForName:@"trkpt"];
    
    NSMutableArray *locations = [[[NSMutableArray alloc] init] autorelease];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
    
    for (GDataXMLElement *trkpt in trackPoints) {
        NSString *lat = [[trkpt attributeForName:@"lat"] stringValue];
        NSString *lon = [[trkpt attributeForName:@"lon"] stringValue];
        
        GDataXMLElement *elevation = [[trkpt elementsForName:@"ele"] objectAtIndex:0];
        GDataXMLElement *time = [[trkpt elementsForName:@"time"] objectAtIndex:0];
        
        NSString *ele = elevation.stringValue;
        NSString *t = time.stringValue;
        
        NSDate *date = [dateFormatter dateFromString:t];
        
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(lat.floatValue, lon.floatValue);
        
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinates altitude:ele.floatValue horizontalAccuracy:0 verticalAccuracy:0 timestamp:date];
        
        [locations addObject:location];
        
        [location release];
    }
    
    [dateFormatter release];
    
    return locations;
}

- (NSString *) GetTrackTypeAtIndex:(NSInteger)index
{
    if (!_RecoveredData) {return nil;}
    
    GDataXMLElement *trackSegment = [[_RecoveredData.rootElement elementsForName:@"trk"] objectAtIndex:0];
    NSArray *tracks = [trackSegment elementsForName:@"trkseg"];
    
    if (index > [tracks count] - 1) {return nil;}
    
    GDataXMLElement *track = [tracks objectAtIndex:index];
    
    return [[track attributeForName:@"type"] stringValue];
}

- (NSInteger) GetNumberOfTracksInFile
{
    if (!_RecoveredData) {return 0;}
    
    GDataXMLElement *trackSegment = [[_RecoveredData.rootElement elementsForName:@"trk"] objectAtIndex:0];
    NSArray *tracks = [trackSegment elementsForName:@"trkseg"];
    
    return [tracks count];
}

- (void) AddImageInfo:(XTImageInfo *)imageInfo
{
    GDataXMLElement *image = [GDataXMLElement elementWithName:@"image"];
    
    NSArray *fnameString = [imageInfo.Filename componentsSeparatedByString:@"/"];
    NSString *fnameOriginal = [fnameString lastObject];
    NSString *fname = [fnameOriginal stringByReplacingOccurrencesOfString:@"_original.jpg" withString:@".jpg"];
    GDataXMLElement *userID = [GDataXMLElement elementWithName:@"userID" stringValue:imageInfo.userID];
    GDataXMLElement *tourID = [GDataXMLElement elementWithName:@"tourID" stringValue:imageInfo.tourID];
    GDataXMLElement *filename = [GDataXMLElement elementWithName:@"filename" stringValue:fname];
    GDataXMLElement *longitude = [GDataXMLElement elementWithName:@"longitude" stringValue:[NSString stringWithFormat:@"%f",imageInfo.Longitude]];
    GDataXMLElement *latitude = [GDataXMLElement elementWithName:@"latitude" stringValue:[NSString stringWithFormat:@"%f",imageInfo.Latitude]];
    GDataXMLElement *elevation = [GDataXMLElement elementWithName:@"elevation" stringValue:[NSString stringWithFormat:@"%f",imageInfo.Elevation]];
    GDataXMLElement *comment = [GDataXMLElement elementWithName:@"comment" stringValue:imageInfo.Comment];
    GDataXMLElement *date = [GDataXMLElement elementWithName:@"date" stringValue:[formatter stringFromDate:imageInfo.Date]];
    
    [image addChild:userID];
    [image addChild:tourID];
    [image addChild:filename];
    [image addChild:longitude];
    [image addChild:latitude];
    [image addChild:elevation];
    [image addChild:comment];
    [image addChild:date];
    
    [Images addChild:image];
}

- (void) SaveImageInfo:(NSString *)filename
{
    GDataXMLElement *XMLElement = [GDataXMLNode elementWithName:@"xml"];
    
    [XMLElement addChild:Images];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithRootElement:XMLElement];
    
    NSData *xmlData = doc.XMLData;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    [xmlData writeToFile:documentsPath atomically:YES];
    
    [doc release];
}

- (XTUserInfo*) GetUserInfo:(NSString*)filename
{
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filename];
    GDataXMLDocument *userInfoFile = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    GDataXMLElement *userInfo = [[userInfoFile.rootElement elementsForName:@"userdata"] objectAtIndex:0];
    
    XTUserInfo *info = [[[XTUserInfo alloc] init] autorelease];
    
    info.userID = [[[userInfo elementsForName:@"userID"] objectAtIndex:0] stringValue];
    info.userName = [[[userInfo elementsForName:@"userName"] objectAtIndex:0] stringValue];
    info.dateJoined = [[[userInfo elementsForName:@"dateJoined"] objectAtIndex:0] stringValue];
    info.home = [[[userInfo elementsForName:@"home"]objectAtIndex:0] stringValue];
    
    [xmlData release];
    [userInfoFile release];
    
    return info;
}

- (bool) WriteUserSettings:(XTSettings*)settings toFile:(NSString*)filename
{
    GDataXMLElement *XMLElement = [GDataXMLNode elementWithName:@"xml"];
    
    GDataXMLElement *userSettings = [GDataXMLElement elementWithName:@"userSettings"];
    
    NSString *equipment;
    NSString *saveOriginalImage = @"0";
    NSString *anonymousTracking = @"0";
    NSString *safetyModus = @"0";
    NSString *batterySafeModus = @"0";
    
    switch (settings.equipment) {
        case 0:
            equipment = @"0";
            break;
        case 1:
            equipment = @"1";
            break;
        case 2:
            equipment = @"2";
            break;
    }
    
    if (settings.saveOriginalImage) {saveOriginalImage = @"1";}
    if (settings.anonymousTracking) {anonymousTracking = @"1";}
    if (settings.safetyModus) {safetyModus = @"1";}
    if (settings.batterySafeMode) {batterySafeModus = @"1";}
    
    GDataXMLElement *elementEquipment = [GDataXMLElement elementWithName:@"equipment" stringValue:equipment];
    GDataXMLElement *elementSaveOriginalImage = [GDataXMLElement elementWithName:@"saveOriginalImage" stringValue:saveOriginalImage];
    GDataXMLElement *elementAnonymousTracking = [GDataXMLElement elementWithName:@"anonymousTracking" stringValue:anonymousTracking];
    GDataXMLElement *elementSafetyModus = [GDataXMLElement elementWithName:@"safetyModus" stringValue:safetyModus];
    GDataXMLElement *elementBatterySafeModus = [GDataXMLElement elementWithName:@"batterySafeModus" stringValue:batterySafeModus];
    
    [userSettings addChild:elementEquipment];
    [userSettings addChild:elementSaveOriginalImage];
    [userSettings addChild:elementAnonymousTracking];
    [userSettings addChild:elementSafetyModus];
    [userSettings addChild:elementBatterySafeModus];
    
    [XMLElement addChild:userSettings];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithRootElement:XMLElement];
    
    NSData *xmlData = doc.XMLData;
    
    bool success = [xmlData writeToFile:filename atomically:YES];
    
    [doc release];
    
    NSLog(@"Writing settings file: %@ %@ %@ %@ %@",equipment,saveOriginalImage,anonymousTracking,safetyModus,batterySafeModus);
    return success;
}

- (XTSettings*) GetUserSettings:(NSString*)filename
{
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filename];
    GDataXMLDocument *userSettingsFile = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    GDataXMLElement *userSettings = [[userSettingsFile.rootElement elementsForName:@"userSettings"] objectAtIndex:0];
    
    XTSettings *settings = [[[XTSettings alloc] init] autorelease];
    
    GDataXMLElement *equipment = [[userSettings elementsForName:@"equipment"] objectAtIndex:0];
    GDataXMLElement *saveOriginalImage = [[userSettings elementsForName:@"saveOriginalImage"] objectAtIndex:0];
    GDataXMLElement *anonymousTracking = [[userSettings elementsForName:@"anonymousTracking"] objectAtIndex:0];
    GDataXMLElement *safetyModus = [[userSettings elementsForName:@"safetyModus"] objectAtIndex:0];
    GDataXMLElement *batterySafeModus = [[userSettings elementsForName:@"batterySafeModus"] objectAtIndex:0];
    
    settings.equipment = [equipment.stringValue integerValue];
    
    settings.saveOriginalImage = false;
    if ([saveOriginalImage.stringValue isEqualToString:@"1"]) {settings.saveOriginalImage = true;}
    
    settings.anonymousTracking = false;
    if ([anonymousTracking.stringValue isEqualToString:@"1"]) {settings.anonymousTracking = true;}
    
    settings.safetyModus = false;
    if ([safetyModus.stringValue isEqualToString:@"1"]) {settings.safetyModus = true;}
    
    settings.batterySafeMode = false;
    if ([batterySafeModus.stringValue isEqualToString:@"1"]) {settings.batterySafeMode = true;}
    
    NSLog(@"Getting user settings: %li %@ %@ %@ %@",(long)settings.equipment,saveOriginalImage.stringValue,anonymousTracking.stringValue,safetyModus.stringValue,batterySafeModus.stringValue);
    return settings;
}

@end

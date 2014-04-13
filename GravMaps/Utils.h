//
//  Utils.h
//  GravMaps
//
//  Created by Antonio Scardigno on 12/04/14.
//  Copyright (c) 2014 almamaveg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Utils : NSObject

@property (nonatomic, retain) NSString *someProperty;

+ (id)sharedUtils;

- (GMSMarker*) setMarkerOnMap:(GMSMapView *)maps latitude:(float)latitude longitude:(float)longitude title:(NSString *)title snippet:(NSString *)snippet;

-(float) returnLastGravity;

-(void) putLastGravity:(float)gravity;
@end
//
//  Utils.m
//  GravMaps
//
//  Created by Antonio Scardigno on 12/04/14.
//  Copyright (c) 2014 almamaveg. All rights reserved.
//

#import "Utils.h"

@implementation Utils{
  float lastGravity;
}


#pragma mark Singleton Methods

+ (id)sharedUtils {
  static Utils *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

- (GMSMarker*) setMarkerOnMap:(GMSMapView *)maps latitude:(float)latitude longitude:(float)longitude title:(NSString *)title snippet:(NSString *)snippet{
  
  GMSMarker *marker = [[GMSMarker alloc] init];
  marker.position = CLLocationCoordinate2DMake(latitude, longitude);
  marker.title = title;
  marker.snippet = snippet;
  marker.map = maps;
  return marker;
}

-(float) returnLastGravity{
  return lastGravity;
}

-(void) putLastGravity:(float)gravity{
  lastGravity = gravity;
}
@end

//
//  MyAnnotation.m
//  GravMaps
//
//  Created by Antonio Scardigno on 13/04/14.
//  Copyright (c) 2014 almamaveg. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

//3.2
-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
  if ((self = [super init])) {
    self.coordinate =coordinate;
    self.title = title;
  }
  return self;
}

@end
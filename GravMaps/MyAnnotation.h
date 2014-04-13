//
//  MyAnnotation.h
//  GravMaps
//
//  Created by Antonio Scardigno on 13/04/14.
//  Copyright (c) 2014 almamaveg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//3.1
@interface MyAnnotation : MKAnnotationView
@property (strong, nonatomic) NSString *title;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;
@end
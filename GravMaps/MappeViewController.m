//
//  ViewController.m
//  GravMaps
//
//  Created by Antonio Scardigno on 12/04/14.
//  Copyright (c) 2014 almamaveg. All rights reserved.
//

#import "MappeViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <math.h>
#import "Utils.h"
#import "MyAnnotation.h"
#import <MBProgressHUD.h>

#define METERS_PER_MILE 1609.344

@interface MappeViewController (){
  Utils *utils;
  GMSMarker* marker;
  MyAnnotation *annotation;
  MBProgressHUD *hud;
  BOOL tastieraAperta;
}

@end

@implementation MappeViewController{
  GMSMapView *mapView_;
  CLGeocoder *geocoder;
  CLPlacemark *placemark;
}

- (void)viewDidLoad{
  [super viewDidLoad];
  tastieraAperta = false;
  hud = [[MBProgressHUD alloc] initWithView:self.view];
  hud.labelText = @"";
  [self.view addSubview:hud];
  annotation = [[MyAnnotation alloc] init];
  
  annotation.image = [UIImage imageNamed:@"marker"];
  
  utils = [Utils sharedUtils];
  
  UITapGestureRecognizer *longPressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePressGesture:)];
  [self.mapView addGestureRecognizer:longPressGesture];
  
  locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  locationManager.distanceFilter = kCLDistanceFilterNone;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [locationManager startUpdatingLocation];
  
  // Do any additional setup after loading the view, typically from a nib.
  //4
  self.mapView.delegate = self;
  //5
  
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
  
  // If it's the user location, just return nil.
  if ([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
  
    // Try to dequeue an existing pin view first.
    MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
    if (!pinView)
    {
      // If an existing pin view was not available, create one.
      pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
      //pinView.animatesDrop = YES;
      pinView.canShowCallout = YES;
      pinView.image = [UIImage imageNamed:@"marker"];
      pinView.calloutOffset = CGPointMake(0, 32);
    } else {
      pinView.annotation = annotation;
    }
    return pinView;
  
  return nil;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  
  float alt = newLocation.altitude;
  float gravita = (9.780327*(1+0.0053024*pow(sin(oldLocation.coordinate.latitude),2)-0.0000058*pow(sin(2*oldLocation.coordinate.latitude),2)) - 0.000003086*alt);
  
  CLLocationCoordinate2D zoomLocation;
  zoomLocation.latitude = newLocation.coordinate.latitude;
  zoomLocation.longitude= newLocation.coordinate.longitude;
  
  [self setCenterCoordinate:zoomLocation zoomLevel:13 animated:YES];

  annotation.coordinate = zoomLocation;
  annotation.image = [UIImage imageNamed:@"marker"];
  self.lblGravita.text = [NSString stringWithFormat:@"%f", gravita];
  [[Utils sharedUtils]putLastGravity:gravita];

  [self.mapView addAnnotation:annotation];
  
  [locationManager stopUpdatingLocation];
  
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
                  zoomLevel:(NSUInteger)zoom animated:(BOOL)animated
{
  MKCoordinateSpan span = MKCoordinateSpanMake(180 / pow(2, zoom) *
                                               self.mapView.frame.size.height / 256, 0);
  [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:animated];
}

-(void)handlePressGesture:(UIGestureRecognizer*)sender {
  if (tastieraAperta){
    [self.txtCerca resignFirstResponder];
    tastieraAperta = false;
    return;
  }
  
  [hud show:YES];
  // This is important if you only want to receive one tap and hold event
  // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
  CGPoint point = [sender locationInView:self.mapView];
  CLLocationCoordinate2D zoomLocation = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
  
  [self setCenterCoordinate:zoomLocation zoomLevel:13 animated:YES];
  NSString *urlAsString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/elevation/json?locations=%f,%f&sensor=true", zoomLocation.latitude, zoomLocation.longitude];
  NSURL *url = [[NSURL alloc] initWithString:urlAsString];
  NSLog(@"%@", urlAsString);
  
  [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    
    [hud hide:YES];
    if (error) {
      NSLog(@"ERRORE");
      self.lblGravita.text= @"C'è stato un errore riprova";
    } else {
      NSLog(@"aaa");
      
      NSMutableDictionary *allCourses = [NSJSONSerialization
                                         JSONObjectWithData:data
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
      
      annotation.coordinate = zoomLocation;
      annotation.image = [UIImage imageNamed:@"marker"];
      float alt = [[[[allCourses objectForKey:@"results"] objectAtIndex:0] objectForKey:@"elevation"] floatValue];
      float gravita = (9.780327*(1+0.0053024*pow(sin(zoomLocation.latitude),2)-0.0000058*pow(sin(2*zoomLocation.latitude),2)) - 0.000003086*alt);
      self.lblGravita.text= [NSString stringWithFormat:@"%f", gravita];
      [[Utils sharedUtils]putLastGravity:gravita];
      [self.mapView addAnnotation:annotation];
    }
  }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  tastieraAperta = true;
  return YES;
}

// It is important for you to hide kwyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  
  NSString *string = [textField text];
  NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
  if ([trimmedString isEqualToString:@""]) return NO;
  [hud show:YES];
  NSString *urlAsString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", [self.txtCerca.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
  NSURL *url = [[NSURL alloc] initWithString:urlAsString];
  NSLog(@"%@", urlAsString);
  
  [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    
    if (error) {
      NSLog(@"ERRORE");
      self.lblGravita.text= @"C'è stato un errore riprova";
      [hud hide:YES];
    } else {
      
      NSMutableDictionary *citta = [NSJSONSerialization
                                         JSONObjectWithData:data
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
      
      NSString *status = [citta objectForKey:@"status"];
      
      if (![status isEqualToString:@"OK"]){
        [hud hide:YES];
        return;
      }
      
      NSMutableArray *results = [citta objectForKey:@"results"];
      
      
      NSMutableDictionary *primaCitta = [results objectAtIndex:0];
      
      NSMutableDictionary *geometry = [primaCitta objectForKey:@"geometry"];
      
      NSMutableDictionary *location = [geometry objectForKey:@"location"];
      
      float lat = [[location objectForKey:@"lat"] floatValue];
      
      float lng = [[location objectForKey:@"lng"] floatValue];
      
      
      CLLocationCoordinate2D zoomLocation;
      zoomLocation.latitude = lat;
      zoomLocation.longitude= lng;
      
      [self setCenterCoordinate:zoomLocation zoomLevel:13 animated:YES];
      NSString *urlAsString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/elevation/json?locations=%f,%f&sensor=true", zoomLocation.latitude, zoomLocation.longitude];
      NSURL *url = [[NSURL alloc] initWithString:urlAsString];
      NSLog(@"%@", urlAsString);
      
      [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [hud hide:YES];
        if (error) {
          NSLog(@"ERRORE");
          self.lblGravita.text= @"C'è stato un errore riprova";
        } else {
          NSLog(@"aaa");
          
          NSMutableDictionary *allCourses = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:NSJSONReadingMutableContainers
                                             error:&error];
          
          annotation.coordinate = zoomLocation;
          float alt = [[[[allCourses objectForKey:@"results"] objectAtIndex:0] objectForKey:@"elevation"] floatValue];
          float gravita = (9.780327*(1+0.0053024*pow(sin(zoomLocation.latitude),2)-0.0000058*pow(sin(2*zoomLocation.latitude),2)) - 0.000003086*alt);
          self.lblGravita.text= [NSString stringWithFormat:@"%f", gravita];
          [[Utils sharedUtils]putLastGravity:gravita];

          [self.mapView addAnnotation:annotation];
        }
      }];
      
    }
  }];
  return YES;
}

- (IBAction)button_click:(UIBarButtonItem *)sender {
  if (sender == self.searchButton){
    [self textFieldShouldReturn:self.txtCerca];
  }else if (sender == self.geoLocalizeButton){
    [locationManager startUpdatingLocation];
  }
}
@end

//
//  ViewController.h
//  GravMaps
//
//  Created by Antonio Scardigno on 12/04/14.
//  Copyright (c) 2014 almamaveg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MappeViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate> {
  CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *geoLocalizeButton;
@property (weak, nonatomic) IBOutlet UITextField *txtCerca;
@property (weak, nonatomic) IBOutlet UILabel *lblGravita;
- (IBAction)button_click:(UIBarButtonItem *)sender;
@end

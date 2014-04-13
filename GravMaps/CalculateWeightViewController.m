//
//  CalculateWeightViewController.m
//  GravMaps
//
//  Created by Antonio Scardigno on 13/04/14.
//  Copyright (c) 2014 almamaveg. All rights reserved.
//

#import "CalculateWeightViewController.h"
#import "Utils.h"

@interface CalculateWeightViewController ()

@end

@implementation CalculateWeightViewController{
  NSArray *pianeti, *valoreGravita;
  float dividendo;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  pianeti = @[@"Last gravity force selected", @"Mercury", @"Venus", @"Mars", @"Jupiter", @"Saturn", @"Uranus", @"Neptune", @"Moon", @"Pluto", @"Sun"];
  
  float lastGravity = [[Utils sharedUtils] returnLastGravity];
  dividendo = lastGravity;
  
  valoreGravita = @[@(lastGravity), @3.70f, @8.87f, @3.71f,
                      @23.12f, @8.96f, @8.69, @11.0f, @1.6249, @0.610, @274.1];
  
  
  self.lblWhere.userInteractionEnabled = YES;
  UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(whereTapped)];
  
  dividendo = [valoreGravita[0] floatValue];
  float peso = [self.txtWeight.text floatValue];
  
  float pesoNuovo = peso/9.81*dividendo;
  
  self.lblPeso.text = [NSString stringWithFormat:@"%f", pesoNuovo];
  
  [self.lblWhere addGestureRecognizer:r];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Label taps

-(void) whereTapped {
  NSLog(@"ljhbvfcd");
  [UIView animateWithDuration:0.5f
                   animations:^{
                     CGRect r = self.pickerWhere.frame;
                     CGRect screenRect = [[UIScreen mainScreen] bounds];
                     CGFloat screenHeight = screenRect.size.height;
                     r.origin.y = screenHeight-r.size.height-64;
                     self.pickerWhere.frame = r;
                     [self.txtWeight resignFirstResponder];
                   }
   ];
  
}


#pragma mark - Text field delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
  
  [UIView animateWithDuration:0.5f
                   animations:^{
                     CGRect r = self.pickerWhere.frame;
                     r.origin.y = 1000;
                     self.pickerWhere.frame = r;
                     [self.txtWeight becomeFirstResponder];
                   }];
  
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
  return pianeti.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
  return pianeti[row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component{
  
  dividendo = [valoreGravita[row] floatValue];
  float peso = [self.txtWeight.text floatValue];
  
  float pesoNuovo = peso/9.81*dividendo;
  
  self.lblPeso.text = [NSString stringWithFormat:@"%f", pesoNuovo];
  
}
- (IBAction)textFieldEditingChanged:(UITextField *)sender {
  
  float peso = [self.txtWeight.text floatValue];
  
  float pesoNuovo = peso/9.81*dividendo;
  
  self.lblPeso.text = [NSString stringWithFormat:@"%f", pesoNuovo];
}
@end

//
//  CalculateWeightViewController.h
//  GravMaps
//
//  Created by Antonio Scardigno on 13/04/14.
//  Copyright (c) 2014 almamaveg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculateWeightViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblWhere;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerWhere;

@property (weak, nonatomic) IBOutlet UILabel *lblPeso;
- (IBAction)textFieldEditingChanged:(UITextField *)sender;
@end

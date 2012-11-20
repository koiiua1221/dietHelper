//
//  KMViewController.h
//  dietHelper
//
//  Created by KoujiMiura on 2012/11/14.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GradientButton.h"
#define KM_PICKER_HEIGHT      100
#define KM_PICKER_WEIGHT      320
#define KM_FOOTER_HEIGHT      50
#define KM_FOOTER_WEIGHT      320
#define FOOTER_BUTTON_HEIGHT  42//KM_FOOTER_HEIGHT-1-1
#define FOOTER_BUTTON_WEIGHT  90
#define FOOTER_BUTTON_NUM     2


@interface KMViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
//@property (retain, nonatomic) IBOutlet GradientButton *saveButton;
//- (IBAction)touched:(id)sender;
@end

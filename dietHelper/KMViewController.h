//
//  KMViewController.h
//  dietHelper
//
//  Created by KoujiMiura on 2012/11/14.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WeightData.h"

#define KM_PICKER_HEIGHT      90
#define KM_PICKER_WEIGHT      320

@interface KMViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
  WeightData *_WeightData;
}
@property (nonatomic, retain) WeightData* WeightData;

@end

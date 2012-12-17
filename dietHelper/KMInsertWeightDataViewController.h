//
//  KMInsertWeightDataViewController.h
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/14.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WeightData.h"
#define KM_PICKER_HEIGHT      90
#define KM_PICKER_WEIGHT      320

#define KM_PICKER_TAG_WEIGHT 0
#define KM_PICKER_TAG_DATE 1

@interface KMInsertWeightDataViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
  id  __unsafe_unretained _delegate;
  WeightData *_WeightData;
}
@property (nonatomic, retain) WeightData* WeightData;
@property (unsafe_unretained) id delegate;
// デリゲートメソッド
@end
@interface NSObject (KMInsertWeightDataViewControllerDelegate)

- (void)InsertWeightDataViewControllerDidCancel:(KMInsertWeightDataViewController*)controller;
- (void)InsertWeightDataViewControllerDidSave:(KMInsertWeightDataViewController*)controller;

@end

//
//  KMInsertWeightDataView.h
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/14.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define WEIGHT_VIEW_TAG (100)
#define WEIGHT_VIEW_WIDTH (300)
#define WEIGHT_LBL_LENGTH (WEIGHT_VIEW_WIDTH/6)
#define DATE_LBL_WIDTH (WEIGHT_VIEW_WIDTH)
#define DATE_LBL_HEIGHT (15)
#define WEIGHT_VIEW_HEIGHT (WEIGHT_LBL_LENGTH+DATE_LBL_HEIGHT)

#define WEIGHT_LBL_TAG 200


@interface KMInsertWeightDataView : UIView
{
  UILabel *weight100Label;
  UILabel *weight10Label;
  UILabel *weight1Label;
  UILabel *weight01Label;
  UILabel *dayLabel;
}
@property (nonatomic, retain) UILabel *weight100Label;
@property (nonatomic, retain) UILabel *weight10Label;
@property (nonatomic, retain) UILabel *weight1Label;
@property (nonatomic, retain) UILabel *weight01Label;
@property (nonatomic, retain) UILabel *dayLabel;

@end

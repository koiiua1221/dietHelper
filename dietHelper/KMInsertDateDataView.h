//
//  KMInsertDateDataView.h
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/17.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define DATE_LBL_LEN (50)

@interface KMInsertDateDataView : UIView
{
  UILabel *yearLabel;
  UILabel *monthLabel;
  UILabel *dayLabel;
  UILabel *nenLabel;
  UILabel *tsukiLabel;
  UILabel *hiLabel;
}
@property (nonatomic, retain) UILabel *yearLabel;
@property (nonatomic, retain) UILabel *monthLabel;
@property (nonatomic, retain) UILabel *dayLabel;
- (void)setBorderColor:(CGColorRef)cgColor;

@end

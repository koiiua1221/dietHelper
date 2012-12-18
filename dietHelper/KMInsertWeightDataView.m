//
//  KMInsertWeightDataView.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/14.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMInsertWeightDataView.h"

@implementation KMInsertWeightDataView

@synthesize weight100Label;
@synthesize weight10Label;
@synthesize weight1Label;
@synthesize weight01Label;
@synthesize dayLabel;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.tag = WEIGHT_VIEW_TAG;
    
    UILabel *tmpLbl[6];
    for (int i = 0; i < 6; i++) {
      tmpLbl[i]= [[UILabel alloc]initWithFrame:CGRectMake(0+(i*WEIGHT_LBL_LENGTH), 0, WEIGHT_LBL_LENGTH, WEIGHT_LBL_LENGTH)];
      tmpLbl[i].backgroundColor = [UIColor grayColor];
      switch (i) {
        case 3:
          tmpLbl[i].text = @".";
          break;
        case 5:
          tmpLbl[i].text = @"kg";
          break;
        default:
          tmpLbl[i].text = @"-";
          break;
      }
      tmpLbl[i].textColor = [UIColor whiteColor];
      tmpLbl[i].textAlignment = UITextAlignmentCenter;
      tmpLbl[i].font = [UIFont boldSystemFontOfSize:15];
      
      tmpLbl[i].layer.borderColor = [UIColor whiteColor].CGColor;
      tmpLbl[i].layer.borderWidth = 1.0;
      [self addSubview:tmpLbl[i]];
      tmpLbl[i].userInteractionEnabled=YES;
      tmpLbl[i].tag = WEIGHT_LBL_TAG+i;
    }
    self.weight100Label = tmpLbl[0];
    self.weight10Label = tmpLbl[1];
    self.weight1Label = tmpLbl[2];
    self.weight01Label = tmpLbl[4];
    self->commaLabel = tmpLbl[3];
    self->kgLable = tmpLbl[5];
  }
  return self;
}
- (void)setBorderColor:(CGColorRef)cgColor
{
  self.weight100Label.layer.borderColor = cgColor;
  self.weight10Label.layer.borderColor = cgColor;
  self.weight1Label.layer.borderColor = cgColor;
  self.weight01Label.layer.borderColor = cgColor;
  self->commaLabel.layer.borderColor = cgColor;
  self->kgLable.layer.borderColor = cgColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

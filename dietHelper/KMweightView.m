//
//  KMweightView.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/10.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMweightView.h"

@implementation KMweightView
@synthesize weight100Label;
@synthesize weight10Label;
@synthesize weight1Label;
@synthesize weight01Label;
@synthesize dayLabel;
@synthesize commaLabel;
@synthesize kgLabel;

- (id)initWithFrame:(CGRect)frame borderColor:(CGColorRef)borderColor textColor:(UIColor*)textColor;
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.tag = WEIGHT_VIEW_TAG;
    
    UILabel *tmpLbl[6];
    for (int i = 0; i < 6; i++) {
      tmpLbl[i]= [[UILabel alloc]initWithFrame:CGRectMake(0+(i*WEIGHT_LBL_LENGTH), DATE_LBL_HEIGHT, WEIGHT_LBL_LENGTH, WEIGHT_LBL_LENGTH)];
      tmpLbl[i].backgroundColor = [UIColor grayColor];
      switch (i) {
        case 3:
          tmpLbl[i].text = @".";
          break;
        case 5:
          tmpLbl[i].text = @"kg";
          break;
        default:
          tmpLbl[i].text = @"0";
          break;
      }
      tmpLbl[i].textColor = textColor;
      tmpLbl[i].textAlignment = UITextAlignmentCenter;
      tmpLbl[i].font = [UIFont boldSystemFontOfSize:15];
      
      tmpLbl[i].layer.borderColor = borderColor;
      tmpLbl[i].layer.borderWidth = 1.0;
      [self addSubview:tmpLbl[i]];
      tmpLbl[i].userInteractionEnabled=YES;
      tmpLbl[i].tag = WEIGHT_LBL_TAG+i;
    }
    self.weight100Label = tmpLbl[0];
    self.weight10Label = tmpLbl[1];
    self.weight1Label = tmpLbl[2];
    self.commaLabel = tmpLbl[3];
    self.weight01Label = tmpLbl[4];
    self.kgLabel = tmpLbl[5];
    
    self.dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DATE_LBL_WIDTH, DATE_LBL_HEIGHT)];
    self.dayLabel.backgroundColor = [UIColor clearColor];
    self.dayLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.dayLabel];
  }
  return self;
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

//
//  KMInsertDateDataView.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/17.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMInsertDateDataView.h"

@implementation KMInsertDateDataView

@synthesize yearLabel;
@synthesize monthLabel;
@synthesize dayLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      self.backgroundColor = [UIColor clearColor];
      self.userInteractionEnabled = YES;
      UILabel *tmpLbl[6];
      for (int i = 0; i < 6; i++) {
        tmpLbl[i]= [[UILabel alloc]initWithFrame:CGRectMake(0+(i*DATE_LBL_LEN), 0, DATE_LBL_LEN, DATE_LBL_LEN)];
        tmpLbl[i].backgroundColor = [UIColor grayColor];
        switch (i) {
          case 1:
            tmpLbl[i].text = @"年";
            break;
          case 3:
            tmpLbl[i].text = @"月";
            break;
          case 5:
            tmpLbl[i].text = @"日";
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
      }
      self.yearLabel = tmpLbl[0];
      self.monthLabel = tmpLbl[2];
      self.dayLabel = tmpLbl[4];
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

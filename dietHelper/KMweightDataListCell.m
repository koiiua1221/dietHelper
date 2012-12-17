//
//  KMweightDataListCell.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/12/13.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMweightDataListCell.h"

@implementation KMweightDataListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      self.textLabel.textColor = [UIColor whiteColor];
      self.backgroundColor=[UIColor clearColor];
      self.textLabel.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect
{
  self.textLabel.textColor = [UIColor whiteColor];
  self.backgroundColor=[UIColor clearColor];
  self.textLabel.backgroundColor=[UIColor clearColor];
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = self.bounds;
  gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor], nil];
  [self.layer insertSublayer: gradient atIndex: 0];
}
@end

//
//  KMCustomButton.m
//  dietHelper
//
//  Created by KoujiMiura on 2012/11/14.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMCustomButton.h"

@implementation KMCustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
      self.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
      [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      [self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
      [self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
  [super setHighlighted:highlighted];
  [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected{
  [super setSelected:selected];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
  CGContextRef c = UIGraphicsGetCurrentContext();
  CGFloat w = self.bounds.size.width;
  CGFloat h = self.bounds.size.height;
  CGFloat r = h/4;
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  CGContextSaveGState(c);
  CGContextSetShouldAntialias(c, true);
  
  // 角丸の描画領域を設定
  CGRect rc = CGRectMake(0, 0, w, h);
  CGContextMoveToPoint(c, CGRectGetMinX(rc), CGRectGetMaxY(rc)-r);
  CGContextAddArcToPoint(c, CGRectGetMinX(rc), CGRectGetMinY(rc), CGRectGetMidX(rc), CGRectGetMinY(rc), r);
  CGContextAddArcToPoint(c, CGRectGetMaxX(rc), CGRectGetMinY(rc), CGRectGetMaxX(rc), CGRectGetMidY(rc), r);
  CGContextAddArcToPoint(c, CGRectGetMaxX(rc), CGRectGetMaxY(rc), CGRectGetMidX(rc), CGRectGetMaxY(rc), r);
  CGContextAddArcToPoint(c, CGRectGetMinX(rc), CGRectGetMaxY(rc), CGRectGetMinX(rc), CGRectGetMidY(rc), r);
  CGContextClip(c);
  
  // CGGradientを生成する
  // 生成するためにCGColorSpaceと色データの配列が必要になるので適当に用意する
  CGFloat locations[2] = {0.0, 1.0};
  size_t num_locations = 2;
  CGGradientRef gradient;
  if (self.state && (UIControlStateSelected || UIControlStateHighlighted)) {
    CGFloat components[8] = {0.45, 0.45, 0.45, 1.0, 0.28, 0.28, 0.28, 1.0};
    gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, num_locations);
  } else {
    CGFloat components[8] = {0.9, 0.9, 0.9, 1.0, 0.73, 0.73, 0.73, 1.0};
    gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, num_locations);
  }
  
  // 生成したCGGradientを描画する
  // 始点と終点を指定してやると、その間に直線的なグラデーションが描画される。
  CGPoint startPoint = CGPointMake(w/2, 0.0);
  CGPoint endPoint = CGPointMake(w/2, h);
  CGContextDrawLinearGradient(c, gradient, startPoint, endPoint, 0);
  
  CGContextRestoreGState(c);
  
  [super drawRect:rect];
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

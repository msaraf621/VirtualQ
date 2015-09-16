//
//  Created by Alberto Pasca on 27/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APRoundedButton.h"
#import <QuartzCore/QuartzCore.h>


@implementation APRoundedButton{
  UILabel *titleLabel;

}
@synthesize shapeFillColor;
@synthesize  shapeStrokColor;
- (void)awakeFromNib
{
  [super awakeFromNib];
  [self drawButton];


}
/*-(void)addCustomLabel{
  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x, self.center.y, 50, 50)];
  titleLabel.center=[self center];
 // titleLabel.text = @"Next";
  titleLabel.textColor = [UIColor blackColor];
 // titleLabel.textAlignment = UITextAlignmentCenter;
  
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0];
  titleLabel.hidden = NO;
 
  [self addSubview:titleLabel];

  [self setNeedsDisplay];
} */
- (void)drawButton{
  
  UIRectCorner corners;
  CGSize cornerRadii = CGSizeMake(20.0, 30.0);
  
  switch ( self.style )
  {
    case 0:
      corners = UIRectCornerBottomLeft;
      break;
    case 1:
      corners = UIRectCornerBottomRight;
      break;
    case 2:
      corners = UIRectCornerTopLeft;
      break;
    case 3:
      corners = UIRectCornerTopRight;
      break;
    case 4:
      corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
      break;
    case 5:
      corners = UIRectCornerTopLeft | UIRectCornerTopRight;
      break;
    case 6:
      corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
      break;
    case 7:
      corners = UIRectCornerBottomRight | UIRectCornerTopRight;
      break;
    case 8:
      corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
      break;
    case 9:
      corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
      break;
    case 10:
      corners = UIRectCornerAllCorners;
      cornerRadii = CGSizeMake(self.frame.size.width/2, self.frame.size.height/2);
      break;
    case 11:
      corners = UIRectCornerAllCorners;
      cornerRadii = CGSizeMake(self.frame.size.width/2, self.frame.size.height/2);
      break;
   case 12:
      corners = UIRectCornerAllCorners;
      cornerRadii = CGSizeMake(self.frame.size.width/2, self.frame.size.height/2);
      break;
    case 13:
      corners = UIRectCornerAllCorners;
      cornerRadii = CGSizeMake(self.frame.size.width/2, self.frame.size.height/2);
      break;
  default:
      corners = UIRectCornerAllCorners;
      cornerRadii = CGSizeMake(20.0, 30.0);
      break;
  }

  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:corners
                                                       cornerRadii:cornerRadii];
  CAShapeLayer *maskLayer = [CAShapeLayer layer];
  maskLayer.frame         = self.bounds;
  maskLayer.path          = maskPath.CGPath;
  self.layer.mask         = maskLayer;
  cornerRadii = CGSizeZero;
  
}

- (void)drawRect:(CGRect)rect {
  [self drawButton];

  if(!self.shapeFillColor){
    shapeFillColor = [UIColor whiteColor];
  }
  if(!self.shapeStrokColor){
    shapeStrokColor = [UIColor whiteColor];
  }
  
  [self.shapeStrokColor setStroke];
  [self.shapeFillColor setFill];

  if(self.style == 11){
    CGFloat marginX = self.frame.size.width/6;
    CGFloat signWidth = marginX*4;
    
    CGFloat signHeight = marginX*0.75;
    CGFloat marginY = (self.frame.size.height - signHeight) /2;
    
    UIBezierPath *minusSymbol = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(marginX, marginY, signWidth, signHeight) cornerRadius:2.5];
    
    //draw the path
    [minusSymbol fill];
    [minusSymbol stroke];
  }

  if(self.style == 12){
    CGFloat marginX = self.frame.size.width/6;
    CGFloat signWidth = marginX*4;
    
    CGFloat signHeight = marginX*0.75;
    CGFloat marginY = (self.frame.size.height - signHeight) /2;
    
    UIBezierPath *plusVerticalSymbol = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(marginX, marginY, signWidth, signHeight) cornerRadius:2.5];

    UIBezierPath *plusHorizontalSymbol = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(marginY, marginX, signHeight,signWidth) cornerRadius:2.5];

    //draw the path
    [plusVerticalSymbol fill];
    [plusVerticalSymbol stroke];
    [plusHorizontalSymbol fill];
    [plusHorizontalSymbol stroke];

  }
  
  if(self.style==13){
    CGFloat centerX=self.frame.size.width/2;
    CGFloat centerY=self.frame.size.height/2;
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(centerX, centerY)];
    [bezierPath addLineToPoint:CGPointMake(5,centerY)];
    [bezierPath addLineToPoint:CGPointMake(centerX+((centerX*1.75)/3),centerY-((centerY*1.75)/3))];
    [bezierPath addLineToPoint:CGPointMake(centerX,centerY*2-5)];
    [bezierPath addLineToPoint:CGPointMake(centerX, centerY)];
    
    [[UIColor whiteColor] setFill];
    [[UIColor whiteColor] setStroke];
    
    [bezierPath fill];
  
    bezierPath.lineWidth = 1;
    [bezierPath stroke];

  }

}

-(void)setShapeStrokColor:(UIColor*)color{
  shapeStrokColor = color;
  [self setNeedsDisplay];
}

-(void)setShapeFillColor:(UIColor*)color{
  shapeFillColor = color;
  [self setNeedsDisplay];
}

-(void)setTitleOfButton:(NSString*)title{
  self.titleLabel.text=title;
  [self setTitle:title forState:UIControlStateNormal]; //  titleLabel.text=title;
  self.titleLabel.textColor=[UIColor blackColor];
  [self setNeedsDisplay];
}

@end



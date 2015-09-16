//
//  CounterView.m
//  VirtualQ
//
//  Created by GrepRuby on 14/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "CounterView.h"

@implementation CounterView

@synthesize shapeFillColor;
@synthesize  shapeStrokColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)drawRect:(CGRect)rect {
  
  if(!self.shapeFillColor){
    shapeFillColor = [UIColor whiteColor];
  }
  if(!self.shapeStrokColor){
    shapeStrokColor = [UIColor whiteColor];
  }
  
  [self.shapeStrokColor setStroke];
  [self.shapeFillColor setFill];

  CGFloat radius = UNI_VAL(3, 2.5);
  CGFloat marginLetfRight = 10.0;
  CGFloat distance = UNI_VAL(15.0,12.0);
  CGFloat marginTop = 15.0;
  
  int circleCount = (self.frame.size.width/2 - marginLetfRight) / distance;
  for (int i=0; i<circleCount ; i++) {
    CGFloat nextPointXLeft  = marginLetfRight + (distance * i);
    CGFloat nextPointXRight = self.frame.size.width - nextPointXLeft;
    
    
    UIBezierPath *circleLeftPath= [UIBezierPath bezierPathWithArcCenter:CGPointMake(nextPointXLeft+radius , marginTop) radius:radius startAngle:0 endAngle:360 clockwise:true];
    
    
    UIBezierPath *circleRightPath= [UIBezierPath bezierPathWithArcCenter:CGPointMake(nextPointXRight-radius , marginTop) radius:radius startAngle:0 endAngle:360 clockwise:true];
    
    [circleLeftPath fill];
    [circleLeftPath stroke];
    [circleRightPath fill];
    [circleRightPath stroke];
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
  


@end
